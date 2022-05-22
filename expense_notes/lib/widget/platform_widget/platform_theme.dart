import 'package:expense_notes/style/custom_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:expense_notes/extension/platform_extension.dart';

abstract class PlatformThemeInterface {
  late BuildContext context;

  Color getPrimaryColor();
  Color getSecondaryColor();
  Color getBackgroundColor();
  Color getBackgroundAccentColor();
  TextStyle? getDefaultTextStyle();
  TextStyle? getDrawerTitle();
  TextStyle? getButtonTextStyle();
}

class PlatformThemeAndroid implements PlatformThemeInterface {
  PlatformThemeAndroid(this.context);

  @override
  BuildContext context;

  @override
  Color getPrimaryColor() {
    return Theme.of(context).primaryColor;
  }

  @override
  Color getSecondaryColor() {
    return Theme.of(context).colorScheme.secondary;
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
    return Theme.of(context).textTheme.titleMedium?.copyWith(
          color: CustomColors.white,
          fontSize: 25,
        );
  }

  @override
  TextStyle? getButtonTextStyle() {
    return Theme.of(context).textTheme.button;
  }
}

class PlatformThemeIOS implements PlatformThemeInterface {
  PlatformThemeIOS(this.context);

  @override
  BuildContext context;

  @override
  Color getPrimaryColor() {
    return CupertinoTheme.of(context).primaryColor;
  }

  @override
  Color getSecondaryColor() {
    return CupertinoTheme.of(context).primaryContrastingColor;
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

  @override
  TextStyle? getButtonTextStyle() {
    return CupertinoTheme.of(context).textTheme.actionTextStyle;
  }
}

class PlatformTheme implements PlatformThemeInterface {
  PlatformTheme(this.context);

  @override
  BuildContext context;

  @override
  Color getPrimaryColor() {
    return isAndroid()
        ? PlatformThemeAndroid(context).getPrimaryColor()
        : PlatformThemeIOS(context).getPrimaryColor();
  }

  @override
  Color getSecondaryColor() {
    return isAndroid()
        ? PlatformThemeAndroid(context).getSecondaryColor()
        : PlatformThemeIOS(context).getSecondaryColor();
  }

  @override
  Color getBackgroundColor() {
    return isAndroid()
        ? PlatformThemeAndroid(context).getBackgroundColor()
        : PlatformThemeIOS(context).getBackgroundColor();
  }

  @override
  Color getBackgroundAccentColor() {
    return isAndroid()
        ? PlatformThemeAndroid(context).getBackgroundAccentColor()
        : PlatformThemeIOS(context).getBackgroundAccentColor();
  }

  @override
  TextStyle? getDefaultTextStyle() {
    return isAndroid()
        ? PlatformThemeAndroid(context).getDefaultTextStyle()
        : PlatformThemeIOS(context).getDefaultTextStyle();
  }

  @override
  TextStyle? getDrawerTitle() {
    return isAndroid()
        ? PlatformThemeAndroid(context).getDrawerTitle()
        : PlatformThemeIOS(context).getDrawerTitle();
  }

  @override
  TextStyle? getButtonTextStyle() {
    return isAndroid()
        ? PlatformThemeAndroid(context).getButtonTextStyle()
        : PlatformThemeIOS(context).getButtonTextStyle();
  }
}
