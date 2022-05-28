import 'package:expense_notes/style/my_theme.dart';
import 'package:expense_notes/view/expense_list.dart';
import 'package:expense_notes/view/home.dart';
import 'package:expense_notes/widget/platform_widget/platform_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlatformApp extends PlatformWidget<CupertinoApp, MaterialApp> {
  final Map<String, WidgetBuilder> routes;
  final ThemeMode themeMode;

  const PlatformApp({
    Key? key,
    required this.themeMode,
    required this.routes,
  }) : super(key: key);

  @override
  MaterialApp createAndroidWidget(BuildContext context) {
    return MaterialApp(
      title: 'Expense Note',
      theme: MyTheme.lightTheme,
      darkTheme: MyTheme.darkTheme,
      themeMode: themeMode,
      routes: routes,
      home: const HomeScreen(),
    );
  }

  @override
  CupertinoApp createIosWidget(BuildContext context) {
    CupertinoThemeData? theme;

    if (themeMode == ThemeMode.light) {
      theme = MyTheme.cupertinoLightTheme;
    } else if (themeMode == ThemeMode.dark) {
      theme = MyTheme.cupertinoDarkTheme;
    }

    return CupertinoApp(
      title: 'Expense Note',
      localizationsDelegates: const [
        DefaultMaterialLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate,
      ],
      theme: theme,
      routes: routes,
      home: const HomeScreen(),
    );
  }
}
