import 'package:expense_notes/model/transaction.dart';
import 'package:flutter/material.dart';

class DetailScreenArguments {
  final Transaction transaction;

  DetailScreenArguments(this.transaction);
}

class DetailScreen extends StatelessWidget {
  final DetailScreenArguments args;

  const DetailScreen({
    Key? key,
    required this.args,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail'),
        backgroundColor: theme.primaryColor,
      ),
      body: Center(
        child: Text(args.transaction.name),
      ),
    );
  }
}
