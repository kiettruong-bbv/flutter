import 'package:expense_notes/constants/storage_key.dart';
import 'package:expense_notes/routes.dart';
import 'package:expense_notes/style/my_theme.dart';
import 'package:expense_notes/utils/storage_utils.dart';
import 'package:expense_notes/widget/platform_widget/platform_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

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
      initialRoute: _hasSignedIn() ? Routes.home : Routes.signIn,
    );
  }

  @override
  CupertinoApp createIosWidget(BuildContext context) {
    final brightness = SchedulerBinding.instance!.window.platformBrightness;
    CupertinoThemeData? theme;

    if (themeMode == ThemeMode.light) {
      theme = MyTheme.cupertinoLightTheme;
    } else if (themeMode == ThemeMode.dark) {
      theme = MyTheme.cupertinoDarkTheme;
    } else {
      theme = brightness == Brightness.dark
          ? MyTheme.cupertinoDarkTheme
          : MyTheme.cupertinoLightTheme;
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
      initialRoute: _hasSignedIn() ? Routes.home : Routes.signIn,
    );
  }

  bool _hasSignedIn() {
    final String? auth = StorageUtils.getItem(StorageKey.auth);
    return auth != null;
  }
}
