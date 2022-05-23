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
        ChangeNotifierProvider(create: (context) => ThemeManager()),
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
  Routes routes = Routes();
  late Future _initFuture;

  @override
  void initState() {
    super.initState();
    _initFuture = _initializeApp();
  }

  Future _initializeApp() async {
    await context.read<ThemeManager>().setupTheme();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Consumer<ThemeManager>(
            builder: (context, themeManager, widget) {
              return PlatformApp(
                routes: routes,
                themeMode: context.read<ThemeManager>().themeMode,
              );
            },
          );
        } else {
          return const SplashScreen();
        }
      },
    );
  }
}
