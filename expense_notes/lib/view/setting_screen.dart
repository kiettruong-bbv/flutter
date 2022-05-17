import 'package:expense_notes/widget/platform_widget/platform_theme.dart';
import 'package:flutter/material.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PlatformTheme theme = PlatformTheme.instance;

    return Scaffold(
      backgroundColor: theme.getBackgroundColor(context),
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Center(
        child: Text(
          'SETTINGS',
          style: theme.getDefaultTextStyle(context),
        ),
      ),
    );
  }
}
