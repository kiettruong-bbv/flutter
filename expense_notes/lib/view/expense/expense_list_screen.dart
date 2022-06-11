import 'package:expense_notes/bloc/expense/expense_list_cubit.dart';
import 'package:expense_notes/bloc/expense/expense_list_state.dart';
import 'package:expense_notes/extension/platform_extension.dart';
import 'package:expense_notes/model/expense.dart';
import 'package:expense_notes/view/expense/expense_add_screen.dart';
import 'package:expense_notes/view/expense/expense_item.dart';
import 'package:expense_notes/widget/my_loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

typedef EditCallBack = void Function(
  Mode mode,
  int index,
  Expense expense,
);
typedef DeleteCallBack = void Function(
  int index,
  Expense expense,
);

class ExpenseList extends StatefulWidget {
  final EditCallBack onEdit;
  final DeleteCallBack onDelete;

  const ExpenseList({
    Key? key,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  State<ExpenseList> createState() => _ExpenseListState();
}

class _ExpenseListState extends State<ExpenseList> {
  @override
  Widget build(BuildContext context) {
    TextStyle? textStyle = isAndroid()
        ? Theme.of(context).textTheme.titleLarge
        : CupertinoTheme.of(context).textTheme.textStyle;

    return BlocConsumer<ExpenseListCubit, ExpenseListState>(
      builder: (context, state) {
        List<Expense> expenses = state.expenses;

        final bool isListLoading =
            state.status == ExpenseListStatus.listLoading;

        if (isListLoading) {
          return const MyLoader();
        }
        if (expenses.isEmpty) {
          return Center(
            child: Text(
              'No transactions!',
              style: textStyle,
            ),
          );
        }
        return ListView.separated(
          itemCount: expenses.length,
          itemBuilder: (context, index) {
            final item = expenses[index];
            final bool isItemLoading =
                (state.status == ExpenseListStatus.itemLoading) &&
                    (state.itemIndex == index);

            return ExpenseItem(
              key: UniqueKey(),
              isLoading: isItemLoading,
              index: index,
              expense: item,
              onDelete: (index) => widget.onDelete(index, item),
              onEdit: (index) => widget.onEdit(Mode.edit, index, item),
            );
          },
          separatorBuilder: (context, index) {
            return const SizedBox(
              height: 15,
            );
          },
        );
      },
      listener: (context, state) async {
        switch (state.status) {
          case ExpenseListStatus.loaded:
            await Fluttertoast.showToast(msg: 'Item loaded');
            break;
          case ExpenseListStatus.added:
            await Fluttertoast.showToast(msg: 'Item added');
            break;
          case ExpenseListStatus.deleted:
            await Fluttertoast.showToast(msg: 'Item deleted');
            break;
          case ExpenseListStatus.updated:
            await Fluttertoast.showToast(msg: 'Item updated');
            break;
          case ExpenseListStatus.error:
            if (state.error != null) {
              await Fluttertoast.showToast(msg: state.error ?? 'Error');
            }
            break;
          default:
        }
      },
    );
  }
}
