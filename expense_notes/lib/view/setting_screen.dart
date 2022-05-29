import 'package:expense_notes/extension/platform_extension.dart';
import 'package:expense_notes/style/my_colors.dart';
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
      body: _buildSection(
        child: _buildThemeSection(),
      ),
    );
  }

  Widget _buildSection({required Widget child}) {
    PlatformTheme theme = PlatformTheme(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          color: theme.getBackgroundColor(),
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: child,
      ),
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
    PlatformTheme theme = PlatformTheme(context);

    return Theme(
      data: Theme.of(context).copyWith(
        unselectedWidgetColor: MyColors.grey,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Radio<ThemeMode>(
            activeColor: theme.getPrimaryColor(),
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
            style: theme.getDefaultTextStyle(),
          ),
        ],
      ),
    );
  }
}
