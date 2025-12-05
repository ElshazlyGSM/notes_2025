import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:notes_2025/constants.dart';

enum ThemeOption {
  light, // فاتح دائماً
  dark, // داكن دائماً
  system, // حسب الجهاز
}

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.system) {
    _loadTheme();
  }

  static const String _themeKey = 'themeOption';

  ThemeOption _currentOption = ThemeOption.system;
  ThemeOption get currentOption => _currentOption;

  // تحميل الثيم المحفوظ
  void _loadTheme() async {
    final box = Hive.box(settingBoxName);

    final savedOption = box.get(_themeKey, defaultValue: 'system');

    switch (savedOption) {
      case 'light':
        _currentOption = ThemeOption.light;
        emit(ThemeMode.light);
        break;
      case 'dark':
        _currentOption = ThemeOption.dark;
        emit(ThemeMode.dark);
        break;
      default:
        _currentOption = ThemeOption.system;
        emit(ThemeMode.system);
    }
  }

  // تغيير الثيم
  void setTheme(ThemeOption option) async {
    _currentOption = option;

    switch (option) {
      case ThemeOption.light:
        emit(ThemeMode.light);
        break;
      case ThemeOption.dark:
        emit(ThemeMode.dark);
        break;
      case ThemeOption.system:
        emit(ThemeMode.system);
        break;
    }

    // حفظ الاختيار
    final box = Hive.box(settingBoxName);

    box.put(_themeKey, option.name);
  }

  // تبديل سريع (للزر القديم)
  void toggleTheme() {
    if (_currentOption == ThemeOption.light) {
      setTheme(ThemeOption.dark);
    } else {
      setTheme(ThemeOption.light);
    }
  }
}
