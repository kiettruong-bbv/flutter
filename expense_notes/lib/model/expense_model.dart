import 'package:expense_notes/model/expense.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ExpenseModel extends ChangeNotifier {
  CollectionReference expensesRef =
      FirebaseFirestore.instance.collection('expenses');

  Future addItem(Expense expense) async {
    await expensesRef.add(expense.toMap());
  }

  Future<Expense> deleteItem(String documentId) async {
    final documentSnapshot = await expensesRef.doc(documentId).get();
    final Map<String, dynamic> dataMap =
        documentSnapshot.data()! as Map<String, dynamic>;

    await expensesRef
        .doc(documentId)
        .delete()
        .catchError((error) => print("Failed to delete expense: $error"));

    return Expense.fromMap(dataMap);
  }

  Future updateItem(String documentId, Expense expense) async {
    await expensesRef
        .doc(documentId)
        .update(expense.toMap())
        .catchError((error) => print("Failed to update expense: $error"));
  }
}
