import 'dart:convert';

import 'package:expense_notes/constants/storage_key.dart';
import 'package:expense_notes/model/auth_model.dart';
import 'package:expense_notes/model/response/auth_response.dart';
import 'package:expense_notes/routes.dart';
import 'package:expense_notes/utils/storage_utils.dart';
import 'package:expense_notes/widget/platform_widget/platform_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  late final AuthResponse _auth;

  @override
  void initState() {
    final String authData = StorageUtils.getItem(StorageKey.auth);
    _auth = AuthResponse.fromMap(jsonDecode(authData));
    super.initState();
  }

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
                  Text(
                    _auth.email,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
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
    context.read<AuthModel>().signOut(context);
  }
}
