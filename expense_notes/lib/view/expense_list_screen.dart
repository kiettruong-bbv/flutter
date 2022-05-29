import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_notes/extension/platform_extension.dart';
import 'package:expense_notes/model/expense.dart';
import 'package:expense_notes/model/expense_model.dart';
import 'package:expense_notes/view/expense_add_screen.dart';
import 'package:expense_notes/view/expense_item_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

typedef EditCallBack = void Function(
  Mode mode,
  String documentId,
  Expense expense,
);
typedef DeleteCallBack = void Function(String documentId);

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

    ExpenseModel expenseModel = context.read<ExpenseModel>();

    return StreamBuilder<QuerySnapshot>(
      stream: expenseModel.expensesRef.snapshots(),
      builder: (
        BuildContext context,
        AsyncSnapshot<QuerySnapshot> snapshot,
      ) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (!snapshot.hasData) {
          return Center(
            child: Text(
              'No expenses added yet!',
              style: textStyle,
            ),
          );
        }

        return ListView.separated(
          itemCount: snapshot.data?.docs.length ?? 0,
          itemBuilder: (context, index) {
            final docData = snapshot.data!.docs[index];
            final String documentId = docData.reference.id;
            final Map<String, dynamic> dataMap =
                docData.data()! as Map<String, dynamic>;
            final Expense item = Expense.fromMap(dataMap);

            return ExpenseItem(
              key: UniqueKey(),
              documentId: documentId,
              expense: item,
              onDelete: (documentId) => onDelete(documentId),
              onEdit: (documentId) => onEdit(Mode.edit, documentId, item),
            );
          },
          separatorBuilder: (context, index) {
            return const SizedBox(
              height: 15,
            );
          },
        );
      },
    );
  }
}
