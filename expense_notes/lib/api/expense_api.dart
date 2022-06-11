import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:expense_notes/constants/app_const.dart';
import 'package:expense_notes/constants/firebase_const.dart';
import 'package:expense_notes/model/auth.dart';
import 'package:expense_notes/model/expense.dart';
import 'package:expense_notes/services/dio_client.dart';

abstract class IExpenseApi {
  Future<Response> get(String documentId);
  Future<Response> getAll();
  Future<Response> create(Expense expense);
  Future<Response> delete(String documentId);
  Future<Response> update({
    required String documentId,
    required Expense expense,
  });
}

class ExpenseApi implements IExpenseApi {
  final DioClient dioClient;

  ExpenseApi({required this.dioClient});

  @override
  Future<Response> get(String documentId) async {
    final String token = await AuthResponse.getIdToken() ?? '';
    try {
      final String uri = FirebaseConst.firestoreBaseUrl + '/$documentId';
      final response = await dioClient.get(
        uri,
        options: Options(
          headers: {
            Headers.contentTypeHeader: Headers.jsonContentType,
            HeadersConstant.authorization: dioClient.getTokenHeaderValue(token),
          },
        ),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Response> getAll() async {
    final String token = await AuthResponse.getIdToken() ?? '';
    try {
      final response = await dioClient.get(
        FirebaseConst.firestoreBaseUrl,
        options: Options(
          headers: {
            Headers.contentTypeHeader: Headers.jsonContentType,
            HeadersConstant.authorization: dioClient.getTokenHeaderValue(token),
          },
        ),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Response> create(Expense expense) async {
    final String token = await AuthResponse.getIdToken() ?? '';
    try {
      final String uri =
          FirebaseConst.firestoreBaseUrl + '?documentId=${expense.id}';
      final response = await dioClient.post(
        uri,
        options: Options(
          headers: {
            Headers.contentTypeHeader: Headers.jsonContentType,
            HeadersConstant.authorization: dioClient.getTokenHeaderValue(token),
          },
        ),
        data: jsonEncode(expense.toFirestoreJson()),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Response> delete(String documentId) async {
    final String token = await AuthResponse.getIdToken() ?? '';
    try {
      final String uri = FirebaseConst.firestoreBaseUrl + '/$documentId';
      final response = await dioClient.delete(
        uri,
        options: Options(
          headers: {
            Headers.contentTypeHeader: Headers.jsonContentType,
            HeadersConstant.authorization: dioClient.getTokenHeaderValue(token),
          },
        ),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Response> update({
    required String documentId,
    required Expense expense,
  }) async {
    final String token = await AuthResponse.getIdToken() ?? '';
    try {
      final String uri = FirebaseConst.firestoreBaseUrl + '/$documentId';
      final response = await dioClient.patch(
        uri,
        options: Options(
          headers: {
            Headers.contentTypeHeader: Headers.jsonContentType,
            HeadersConstant.authorization: dioClient.getTokenHeaderValue(token),
          },
        ),
        data: jsonEncode(expense.toFirestoreJson()),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
