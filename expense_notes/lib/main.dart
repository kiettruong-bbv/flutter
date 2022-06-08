import 'package:dio/dio.dart';
import 'package:expense_notes/api/auth_api.dart';
import 'package:expense_notes/api/expense_api.dart';
import 'package:expense_notes/model/auth_model.dart';
import 'package:expense_notes/model/chart_model.dart';
import 'package:expense_notes/model/expense_model.dart';
import 'package:expense_notes/repository/auth_repository.dart';
import 'package:expense_notes/repository/expense_repository.dart';
import 'package:expense_notes/routes.dart';
import 'package:expense_notes/services/dio_client.dart';
import 'package:expense_notes/style/theme_manager.dart';
import 'package:expense_notes/view/auth/sign_in_screen.dart';
import 'package:expense_notes/view/auth/sign_up_screen.dart';
import 'package:expense_notes/view/expense/expense_detail_screen.dart';
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

  final dio = Dio();
  final dioClient = DioClient(dio);

  final authRepository = HttpAuthRepository(
    authApi: AuthApi(dioClient: dioClient),
  );

  final expenseRepository = HttpExpenseRepository(
    expenseApi: ExpenseApi(dioClient: dioClient),
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthModel(authRepository),
        ),
        ChangeNotifierProvider(
          create: (context) => ExpenseModel(expenseRepository),
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
    context.read<AuthModel>().checkIfUserSignedIn();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Consumer2<ThemeManager, AuthModel>(
            builder: (context, themeManager, authModel, _) {
              return PlatformApp(
                themeMode: themeManager.currentTheme,
                routes: {
                  Routes.signIn: (context) => const SignInScreen(),
                  Routes.signUp: (context) => const SignUpScreen(),
                  Routes.home: (context) => const HomeScreen(),
                  Routes.setting: (context) => const SettingScreen(),
                  Routes.detail: (context) => const DetailScreen(),
                },
                home: authModel.isSignedIn
                    ? const HomeScreen()
                    : const SignInScreen(),
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
