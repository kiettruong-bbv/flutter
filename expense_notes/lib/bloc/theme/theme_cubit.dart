import 'package:expense_notes/bloc/theme/theme_state.dart';
import 'package:expense_notes/constants/storage_key.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localstorage/localstorage.dart';

class ThemeCubit extends Cubit<ThemeState> {
  final LocalStorage _storage = LocalStorage(StorageKey.app);
  ThemeMode _currentTheme = ThemeMode.light;

  ThemeCubit() : super(ThemeInitial());

  ThemeMode get currentTheme => _currentTheme;

  Future initTheme() async {
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
    emit(ThemeUpdated(themeMode: _currentTheme));
  }

  Future toggleTheme(ThemeMode themeMode) async {
    _currentTheme = themeMode;
    await _storage.setItem(StorageKey.themeMode, _currentTheme.name);
    emit(ThemeUpdated(themeMode: _currentTheme));
  }
}
