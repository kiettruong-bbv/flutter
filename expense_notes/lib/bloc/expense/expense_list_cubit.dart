import 'package:expense_notes/bloc/expense/expense_list_state.dart';
import 'package:expense_notes/model/expense.dart';
import 'package:expense_notes/repository/expense_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExpenseListCubit extends Cubit<ExpenseListState> {
  final IExpenseRepository _expenseRepository;
  final List<Expense> _expenses = [];

  ExpenseListCubit(this._expenseRepository) : super(const ExpenseListState());

  Future getAll() async {
    clearLocalData();
    emit(
      state.copyWith(
        status: () => ExpenseListStatus.listLoading,
      ),
    );
    try {
      final List<Expense> fetchedExpenses = await _expenseRepository.getAll();
      _expenses.addAll(fetchedExpenses);

      emit(
        state.copyWith(
          status: () => ExpenseListStatus.loaded,
          expenses: () => _expenses,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: () => ExpenseListStatus.error,
          error: () => e.toString(),
        ),
      );
    }
  }

  Future addItem(Expense expense) async {
    emit(
      state.copyWith(
        status: () => ExpenseListStatus.listLoading,
      ),
    );
    try {
      await _expenseRepository.create(expense);
      _expenses.add(expense);

      emit(
        state.copyWith(
          status: () => ExpenseListStatus.added,
          expenses: () => _expenses,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: () => ExpenseListStatus.error,
          error: () => e.toString(),
        ),
      );
    }
  }

  Future deleteItem(int index, Expense expense) async {
    emit(
      state.copyWith(
        status: () => ExpenseListStatus.itemLoading,
        itemIndex: () => index,
      ),
    );
    try {
      await _expenseRepository.delete(expense.id);
      final Expense deletedItem = _expenses.removeAt(index);

      emit(
        state.copyWith(
          status: () => ExpenseListStatus.deleted,
          expenses: () => _expenses,
          lastDeletedExpense: () => deletedItem,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: () => ExpenseListStatus.error,
          error: () => e.toString(),
        ),
      );
    }
  }

  Future updateItem(int index, Expense expense) async {
    emit(
      state.copyWith(
        status: () => ExpenseListStatus.itemLoading,
        itemIndex: () => index,
      ),
    );
    try {
      await _expenseRepository.update(
        documentId: expense.id,
        expense: expense,
      );

      _expenses[index] = Expense.full(
          id: expense.id,
          color: _expenses[index].color,
          name: expense.name,
          price: expense.price,
          addTime: expense.addTime);

      emit(
        state.copyWith(
          status: () => ExpenseListStatus.updated,
          expenses: () => _expenses,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: () => ExpenseListStatus.error,
          error: () => e.toString(),
        ),
      );
    }
  }

  void clearLocalData() {
    _expenses.clear();
    emit(
      state.copyWith(
        status: () => ExpenseListStatus.reset,
        expenses: () => _expenses,
      ),
    );
  }

  List<Expense> getExpenses() {
    return _expenses;
  }
}
