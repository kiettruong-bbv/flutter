import 'package:flutter/material.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Setting'),
        backgroundColor: theme.primaryColor,
      ),
      body: const Center(
        child: Text('SETTING'),
      ),
    );
  }
}
