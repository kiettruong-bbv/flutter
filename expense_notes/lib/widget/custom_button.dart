import 'package:expense_notes/widget/platform_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomButton extends PlatformWidget<CupertinoButton, ElevatedButton> {
  final VoidCallback? onPressed;
  final Widget child;

  const CustomButton({
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
      color: Theme.of(context).primaryColor,
      onPressed: onPressed,
      child: child,
    );
  }
}
