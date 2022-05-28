import 'package:expense_notes/extension/platform_extension.dart';
import 'package:expense_notes/style/theme_manager.dart';
import 'package:expense_notes/widget/app_drawer.dart';
import 'package:expense_notes/widget/platform_widget/platform_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    PlatformTheme theme = PlatformTheme(context);

    return Scaffold(
      drawer: const AppDrawer(current: Section.settings),
      backgroundColor: theme.getBackgroundColor(),
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: theme.getPrimaryColor(),
      ),
      body: _buildThemeSection(),
    );
  }

  Widget _buildThemeSection() {
    return SizedBox(
      height: 200,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildThemeItem(
            context: context,
            mode: ThemeMode.light,
          ),
          _buildThemeItem(
            context: context,
            mode: ThemeMode.dark,
          ),
          _buildThemeItem(
            context: context,
            mode: ThemeMode.system,
          ),
        ],
      ),
    );
  }

  Widget _buildThemeItem({
    required BuildContext context,
    required ThemeMode mode,
  }) {
    ThemeManager themeManager = context.watch<ThemeManager>();
    ThemeData theme = Theme.of(context);

    Color primaryColor = isAndroid()
        ? Theme.of(context).primaryColor
        : CupertinoTheme.of(context).primaryColor;

    TextStyle? textStyle = isAndroid()
        ? Theme.of(context).textTheme.titleLarge
        : CupertinoTheme.of(context).textTheme.textStyle;

    return Theme(
      data: Theme.of(context).copyWith(
        unselectedWidgetColor: theme.colorScheme.onPrimary,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Radio<ThemeMode>(
            activeColor: primaryColor,
            value: mode,
            groupValue: themeManager.currentTheme,
            onChanged: (ThemeMode? newTheme) {
              if (newTheme != null) {
                themeManager.toggleTheme(newTheme);
              }
            },
          ),
          Text(
            mode.name,
            style: textStyle,
          ),
        ],
      ),
    );
  }
}
