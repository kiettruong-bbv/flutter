import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:expense_notes/extension/platform_extension.dart';

abstract class PlatformThemeInterface {
  Color getPrimaryColor();
  Color getBackgroundColor();
  Color getBackgroundAccentColor();
  TextStyle? getDefaultTextStyle();
  TextStyle? getDrawerTitle();
}

//

class PlatformThemeAndroid extends PlatformThemeInterface {
  BuildContext context;

  PlatformThemeAndroid(this.context);

  @override
  Color getPrimaryColor() {
    return Theme.of(context).primaryColor;
  }

  @override
  Color getBackgroundColor() {
    return Theme.of(context).scaffoldBackgroundColor;
  }

  @override
  Color getBackgroundAccentColor() {
    return Theme.of(context).backgroundColor;
  }

  @override
  TextStyle? getDefaultTextStyle() {
    return Theme.of(context).textTheme.bodyText2;
  }

  @override
  TextStyle? getDrawerTitle() {
    return Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 25);
  }
}

//

class PlatformThemeIOS extends PlatformThemeInterface {
  BuildContext context;

  PlatformThemeIOS(this.context);

  @override
  Color getPrimaryColor() {
    return CupertinoTheme.of(context).primaryColor;
  }

  @override
  Color getBackgroundColor() {
    return CupertinoTheme.of(context).scaffoldBackgroundColor;
  }

  @override
  Color getBackgroundAccentColor() {
    return CupertinoTheme.of(context).barBackgroundColor;
  }

  @override
  TextStyle? getDefaultTextStyle() {
    return CupertinoTheme.of(context).textTheme.textStyle;
  }

  @override
  TextStyle? getDrawerTitle() {
    return CupertinoTheme.of(context)
        .textTheme
        .navTitleTextStyle
        .copyWith(fontSize: 25);
  }
}

//

class PlatformTheme {
  PlatformTheme._internal();

  static final PlatformTheme instance = PlatformTheme._internal();

  Color getPrimaryColor(BuildContext context) {
    return isAndroid()
        ? PlatformThemeAndroid(context).getPrimaryColor()
        : PlatformThemeIOS(context).getPrimaryColor();
  }

  Color getBackgroundColor(BuildContext context) {
    return isAndroid()
        ? PlatformThemeAndroid(context).getBackgroundColor()
        : PlatformThemeIOS(context).getBackgroundColor();
  }

  Color getBackgroundAccentColor(BuildContext context) {
    return isAndroid()
        ? PlatformThemeAndroid(context).getBackgroundAccentColor()
        : PlatformThemeIOS(context).getBackgroundAccentColor();
  }

  TextStyle? getDefaultTextStyle(BuildContext context) {
    return isAndroid()
        ? PlatformThemeAndroid(context).getDefaultTextStyle()
        : PlatformThemeIOS(context).getDefaultTextStyle();
  }

  TextStyle? getDrawerTextStyle(BuildContext context) {
    return isAndroid()
        ? PlatformThemeAndroid(context).getDrawerTitle()
        : PlatformThemeIOS(context).getDrawerTitle();
  }
}
