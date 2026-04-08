import 'package:flutter/material.dart';
import 'package:freelance_app/preferences.dart';

class ProviderTheme extends ChangeNotifier{
  bool _isDark = false;

  bool get isDark => _isDark;

  ProviderTheme (){
    _loadTheme();
  }

  Future<void> _loadTheme() async{
    _isDark = await StorageService.loadThemMode();
    notifyListeners();
  }

  Future<void> toogleTheme() async{
    _isDark = !_isDark;
    await StorageService.saveThemMode(_isDark);
    notifyListeners();
  }

  ThemeMode get themeMode => _isDark ? ThemeMode.dark : ThemeMode.light;
}