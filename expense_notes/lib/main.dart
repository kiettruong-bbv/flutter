import 'package:expense_notes/constants/storage_key.dart';
import 'package:expense_notes/model/chart_model.dart';
import 'package:expense_notes/model/expense_model.dart';
import 'package:expense_notes/routes.dart';
import 'package:expense_notes/service/expense_repository.dart';
import 'package:expense_notes/style/theme_manager.dart';
import 'package:expense_notes/view/expense_detail_screen.dart';
import 'package:expense_notes/view/home_screen.dart';
import 'package:expense_notes/view/setting_screen.dart';
import 'package:expense_notes/view/splash_screen.dart';
import 'package:expense_notes/widget/platform_widget/platform_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ExpenseModel(HttpExpenseRepository()),
        ),
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
    await _authenticateFirebase();
  }

  Future _authenticateFirebase() async {
    await FirebaseAuth.instance.signOut();

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: "test@gmail.com",
        password: "123456",
      );

      final String? idToken = await userCredential.user?.getIdToken();
      if (idToken != null) {
        await LocalStorage(StorageKey.app).setItem(StorageKey.token, idToken);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
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
