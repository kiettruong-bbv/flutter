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

  void edit(int index, Transaction transaction) {
    if (_transactions.isNotEmpty) {
      final String id = _transactions[index].id;
      final Color color = _transactions[index].color;
      _transactions[index] = Transaction.full(
          id: id,
          color: color,
          name: transaction.name,
          price: transaction.price,
          addTime: transaction.addTime);
    }
    notifyListeners();
  }

  Transaction remove(int index) {
    Transaction transaction = _transactions.removeAt(index);
    notifyListeners();
    return transaction;
  }
}
