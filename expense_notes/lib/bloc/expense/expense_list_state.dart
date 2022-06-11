import 'package:equatable/equatable.dart';
import 'package:expense_notes/model/expense.dart';

enum ExpenseListStatus {
  initial,
  listLoading,
  itemLoading,
  loaded,
  added,
  deleted,
  updated,
  reset,
  error,
}

class ExpenseListState extends Equatable {
  final ExpenseListStatus status;
  final List<Expense> expenses;
  final Expense? lastDeletedExpense;
  final int? itemIndex;
  final String? error;

  const ExpenseListState({
    this.status = ExpenseListStatus.initial,
    this.expenses = const [],
    this.lastDeletedExpense,
    this.itemIndex,
    this.error,
  });

  ExpenseListState copyWith({
    ExpenseListStatus Function()? status,
    List<Expense> Function()? expenses,
    Expense Function()? lastDeletedExpense,
    int? Function()? itemIndex,
    String Function()? error,
  }) {
    return ExpenseListState(
      status: status != null ? status() : this.status,
      expenses: expenses != null ? expenses() : this.expenses,
      lastDeletedExpense: lastDeletedExpense != null
          ? lastDeletedExpense()
          : this.lastDeletedExpense,
      itemIndex: itemIndex != null ? itemIndex() : -1,
      error: error != null ? error() : this.error,
    );
  }

  @override
  List<Object?> get props => [
        status,
        expenses,
        lastDeletedExpense,
        itemIndex,
        error,
      ];
}
