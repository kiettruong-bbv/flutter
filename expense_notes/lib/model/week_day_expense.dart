import 'package:expense_notes/model/expense.dart';

enum WeekDay { mon, tue, wed, thu, fri, sat, sun }

extension CatExtension on WeekDay {
  int get value {
    switch (this) {
      case WeekDay.mon:
        return 1;
      case WeekDay.tue:
        return 2;
      case WeekDay.wed:
        return 3;
      case WeekDay.thu:
        return 4;
      case WeekDay.fri:
        return 5;
      case WeekDay.sat:
        return 6;
      case WeekDay.sun:
        return 7;
    }
  }
}

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
            data['expenses'].map((model) => Expense.fromJson(model)));

  Map<String, dynamic> toMap() {
    final expensesMap = expenses.map((e) => e.toJson()).toList();
    return {
      'weekDay': weekDay.value,
      'expenses': expensesMap,
    };
  }
}
