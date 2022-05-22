import 'package:expense_notes/style/theme_manager.dart';
import 'package:expense_notes/widget/app_drawer.dart';
import 'package:expense_notes/widget/platform_widget/platform_theme.dart';
import 'package:flutter/material.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  void _updateTheme({
    required PlatformTheme theme,
    required ThemeMode themeMode,
  }) {
    setState(() {
      ThemeManager.instance.toggleTheme(themeMode);
    });
  }

  @override
  Widget build(BuildContext context) {
    PlatformTheme theme = PlatformTheme(context);
    ThemeMode themeMode = ThemeManager.instance.getThemeMode();

    return Scaffold(
      drawer: const AppDrawer(current: Section.settings),
      backgroundColor: theme.getBackgroundColor(),
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Center(
        child: DropdownButton<ThemeMode>(
          value: themeMode,
          icon: const Icon(Icons.arrow_downward),
          elevation: 16,
          style: TextStyle(
            color: theme.getPrimaryColor(),
          ),
          items: <ThemeMode>[
            ThemeMode.light,
            ThemeMode.dark,
            ThemeMode.system,
          ].map<DropdownMenuItem<ThemeMode>>((value) {
            return DropdownMenuItem<ThemeMode>(
              value: value,
              child: Text(
                value.name,
                style: theme.getDefaultTextStyle(),
              ),
            );
          }).toList(),
          onChanged: (ThemeMode? newValue) {
            if (newValue != null) {
              _updateTheme(
                theme: theme,
                themeMode: newValue,
              );
            }
          },
        ),
      ),
    );
  }
}
