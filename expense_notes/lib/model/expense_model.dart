import 'dart:collection';
import 'package:expense_notes/model/expense.dart';
import 'package:expense_notes/service/expense_repository.dart';
import 'package:flutter/material.dart';

class ExpenseModel extends ChangeNotifier {
  final List<Expense> _expenses = [];
  final IExpenseRepository _expenseRepository;

  ExpenseModel(this._expenseRepository);

  UnmodifiableListView<Expense> get expenses => UnmodifiableListView(_expenses);

  Future<List<Expense>> getAll() async {
    final List<Expense> expenses = await _expenseRepository.getAll();
    _expenses.clear();
    _expenses.addAll(expenses);
    return expenses;
  }

  Future addItem(Expense expense) async {
    await _expenseRepository.create(expense);

    _expenses.add(expense);
    notifyListeners();
  }

  Future deleteItem(int index, Expense expense) async {
    await _expenseRepository.delete(expense.id);

    final Expense deletedItem = _expenses.removeAt(index);
    notifyListeners();
    return deletedItem;
  }

  Future updateItem(int index, Expense expense) async {
    await _expenseRepository.update(
      documentId: expense.id,
      expense: expense,
    );

    final String color = _expenses[index].color;
    _expenses[index] = Expense.full(
        id: expense.id,
        color: color,
        name: expense.name,
        price: expense.price,
        addTime: expense.addTime);

    notifyListeners();
  }

  void clearData() {
    _expenses.clear();
  }
}
