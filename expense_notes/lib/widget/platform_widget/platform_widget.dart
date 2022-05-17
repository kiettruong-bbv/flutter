import 'package:expense_notes/extension/platform_extension.dart';
import 'package:flutter/material.dart';

abstract class PlatformWidget<I extends Widget, A extends Widget>
    extends StatelessWidget {
  const PlatformWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isIOS()) {
      return createIosWidget(context);
    } else if (isAndroid()) {
      return createAndroidWidget(context);
    }
    return Container();
  }

  I createIosWidget(BuildContext context);

  A createAndroidWidget(BuildContext context);
}
