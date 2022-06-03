import 'package:expense_notes/style/my_colors.dart';
import 'package:expense_notes/widget/platform_widget/platform_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlatformButton extends PlatformWidget<CupertinoButton, ElevatedButton> {
  final bool isLoading;
  final Color? backgroundColor;
  final BorderRadius borderRadius;
  final VoidCallback? onPressed;
  final Widget child;

  const PlatformButton({
    Key? key,
    this.isLoading = false,
    this.backgroundColor,
    this.borderRadius = BorderRadius.zero,
    this.onPressed,
    required this.child,
  }) : super(key: key);

  @override
  ElevatedButton createAndroidWidget(BuildContext context) {
    return ElevatedButton(
      style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
            backgroundColor: MaterialStateProperty.all<Color?>(backgroundColor),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: borderRadius,
              ),
            ),
          ),
      onPressed: onPressed,
      child: isLoading ? _loadingIndicator() : child,
    );
  }

  @override
  CupertinoButton createIosWidget(BuildContext context) {
    return CupertinoButton(
      color: backgroundColor,
      disabledColor: MyColors.grey,
      onPressed: onPressed,
      child: isLoading ? _loadingIndicator() : child,
    );
  }

  Widget _loadingIndicator() {
    return const SizedBox(
      width: 20,
      height: 20,
      child: CircularProgressIndicator(
        color: Colors.white,
      ),
    );
  }
}
