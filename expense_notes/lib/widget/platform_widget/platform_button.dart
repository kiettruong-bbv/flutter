import 'package:expense_notes/style/my_colors.dart';
import 'package:expense_notes/widget/platform_widget/platform_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlatformButton extends PlatformWidget<CupertinoButton, ElevatedButton> {
  final VoidCallback? onPressed;
  final Widget child;

  const PlatformButton({
    Key? key,
    this.onPressed,
    required this.child,
  }) : super(key: key);

  @override
  ElevatedButton createAndroidWidget(BuildContext context) {
    return ElevatedButton(
      style: Theme.of(context).elevatedButtonTheme.style,
      onPressed: onPressed,
      child: child,
    );
  }

  @override
  CupertinoButton createIosWidget(BuildContext context) {
    return CupertinoButton(
      color: CupertinoTheme.of(context).primaryColor,
      disabledColor: MyColors.grey,
      onPressed: onPressed,
      child: child,
    );
  }
}
