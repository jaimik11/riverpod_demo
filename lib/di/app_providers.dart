

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../app.dart';
import '../constants/api_constants.dart';
import '../constants/app_constants.dart';
import '../constants/storage_constants.dart';
import '../services/api_service/api_interceptor.dart';
import '../services/api_service/api_service.dart';
import '../services/dynamic_links_service/deep_links.dart';
import '../src/data/repository/local/local_repository.dart';
import '../src/data/repository/local/local_repository_impl.dart';
import '../src/data/repository/remote/remote_repository.dart';
import '../src/data/repository/remote/remote_repository_impl.dart';
import '../services/my_notification_manager.dart';
import '../utils/logger_util.dart';
part 'app_providers.g.dart';

@riverpod
void mainInit (Ref ref) async{

  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,name: Platform.isAndroid ? null : "C2C");
  // App Orientation
  SystemChrome.setPreferredOrientations(
    // kDebugMode ? [DeviceOrientation.portraitDown] :
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  );

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      // top status bar color
      statusBarColor: Colors.transparent,

      // android status bar icon brightness - dark (for black icons), light (for light icons)
      statusBarIconBrightness: Brightness.dark,

      // android bottom navigation bar color
      systemNavigationBarColor: Colors.black,
    ),
  );

  // ErrorWidget.builder = (FlutterErrorDetails details) => ErrorCrashWidget(details);
  Hive.init((await getApplicationDocumentsDirectory()).path);
  // Hive.registerAdapter(UserModelImplAdapter()); // 👈 Register the adapter

  await Future.wait( [

    Hive.openBox(StorageConstants.boxName),
    ref.read(notificationManagerProvider).init()
  ] );

  /// 👇 Deep Link Initialization
  final deepLink = await ref.read(deepLinkingProvider).initDeepLinking();

  /// 👇 Save it to a provider for use in the c2c
  ref.read(deepLinkUriProvider.notifier).state = deepLink;
  print("deeplink URL. 00 ${deepLink}");

  runApp( const ProviderScope ( child:  App() ));
}

@riverpod
Dio apiClient(Ref ref){
  Dio dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(minutes: 1),
      receiveTimeout: const Duration(minutes: 1),
      sendTimeout: const Duration(minutes: 1),
    ),

  )..interceptors.add(ApiInterceptors());
  return dio;
}

// @Riverpod(keepAlive: true)
// SocketService socketService(Ref ref){
//   final localRepository = ref.read(localRepositoryProvider);
//   return SocketService(localRepository: localRepository);
// }


@riverpod
ApiServices apiServices(Ref ref){
  final dioClient = ref.read(apiClientProvider);
  return ApiServices(dioClient,baseUrl: ApiConstants.basURL);
}

@riverpod
RemoteRepository remoteRepository(Ref ref){
  final apiServices = ref.read(apiServicesProvider);
  return RemoteRepositoryImpl(apiServices: apiServices);
}


@riverpod
LocalRepository localRepository(_){
  return LocalRepositoryImpl();
}

@riverpod
MyNotificationManager notificationManager(_){
  return MyNotificationManager();
}


@riverpod
Stream<bool> getConnectivity(Ref ref){
  final connectionChecker = InternetConnectionChecker.instance;
    return connectionChecker.onStatusChange.map((convert){
      AppConstants.isNetworkConnected = convert == InternetConnectionStatus.connected;
      //logger.e("📡 $convert internet connection ${AppConstants.isNetworkConnected}");

      return convert == InternetConnectionStatus.connected;
    });
}


@Riverpod(keepAlive: true)
DeepLinking deepLinking(Ref ref) {
  final instance = DeepLinking();
  ref.onDispose(instance.dispose);
  return instance;
}

@riverpod
Future<Uri?> initialDeepLink(Ref ref) async {
  final deepLinking = ref.watch(deepLinkingProvider);
  return await deepLinking.initDeepLinking();
}

@riverpod
class DeepLinkUri extends _$DeepLinkUri {
  @override
  Uri? build() => null;

  void set(Uri? uri) => state = uri;
}

