// ignore_for_file: constant_identifier_names

import 'package:expense_notes/view/detail_screen.dart';
import 'package:expense_notes/view/setting_screen.dart';
import 'package:expense_notes/view/transaction_list_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Routes {
  static const String ROOT = '/';
  static const String TRANSACTION_LIST_SCREEN = '/transaction_list_screen';
  static const String DETAIL_SCREEN = '/detail_screen';
  static const String SETTING_SCREEN = '/setting_screen';

  CupertinoPageRoute routePage(RouteSettings settings) {
    return CupertinoPageRoute(
      settings: settings,
      builder: (BuildContext context) {
        switch (settings.name) {
          case ROOT:
            return const TransactionListScreen();
          case TRANSACTION_LIST_SCREEN:
            return const TransactionListScreen();
          case DETAIL_SCREEN:
            return DetailScreen(
              args: settings.arguments as DetailScreenArguments,
            );
          case SETTING_SCREEN:
            return const SettingScreen();
        }

        return const Scaffold();
      },
    );
  }
}
