// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:expense_notes/model/transaction.dart';
import 'package:expense_notes/model/transaction_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('adding item increases total cost', () {
    final model = TransactionModel();
    model.addListener(() {
      expect(model.transactions.length, 1);
    });
    model.add(
      Transaction(name: 'Shoes', price: 60, addTime: DateTime.now()),
    );
  });
}
