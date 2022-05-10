import 'package:expense_notes/routes.dart';
import 'package:expense_notes/style/theme_config.dart';
import 'package:expense_notes/style/custom_theme.dart';
import 'package:flutter/material.dart';
import 'package:expense_notes/view/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Routes routes = Routes();

  @override
  void initState() {
    super.initState();
    currentTheme.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: CustomTheme.lightTheme,
      darkTheme: CustomTheme.darkTheme,
      themeMode: currentTheme.currentTheme,
      initialRoute: Routes.ROOT,
      onGenerateRoute: (settings) => routes.routePage(settings),
      home: const HomeScreen(),
    );
  }
}
