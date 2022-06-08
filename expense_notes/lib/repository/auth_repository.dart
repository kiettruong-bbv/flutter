import 'package:dio/dio.dart';
import 'package:expense_notes/api/auth_api.dart';
import 'package:expense_notes/model/auth_response.dart';
import 'package:expense_notes/services/dio_exceptions.dart';

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
  final AuthApi authApi;

  HttpAuthRepository({required this.authApi});

  @override
  Future<AuthResponse?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await authApi.signIn(
        email: email,
        password: password,
      );
      if (response.statusCode == 200) {
        return AuthResponse.fromJson(response.data);
      }
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
    return null;
  }

  @override
  Future<AuthResponse?> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final response = await authApi.signUp(
        email: email,
        password: password,
      );
      if (response.statusCode == 200) {
        return AuthResponse.fromJson(response.data);
      }
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
    return null;
  }
}
