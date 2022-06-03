import 'dart:convert';
import 'package:expense_notes/constants/firebase_const.dart';
import 'package:expense_notes/model/response/auth_response.dart';
import 'package:http/http.dart' as http;

abstract class IAuthRepository {
  Future<AuthResponse?> signIn({
    required String email,
    required String password,
  });
  Future<AuthResponse?> signUp({
    required String email,
    required String password,
  });
}

class HttpAuthRepository implements IAuthRepository {
  @override
  Future<AuthResponse?> signIn(
      {required String email, required String password}) async {
    final response = await http.post(
      Uri.parse(FirebaseConst.firebaseAuthEndpoint +
          ':signInWithPassword?key=${FirebaseConst.webApiKey}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return AuthResponse.fromMap(data);
    }
    return null;
  }

  @override
  Future<AuthResponse?> signUp(
      {required String email, required String password}) async {
    final response = await http.post(
      Uri.parse(FirebaseConst.firebaseAuthEndpoint +
          ':signUp?key=${FirebaseConst.webApiKey}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return AuthResponse.fromMap(data);
    }
    return null;
  }
}
