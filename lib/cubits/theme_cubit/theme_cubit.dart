import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.light) {
    _loadTheme();
  }

  static const String _themeBoxName = 'themeBox';
  static const String _themeKey = 'isDarkMode';

  // تحميل الثيم المحفوظ
  void _loadTheme() async {
    final box = await Hive.openBox(_themeBoxName);
    final isDark = box.get(_themeKey, defaultValue: false);
    emit(isDark ? ThemeMode.dark : ThemeMode.light);
    _updateSystemUI(isDark);
  }

  // تبديل الثيم
  void toggleTheme() async {
    final isDark = state == ThemeMode.dark;
    emit(isDark ? ThemeMode.light : ThemeMode.dark);

    // حفظ التفضيل
    final box = await Hive.openBox(_themeBoxName);
    box.put(_themeKey, !isDark);

    // تحديث Status Bar
    _updateSystemUI(!isDark);
  }

  // تحديث شريط الحالة (Status Bar)
  void _updateSystemUI(bool isDark) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // شفاف
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
      ),
    );
  }

  bool get isDarkMode => state == ThemeMode.dark;
}
