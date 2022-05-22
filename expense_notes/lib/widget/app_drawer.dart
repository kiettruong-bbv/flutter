import 'package:expense_notes/routes.dart';
import 'package:expense_notes/widget/platform_widget/platform_theme.dart';
import 'package:flutter/material.dart';

enum Section { home, settings }

class AppDrawer extends StatelessWidget {
  final Section current;

  const AppDrawer({
    Key? key,
    required this.current,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PlatformTheme theme = PlatformTheme(context);

    return Drawer(
      backgroundColor: theme.getBackgroundColor(),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: theme.getPrimaryColor(),
            ),
            child: Center(
              child: Text(
                'Expense Notes',
                style: theme.getDrawerTitle(),
              ),
            ),
          ),
          _buildDrawerItem(
            context: context,
            title: 'Home',
            onTap: () => _navigateToSection(context, Section.home),
          ),
          _buildDrawerItem(
            context: context,
            title: 'Settings',
            onTap: () => _navigateToSection(context, Section.settings),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required BuildContext context,
    required String title,
    required VoidCallback onTap,
  }) {
    TextStyle? defaultTextStyle = PlatformTheme(context).getDefaultTextStyle();

    return ListTile(
      title: Center(
        child: Text(
          title,
          style: defaultTextStyle?.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      onTap: onTap,
    );
  }

  void _navigateToSection(BuildContext context, Section section) {
    if (current == section) {
      return;
    }
    switch (section) {
      case Section.home:
        Navigator.pushReplacementNamed(context, Routes.TRANSACTION_LIST_SCREEN);
        break;
      case Section.settings:
        Navigator.pushReplacementNamed(context, Routes.SETTING_SCREEN);
        break;
    }
  }
}
