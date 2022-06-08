import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:expense_notes/constants/firebase_const.dart';
import 'package:expense_notes/services/dio_client.dart';

abstract class IAuthApi {
  Future<Response> signIn({
    required String email,
    required String password,
  });
  Future<Response> signUp({
    required String email,
    required String password,
  });
}

class AuthApi implements IAuthApi {
  final DioClient dioClient;

  AuthApi({required this.dioClient});

  @override
  Future<Response> signIn({
    required String email,
    required String password,
  }) async {
    try {
      const String uri = FirebaseConst.firebaseAuthEndpoint +
          ':signInWithPassword?key=${FirebaseConst.webApiKey}';
      final response = await dioClient.post(
        uri,
        data: jsonEncode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Response> signUp({
    required String email,
    required String password,
  }) async {
    try {
      const String uri = FirebaseConst.firebaseAuthEndpoint +
          ':signUp?key=${FirebaseConst.webApiKey}';
      final response = await dioClient.post(
        uri,
        data: jsonEncode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
