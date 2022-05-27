import 'package:expense_notes/constants/storage_key.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

class ThemeManager with ChangeNotifier {
  final LocalStorage _storage = LocalStorage(StorageKey.app);

  ThemeMode _currentTheme = ThemeMode.system;

  ThemeMode get currentTheme => _currentTheme;

  Future setupTheme() async {
    await _storage.ready;
    String? theme = _storage.getItem(StorageKey.themeMode);

    if (theme != null) {
      switch (theme) {
        case 'light':
          _currentTheme = ThemeMode.light;
          break;
        case 'dark':
          _currentTheme = ThemeMode.dark;
          break;
        default:
          _currentTheme = ThemeMode.system;
      }
    }
    notifyListeners();
  }

  void toggleTheme(ThemeMode themeMode) {
    _currentTheme = themeMode;
    _storage.setItem(StorageKey.themeMode, _currentTheme.name);
    notifyListeners();
  }
}
