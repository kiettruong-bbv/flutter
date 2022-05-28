import 'package:expense_notes/model/expense.dart';
import 'package:flutter/material.dart';

class DetailScreenArguments {
  final Expense expense;

  DetailScreenArguments(this.expense);
}

class DetailScreen extends StatelessWidget {
  const DetailScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final args =
        ModalRoute.of(context)!.settings.arguments as DetailScreenArguments;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail'),
        backgroundColor: theme.primaryColor,
      ),
      body: Center(
        child: Text(args.expense.name),
      ),
    );
  }
}
