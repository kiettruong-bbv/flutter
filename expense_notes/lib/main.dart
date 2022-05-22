import 'package:expense_notes/model/transaction_model.dart';
import 'package:expense_notes/routes.dart';
import 'package:expense_notes/style/theme_manager.dart';
import 'package:expense_notes/view/splash_screen.dart';
import 'package:expense_notes/widget/platform_widget/platform_app.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TransactionModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future _initFuture = AppInit.initialize();

  Routes routes = Routes();

  @override
  void initState() {
    super.initState();

    ThemeManager.instance.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return PlatformApp(
            routes: routes,
            themeMode: ThemeManager.instance.getThemeMode(),
          );
        } else {
          return const SplashScreen();
        }
      },
    );
  }
}

class AppInit {
  static Future initialize() async {
    await ThemeManager.instance.setupTheme();
  }
}
