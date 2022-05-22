import 'package:expense_notes/routes.dart';
import 'package:expense_notes/view/transaction_list_screen.dart';
import 'package:expense_notes/widget/platform_widget/platform_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlatformApp extends PlatformWidget<CupertinoApp, MaterialApp> {
  final Routes routes;

  const PlatformApp({
    Key? key,
    required this.routes,
  }) : super(key: key);

  @override
  MaterialApp createAndroidWidget(BuildContext context) {
    return MaterialApp(
      title: 'Expense Note',
      theme: ThemeData(
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system,
      initialRoute: Routes.ROOT,
      onGenerateRoute: (settings) => routes.routePage(settings),
      home: const TransactionListScreen(),
    );
  }

  @override
  CupertinoApp createIosWidget(BuildContext context) {
    return CupertinoApp(
      title: 'Expense Note',
      localizationsDelegates: const [
        DefaultMaterialLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate,
      ],
      initialRoute: Routes.ROOT,
      onGenerateRoute: (settings) => routes.routePage(settings),
      home: const TransactionListScreen(),
    );
  }
}
