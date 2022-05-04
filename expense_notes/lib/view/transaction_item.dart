import 'dart:math';

import 'package:expense_notes/extension/date_extension.dart';
import 'package:expense_notes/model/transaction.dart';
import 'package:flutter/material.dart';

typedef OnDeleteItemCallBack = Function(int index);

class TransactionItem extends StatelessWidget {
  TransactionItem({
    Key? key,
    required this.index,
    required this.product,
    required this.onDelete,
  }) : super(key: key);

  final int index;
  final Transaction product;
  final OnDeleteItemCallBack onDelete;

  late final Color randomColor = generateRandomColor();

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: theme.backgroundColor,
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
                color: randomColor,
                width: 3,
              ),
            ),
            child: Center(
              child: Text(
                '\$${product.price}',
                style: TextStyle(
                  color: randomColor,
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
                  product.name,
                  style: theme.textTheme.headline6,
                ),
                Text(
                  product.addTime.format(),
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 40,
            child: IconButton(
              onPressed: () => onDelete(index),
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
            ),
          ),
        ],
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
