import 'package:expense_notes/widget/app_drawer.dart';
import 'package:expense_notes/widget/platform_widget/platform_theme.dart';
import 'package:flutter/material.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PlatformTheme theme = PlatformTheme(context);

    return Scaffold(
      drawer: const AppDrawer(current: Section.settings),
      backgroundColor: theme.getBackgroundColor(),
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Center(
        child: Text(
          'SETTINGS',
          style: theme.getDefaultTextStyle(),
        ),
      ),
    );
  }
}
