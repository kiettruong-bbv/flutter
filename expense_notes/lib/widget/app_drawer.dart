import 'package:expense_notes/routes.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: theme.primaryColor,
            ),
            child: Center(
              child: Text(
                'Expense Notes',
                style: theme.textTheme.headline5
                    ?.apply(color: theme.primaryColorLight),
              ),
            ),
          ),
          _buildDrawerItem(
            context,
            title: 'Home',
            onTap: () =>
                {Navigator.pushNamed(context, Routes.TRANSACTION_LIST_SCREEN)},
          ),
          _buildDrawerItem(
            context,
            title: 'Settings',
            onTap: () => {Navigator.pushNamed(context, Routes.SETTING_SCREEN)},
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required String title,
    required VoidCallback onTap,
  }) {
    final ThemeData theme = Theme.of(context);

    return ListTile(
      title: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: onTap,
    );
  }
}
