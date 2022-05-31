import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_notes/constants/firebase_const.dart';
import 'package:expense_notes/constants/storage_key.dart';
import 'package:expense_notes/model/expense.dart';
import 'package:localstorage/localstorage.dart';
import 'package:http/http.dart' as http;

abstract class IExpenseRepository {
  Future<Expense> get(String documentId);
  Future<List<Expense>> getAll();
  Future create(Expense expense);
  Future delete(String documentId);
  Future update(String documentId, Expense expense);
}

class RefExpenseRepository implements IExpenseRepository {
  final CollectionReference _ref;

  RefExpenseRepository(this._ref);

  @override
  Future<Expense> get(String documentId) async {
    final documentSnapshot = await _ref.doc(documentId).get();
    final Map<String, dynamic> dataMap =
        documentSnapshot.data()! as Map<String, dynamic>;
    return Expense.fromMap(dataMap);
  }

  @override
  Future<List<Expense>> getAll() async {
    return [];
  }

  @override
  Future create(Expense expense) async {
    await _ref.add(expense.toMap());
  }

  @override
  Future delete(String documentId) async {
    await _ref.doc(documentId).delete();
  }

  @override
  Future update(String documentId, Expense expense) async {
    await _ref.doc(documentId).update(expense.toMap());
  }
}

class HttpExpenseRepository implements IExpenseRepository {
  final String path = '${FirebaseConst.firestoreBaseUrl}expenses';
  final String _token;

  HttpExpenseRepository()
      : _token = LocalStorage(StorageKey.app).getItem(StorageKey.token);

  @override
  Future<Expense> get(String documentId) async {
    final response = await http.get(
      Uri.parse(path + '/$documentId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $_token',
      },
    );
    final Map<String, dynamic> data = jsonDecode(response.body);
    return Expense.fromMap(data);
  }

  @override
  Future<List<Expense>> getAll() async {
    final response = await http.get(
      Uri.parse(path),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $_token',
      },
    );
    final list = json.decode(response.body)['documents'];
    List<Expense> expenses =
        List<Expense>.from(list.map((data) => Expense.fromFirestoreMap(data)))
            .toList();
    return expenses;
  }

  @override
  Future create(Expense expense) async {
    await http.post(
      Uri.parse(path + '?documentId=${expense.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $_token',
      },
      body: jsonEncode(expense.toFirestoreMap()),
    );
  }

  @override
  Future delete(String documentId) async {
    await http.delete(
      Uri.parse(path + '/$documentId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $_token',
      },
    );
  }

  @override
  Future update(String documentId, Expense expense) async {
    await http.patch(
      Uri.parse(path + '/$documentId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $_token',
      },
      body: jsonEncode(expense.toFirestoreMap()),
    );
  }
}
