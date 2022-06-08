import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:expense_notes/api/expense_api.dart';
import 'package:expense_notes/model/expense.dart';
import 'package:expense_notes/services/dio_exceptions.dart';

abstract class IExpenseRepository {
  Future<Expense?> get(String documentId);
  Future<List<Expense>> getAll();
  Future<bool> create(Expense expense);
  Future<bool> delete(String documentId);
  Future<bool> update({
    required String documentId,
    required Expense expense,
  });
}

class RefExpenseRepository implements IExpenseRepository {
  final CollectionReference _ref;

  RefExpenseRepository(this._ref);

  @override
  Future<Expense?> get(String documentId) async {
    final documentSnapshot = await _ref.doc(documentId).get();
    final Map<String, dynamic> dataMap =
        documentSnapshot.data()! as Map<String, dynamic>;
    return Expense.fromJson(dataMap);
  }

  @override
  Future<List<Expense>> getAll() async {
    return [];
  }

  @override
  Future<bool> create(Expense expense) async {
    await _ref.add(expense.toJson());
    return true;
  }

  @override
  Future<bool> delete(String documentId) async {
    await _ref.doc(documentId).delete();
    return true;
  }

  @override
  Future<bool> update({
    required String documentId,
    required Expense expense,
  }) async {
    await _ref.doc(documentId).update(expense.toJson());
    return true;
  }
}

class HttpExpenseRepository implements IExpenseRepository {
  final ExpenseApi expenseApi;

  HttpExpenseRepository({required this.expenseApi});

  @override
  Future<Expense?> get(String documentId) async {
    try {
      final response = await expenseApi.get(documentId);
      if (response.statusCode == 200) {
        return Expense.fromFirestoreJson(response.data);
      }
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
    return null;
  }

  @override
  Future<List<Expense>> getAll() async {
    try {
      final response = await expenseApi.getAll();
      if (response.statusCode == 200) {
        final List list = response.data['documents'];
        final List<Expense> expenses = List<Expense>.from(
          list.map((data) => Expense.fromFirestoreJson(data)),
        ).toList();
        return expenses;
      }
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
    return [];
  }

  @override
  Future<bool> create(Expense expense) async {
    try {
      final response = await expenseApi.create(expense);
      if (response.statusCode == 200) {
        return true;
      }
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
    return false;
  }

  @override
  Future<bool> delete(String documentId) async {
    try {
      final response = await expenseApi.delete(documentId);
      if (response.statusCode == 200) {
        return true;
      }
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
    return false;
  }

  @override
  Future<bool> update({
    required String documentId,
    required Expense expense,
  }) async {
    try {
      final response = await expenseApi.update(
        documentId: documentId,
        expense: expense,
      );
      if (response.statusCode == 200) {
        return true;
      }
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
    return false;
  }
}
