import 'package:expense_notes/extension/date_extension.dart';
import 'package:expense_notes/model/expense.dart';
import 'package:expense_notes/routes.dart';
import 'package:expense_notes/style/my_colors.dart';
import 'package:expense_notes/view/expense/expense_detail_screen.dart';
import 'package:expense_notes/widget/platform_widget/platform_theme.dart';
import 'package:flutter/material.dart';

typedef OnItemCallBack = Function(int index);

class ExpenseItem extends StatelessWidget {
  const ExpenseItem({
    Key? key,
    required this.index,
    required this.expense,
    required this.onDelete,
    required this.onEdit,
  }) : super(key: key);

  final int index;
  final Expense expense;
  final OnItemCallBack onDelete;
  final OnItemCallBack onEdit;

  @override
  Widget build(BuildContext context) {
    PlatformTheme theme = PlatformTheme(context);
    Color expenseColor = getColorFromHex(expense.color) ?? MyColors.primary;

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          Routes.detail,
          arguments: DetailScreenArguments(expense),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: theme.getBackgroundColor(),
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(1, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 80,
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                border: Border.all(
                  color: expenseColor,
                  width: 3,
                ),
              ),
              child: Center(
                child: Text(
                  '\$${expense.price}',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: expenseColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    expense.name,
                    overflow: TextOverflow.ellipsis,
                    style: theme.getDefaultTextStyle()?.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    expense.addTime.format(),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            _buildIconButton(
              onPressed: () => onEdit(index),
              icon: const Icon(
                Icons.edit,
                color: Colors.blue,
              ),
            ),
            _buildIconButton(
              onPressed: () => onDelete(index),
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton({
    required VoidCallback onPressed,
    required Icon icon,
  }) {
    return SizedBox(
      width: 40,
      child: IconButton(
        onPressed: onPressed,
        icon: icon,
      ),
    );
  }

  Color? getColorFromHex(String hexColor) {
    hexColor = hexColor.replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }

    if (hexColor.length == 8) {
      return Color(int.parse("0x$hexColor"));
    }

    return null;
  }
}
