import 'package:flutter/material.dart';
import 'custom_colors.dart';

class CustomTheme with ChangeNotifier {
  static bool _isDarkTheme = false;
  ThemeMode get currentTheme => _isDarkTheme ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() {
    _isDarkTheme = !_isDarkTheme;
    notifyListeners();
  }

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: CustomColors.purple,
      backgroundColor: CustomColors.white,
      scaffoldBackgroundColor: CustomColors.white,
      fontFamily: 'Montserrat',
      textTheme: ThemeData.light().textTheme.copyWith(
            button: const TextStyle(
              color: CustomColors.white,
            ),
          ),
      buttonTheme: ButtonThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
        buttonColor: CustomColors.purple,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: CustomColors.purple,
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          primary: CustomColors.white,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          primary: CustomColors.purple,
          onSurface: CustomColors.black,
        ),
      ),
      colorScheme: ColorScheme.fromSwatch().copyWith(
        secondary: CustomColors.black,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      primaryColor: CustomColors.purple,
      backgroundColor: CustomColors.darkGrey,
      scaffoldBackgroundColor: CustomColors.black,
      fontFamily: 'Montserrat',
      textTheme: ThemeData.dark().textTheme.copyWith(
            button: const TextStyle(
              color: CustomColors.white,
            ),
          ),
      buttonTheme: ButtonThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
        buttonColor: CustomColors.purple,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: CustomColors.purple,
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          primary: CustomColors.white,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          primary: CustomColors.purple,
          onSurface: CustomColors.white,
        ),
      ),
      colorScheme: ColorScheme.fromSwatch().copyWith(
        secondary: CustomColors.white,
      ),
    );
  }
}
