import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'my_colors.dart';

class MyTheme with ChangeNotifier {
  static bool _isDarkTheme = false;
  ThemeMode get currentTheme => _isDarkTheme ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() {
    _isDarkTheme = !_isDarkTheme;
    notifyListeners();
  }

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: MyColors.purple,
      primaryColorLight: Colors.white,
      backgroundColor: Colors.white,
      scaffoldBackgroundColor: Colors.white,
      unselectedWidgetColor: Colors.black,
      fontFamily: 'Montserrat',
      textTheme: ThemeData.light().textTheme.copyWith(
            button: const TextStyle(
              color: Colors.white,
            ),
          ),
      buttonTheme: ButtonThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
        buttonColor: MyColors.purple,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: MyColors.purple,
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          primary: MyColors.purple,
          onSurface: Colors.black,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          primary: MyColors.purple,
          onSurface: Colors.black,
        ),
      ),
      iconTheme: const IconThemeData(
        color: Colors.black,
      ),
      colorScheme: const ColorScheme.dark().copyWith(
        onPrimary: Colors.white,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      primaryColor: MyColors.purple,
      primaryColorLight: Colors.white,
      backgroundColor: MyColors.darkGrey,
      scaffoldBackgroundColor: Colors.grey.shade900,
      unselectedWidgetColor: Colors.white,
      fontFamily: 'Montserrat',
      textTheme: ThemeData.dark().textTheme.copyWith(
            button: const TextStyle(
              color: Colors.white,
            ),
          ),
      buttonTheme: ButtonThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
        buttonColor: MyColors.purple,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: MyColors.purple,
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          primary: Colors.white,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          primary: MyColors.purple,
          onSurface: Colors.white,
        ),
      ),
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
      colorScheme: const ColorScheme.light().copyWith(
        onPrimary: Colors.white,
      ),
    );
  }

  static CupertinoThemeData get cupertinoLightTheme {
    return const CupertinoThemeData(
      primaryColor: MyColors.purple,
      primaryContrastingColor: Colors.white,
      scaffoldBackgroundColor: Colors.white,
      barBackgroundColor: MyColors.purple,
      brightness: Brightness.light,
    );
  }

  static CupertinoThemeData get cupertinoDarkTheme {
    return CupertinoThemeData(
      primaryColor: MyColors.purple,
      primaryContrastingColor: Colors.white,
      scaffoldBackgroundColor: Colors.grey.shade900,
      barBackgroundColor: MyColors.purple,
      brightness: Brightness.dark,
    );
  }
}
