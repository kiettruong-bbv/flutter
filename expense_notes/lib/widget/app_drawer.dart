import 'package:expense_notes/extension/platform_extension.dart';
import 'package:expense_notes/routes.dart';
import 'package:expense_notes/widget/platform_widget/platform_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum Section { home, settings }

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PlatformTheme theme = PlatformTheme.instance;
    Color primaryColor = theme.getPrimaryColor(context);
    Color backgroundColor = theme.getBackgroundAccentColor(context);
    TextStyle? defaultTextStyle = theme.getDefaultTextStyle(context);
    TextStyle? drawerTitle = theme.getDrawerTextStyle(context);

    return Drawer(
      backgroundColor: backgroundColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: primaryColor,
            ),
            child: Center(
              child: Text(
                'Expense Notes',
                style: drawerTitle,
              ),
            ),
          ),
          _buildDrawerItem(
            textStyle: defaultTextStyle,
            title: 'Home',
            onTap: () => _navigateToSection(context, Section.home),
          ),
          _buildDrawerItem(
            textStyle: defaultTextStyle,
            title: 'Settings',
            onTap: () => _navigateToSection(context, Section.settings),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    TextStyle? textStyle,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      title: Center(
        child: Text(
          title,
          style: textStyle,
        ),
      ),
      onTap: onTap,
    );
  }

  void _navigateToSection(BuildContext context, Section section) {
    // Close drawer
    Navigator.pop(context);

    switch (section) {
      case Section.home:
        Navigator.pushNamed(context, Routes.TRANSACTION_LIST_SCREEN);
        break;
      case Section.settings:
        Navigator.pushNamed(context, Routes.SETTING_SCREEN);
        break;
    }
  }
}
