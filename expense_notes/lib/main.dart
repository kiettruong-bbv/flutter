import 'package:dio/dio.dart';
import 'package:expense_notes/api/auth_api.dart';
import 'package:expense_notes/api/expense_api.dart';
import 'package:expense_notes/bloc/chart/chart_cubit.dart';
import 'package:expense_notes/bloc/expense/expense_list_cubit.dart';
import 'package:expense_notes/bloc/root/root_cubit.dart';
import 'package:expense_notes/bloc/root/root_state.dart';
import 'package:expense_notes/bloc/signIn/sign_in_cubit.dart';
import 'package:expense_notes/bloc/signUp/sign_up_cubit.dart';
import 'package:expense_notes/bloc/theme/theme_cubit.dart';
import 'package:expense_notes/bloc/theme/theme_state.dart';
import 'package:expense_notes/repository/auth_repository.dart';
import 'package:expense_notes/repository/expense_repository.dart';
import 'package:expense_notes/routes.dart';
import 'package:expense_notes/services/dio_client.dart';
import 'package:expense_notes/view/auth/sign_in_screen.dart';
import 'package:expense_notes/view/auth/sign_up_screen.dart';
import 'package:expense_notes/view/expense/expense_detail_screen.dart';
import 'package:expense_notes/view/home_screen.dart';
import 'package:expense_notes/view/setting_screen.dart';
import 'package:expense_notes/view/splash_screen.dart';
import 'package:expense_notes/widget/platform_widget/platform_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    MultiBlocProvider(
      providers: [
        BlocProvider<RootCubit>(
          create: (context) => RootCubit(),
        ),
        BlocProvider<ThemeCubit>(
          create: (context) => ThemeCubit()..initTheme(),
        ),
        BlocProvider<SignInCubit>(
          create: (context) => SignInCubit(authRepository),
        ),
        BlocProvider<SignUpCubit>(
          create: (context) => SignUpCubit(authRepository),
        ),
        BlocProvider<ExpenseListCubit>(
          create: (context) => ExpenseListCubit(expenseRepository),
        ),
        BlocProvider<ChartCubit>(
          create: (context) => ChartCubit(),
        )
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

  @override
  void initState() {
    BlocProvider.of<RootCubit>(context).initRoot();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RootCubit, RootState>(
      builder: (context, rootState) {
        return BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, themeState) {
            Widget home = const SplashScreen();

            if (rootState is Authenticated) {
              home = const HomeScreen();
            } else if (rootState is Unauthenticated) {
              home = const SignInScreen();
            }

            return PlatformApp(
              themeMode: BlocProvider.of<ThemeCubit>(context).currentTheme,
              routes: {
                Routes.signIn: (context) => const SignInScreen(),
                Routes.signUp: (context) => const SignUpScreen(),
                Routes.home: (context) => const HomeScreen(),
                Routes.setting: (context) => const SettingScreen(),
                Routes.detail: (context) => const DetailScreen(),
              },
              home: home,
            );
          },
        );
      },
    );
  }
}
