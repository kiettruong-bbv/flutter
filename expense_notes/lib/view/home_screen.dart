import 'package:expense_notes/widget/app_drawer.dart';
import 'package:flutter/material.dart';
import '../style/theme_config.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Transaction List'),
        backgroundColor: theme.primaryColor,
        actions: [
          IconButton(
            onPressed: () => currentTheme.toggleTheme(),
            icon: const Icon(Icons.brightness_4),
          )
        ],
      ),
      body: const Center(
        child: Text('Home Screen'),
      ),
    );
  }
}
