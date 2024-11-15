import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

enum AppThemeMode { light, dark, system }

class SettingsModel extends ChangeNotifier with WidgetsBindingObserver {
  bool initialized = false;
  AppThemeMode theme = AppThemeMode.system;
  Brightness themeBrightness = SchedulerBinding.instance.platformDispatcher.platformBrightness;

  SettingsModel() {
    WidgetsBinding.instance.addObserver(this);
  }

  void changeTheme(AppThemeMode newTheme) {
    theme = newTheme;

    if (theme == AppThemeMode.system) {
      themeBrightness = SchedulerBinding.instance.platformDispatcher.platformBrightness;
    } else {
      themeBrightness = theme == AppThemeMode.light ? Brightness.light : Brightness.dark;
    }

    notifyListeners();
  }

  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();
    if (theme == AppThemeMode.system) {
      themeBrightness = SchedulerBinding.instance.platformDispatcher.platformBrightness;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
