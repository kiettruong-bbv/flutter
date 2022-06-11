import 'package:expense_notes/bloc/expense/expense_list_cubit.dart';
import 'package:expense_notes/bloc/root/root_cubit.dart';
import 'package:expense_notes/bloc/theme/theme_cubit.dart';
import 'package:expense_notes/routes.dart';
import 'package:expense_notes/widget/platform_widget/platform_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum Section { home, settings, logout }

class AppDrawer extends StatefulWidget {
  final Section current;

  const AppDrawer({
    Key? key,
    required this.current,
  }) : super(key: key);

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Expense Notes',
                    style: theme.getDrawerTitle(),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
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
          _buildDrawerItem(
            context: context,
            title: 'Log out',
            onTap: () => _navigateToSection(context, Section.logout),
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

  Future _navigateToSection(BuildContext context, Section section) async {
    if (widget.current == section) {
      return;
    }
    switch (section) {
      case Section.home:
        Navigator.pushReplacementNamed(context, Routes.home);
        break;
      case Section.settings:
        Navigator.pushReplacementNamed(context, Routes.setting);
        break;
      case Section.logout:
        await _signOutUser(context);
        break;
    }
  }

  Future _signOutUser(BuildContext context) async {
    await BlocProvider.of<RootCubit>(context).signOut();
    BlocProvider.of<ExpenseListCubit>(context).clearLocalData();
    BlocProvider.of<ThemeCubit>(context).toggleTheme(ThemeMode.light);
  }
}
