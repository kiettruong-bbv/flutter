import 'dart:collection';

import 'package:expense_notes/model/transaction.dart';
import 'package:flutter/material.dart';

class TransactionModel extends ChangeNotifier {
  final List<Transaction> _transactions = [];

  UnmodifiableListView<Transaction> get transactions =>
      UnmodifiableListView(_transactions);

  void add(Transaction transaction) {
    _transactions.add(transaction);
    notifyListeners();
  }

  Transaction remove(int index) {
    Transaction transaction = _transactions.removeAt(index);
    notifyListeners();
    return transaction;
  }
}
