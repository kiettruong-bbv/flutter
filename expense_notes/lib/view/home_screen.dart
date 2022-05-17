import 'package:expense_notes/extension/platform_extension.dart';
import 'package:expense_notes/widget/app_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final CupertinoThemeData cupertinoThemeData = CupertinoTheme.of(context);

    Color backgroundColor = isIOS()
        ? cupertinoThemeData.scaffoldBackgroundColor
        : theme.scaffoldBackgroundColor;

    TextStyle? textStyle = isIOS()
        ? cupertinoThemeData.textTheme.textStyle
        : theme.textTheme.bodyText1;

    return Scaffold(
      backgroundColor: backgroundColor,
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Home Screen'),
        backgroundColor: theme.primaryColor,
        // actions: [
        //   IconButton(
        //     onPressed: () => currentTheme.toggleTheme(),
        //     icon: const Icon(Icons.brightness_4),
        //   )
        // ],
      ),
      body: Center(
        child: Text(
          'Home Screen',
          style: textStyle,
        ),
      ),
    );
  }
}
