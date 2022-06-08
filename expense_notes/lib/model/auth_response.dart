import 'dart:convert';

import 'package:expense_notes/constants/storage_key.dart';
import 'package:expense_notes/utils/storage_utils.dart';

class AuthResponse {
  final String localId;
  final String email;
  final String idToken;
  final String refreshToken;
  final String expiresIn;

  AuthResponse(
    this.localId,
    this.email,
    this.idToken,
    this.refreshToken,
    this.expiresIn,
  );

  AuthResponse.fromJson(Map<String, dynamic> data)
      : localId = data['localId'] ?? '',
        email = data['email'] ?? '',
        idToken = data['idToken'] ?? '',
        refreshToken = data['refreshToken'] ?? '',
        expiresIn = data['expiresIn'] ?? '';

  Map<String, dynamic> toJson() {
    return {
      'localId': localId,
      'email': email,
      'idToken': idToken,
      'refreshToken': refreshToken,
      'expiresIn': expiresIn,
    };
  }

  static String? getIdToken() {
    final String? authString = StorageUtils.getItem(StorageKey.auth);
    if (authString != null) {
      final Map<String, dynamic> authData = jsonDecode(authString);
      return AuthResponse.fromJson(authData).idToken;
    }
    return null;
  }
}
