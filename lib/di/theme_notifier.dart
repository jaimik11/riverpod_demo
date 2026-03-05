import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../constants/app_constants.dart';
import '../constants/storage_constants.dart';
import '../enums/language_code.dart';
import '../src/data/repository/local/local_repository.dart';
import 'app_providers.dart';
part 'theme_notifier.g.dart';


@riverpod
class ThemeNotifier extends _$ThemeNotifier {
  LocalRepository? localRepository;
  ThemeMode? appThemeMode;

/*  @override
  Future<ThemeMode> build() async{
    return ThemeMode(await ref.read(localRepositoryProvider).getData(StorageConstants.theme) ?? AppConstants.defaultTheme);
  }*/

  @override
  Future<ThemeMode> build() async {
    localRepository = ref.read(localRepositoryProvider);
    appThemeMode = await getInitialThemeMode();
    return appThemeMode!;
  }

  /// Load theme from local or default to light theme
  Future<ThemeMode> getInitialThemeMode() async {
    /*bool isDarkMode = PlatformDispatcher.instance.platformBrightness == Brightness.dark;
    // bool isDarkMode = await _isDarkMode();
    print("isDarkModeisDarkModeisDarkMode $isDarkMode");
    ThemeMode newTheme = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    Get.changeThemeMode(newTheme); // */
    bool isDarkMode = await _isDarkMode();
    print("isDarkMode $isDarkMode");
    updateThemeNotifier(isDarkMode);
    return isDarkMode ? ThemeMode.dark : ThemeMode.light;
  }

  /// Toggle between light and dark theme and store locally
  Future<void> switchTheme() async {
    bool isDarkMode = await _isDarkMode();
    print("isDarkMode $isDarkMode");

    // state = AsyncData(isDarkMode ? ThemeMode.light : ThemeMode.dark);
    await _saveThemeMode(!isDarkMode) ?? false;
  }

  /// Check theme mode from local storage
  Future<bool> _isDarkMode() async {
    return await localRepository?.getData(StorageConstants.isDarkMode) ?? false;
  }

  /// Save the theme mode to local storage
  Future<bool?> _saveThemeMode(bool isDarkMode) async {
    updateThemeNotifier(isDarkMode);
    return await localRepository?.setData(
      StorageConstants.isDarkMode,
      isDarkMode,
    );
  }

  updateThemeNotifier(bool isDarkMode) async {
    AppConstants.defaultTheme = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    state = AsyncData(!isDarkMode ? ThemeMode.light : ThemeMode.dark);
  }
}

