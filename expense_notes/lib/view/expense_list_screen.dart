import 'package:expense_notes/extension/platform_extension.dart';
import 'package:expense_notes/model/expense.dart';
import 'package:expense_notes/model/expense_model.dart';
import 'package:expense_notes/view/expense_add_screen.dart';
import 'package:expense_notes/widget/expense_item_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

typedef EditCallBack = void Function(
  Mode mode,
  int index,
  Expense expense,
);
typedef DeleteCallBack = void Function(
  int index,
  Expense expense,
);

class ExpenseList extends StatelessWidget {
  final EditCallBack onEdit;
  final DeleteCallBack onDelete;

  const ExpenseList({
    Key? key,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle? textStyle = isAndroid()
        ? Theme.of(context).textTheme.titleLarge
        : CupertinoTheme.of(context).textTheme.textStyle;

    return Consumer<ExpenseModel>(builder: (context, model, child) {
      List<Expense> expenses = model.expenses;

      if (expenses.isEmpty) {
        return Center(
          child: Text(
            'No transactions added yet!',
            style: textStyle,
          ),
        );
      }

      return ListView.separated(
        itemCount: expenses.length,
        itemBuilder: (context, index) {
          final item = expenses[index];
          return ExpenseItem(
            key: UniqueKey(),
            index: index,
            expense: item,
            onDelete: (index) => onDelete(index, item),
            onEdit: (index) => onEdit(Mode.edit, index, item),
          );
        },
        separatorBuilder: (context, index) {
          return const SizedBox(
            height: 15,
          );
        },
      );
    });
  }
}
