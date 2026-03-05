import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../constants/app_constants.dart';
import '../constants/storage_constants.dart';
import '../enums/language_code.dart';
import '../src/data/repository/local/local_repository.dart';
import 'app_providers.dart';
part 'local_notifier.g.dart';


@riverpod
class LocaleNotifier extends _$LocaleNotifier {
  LocalRepository? localRepository = ProviderContainer().read(localRepositoryProvider);

  @override
  Future<Locale> build() async{
    Locale currentLocale = await getCurrentLocale();
    AppConstants.currentLocale = currentLocale.languageCode == 'en'  ? LanguageCode.en : LanguageCode.ar;
    print("currentLocale $currentLocale");
    return currentLocale;
   // return Locale(await ref.read(localRepositoryProvider).getData(StorageConstants.locale) ?? AppConstants.defaultLocale.name);
  }

  getCurrentLocale() async{
    return Locale(await ref.read(localRepositoryProvider).getData(StorageConstants.locale) ?? AppConstants.defaultLocale.name);
  }

  void changeLocale({required LanguageCode lang}){
    localRepository!.setData(StorageConstants.locale, lang.name);
    state = AsyncData(Locale(lang.name));
    AppConstants.currentLocale = lang;
  }

}

