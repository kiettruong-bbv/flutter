import 'package:expense_notes/model/expense.dart';

class WeekDayExpense {
  final WeekDay weekDay;
  final List<Expense> expenses;

  WeekDayExpense({
    required this.weekDay,
    required this.expenses,
  });

  WeekDayExpense.fromMap(Map<String, dynamic> data)
      : weekDay = WeekDay.values.firstWhere((e) => e.value == data['weekDay']),
        expenses = List<Expense>.from(
            data['expenses'].map((model) => Expense.fromMap(model)));

  Map<String, dynamic> toMap() {
    final expensesMap = expenses.map((e) => e.toMap()).toList();
    return {
      'weekDay': weekDay.value,
      'expenses': expensesMap,
    };
  }
}
