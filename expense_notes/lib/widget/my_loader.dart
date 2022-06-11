import 'package:expense_notes/style/my_colors.dart';
import 'package:flutter/material.dart';

class MyLoader extends StatelessWidget {
  final double scale;

  const MyLoader({
    Key? key,
    this.scale = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Transform.scale(
        scale: scale,
        child: const CircularProgressIndicator(
          color: MyColors.lightPurple,
        ),
      ),
    );
  }
}
