import 'package:expense_notes/model/chart_model.dart';
import 'package:expense_notes/model/expense_model.dart';
import 'package:expense_notes/routes.dart';
import 'package:expense_notes/style/theme_manager.dart';
import 'package:expense_notes/view/expense_detail_screen.dart';
import 'package:expense_notes/view/home_screen.dart';
import 'package:expense_notes/view/setting_screen.dart';
import 'package:expense_notes/view/splash_screen.dart';
import 'package:expense_notes/widget/platform_widget/platform_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ExpenseModel()),
        ChangeNotifierProvider(create: (context) => ChartModel()),
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
                themeMode: context.read<ThemeManager>().currentTheme,
                routes: {
                  Routes.home: (context) => const HomeScreen(),
                  Routes.setting: (context) => const SettingScreen(),
                  Routes.detail: (context) => const DetailScreen(),
                },
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
