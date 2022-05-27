import 'dart:math';
import 'package:expense_notes/extension/date_extension.dart';
import 'package:expense_notes/model/transaction.dart';
import 'package:expense_notes/routes.dart';
import 'package:expense_notes/view/detail_screen.dart';
import 'package:expense_notes/widget/platform_widget/platform_theme.dart';
import 'package:flutter/material.dart';

typedef OnItemCallBack = Function(int index);

class TransactionItem extends StatelessWidget {
  const TransactionItem({
    Key? key,
    required this.index,
    required this.transaction,
    required this.onDelete,
    required this.onEdit,
  }) : super(key: key);

  final int index;
  final Transaction transaction;
  final OnItemCallBack onDelete;
  final OnItemCallBack onEdit;

  @override
  Widget build(BuildContext context) {
    PlatformTheme theme = PlatformTheme(context);

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          Routes.detail,
          arguments: DetailScreenArguments(transaction),
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
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                border: Border.all(
                  color: transaction.color,
                  width: 3,
                ),
              ),
              child: Center(
                child: Text(
                  '\$${transaction.price}',
                  style: TextStyle(
                    color: transaction.color,
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
                    transaction.name,
                    style: theme.getDefaultTextStyle()?.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    transaction.addTime.format(),
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

  Color generateRandomColor() {
    final Random random = Random();
    return Color.fromRGBO(
      random.nextInt(255),
      random.nextInt(255),
      random.nextInt(255),
      1,
    );
  }
}
