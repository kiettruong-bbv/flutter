import 'dart:convert';

import 'package:expense_notes/constants/storage_key.dart';
import 'package:expense_notes/model/expense_model.dart';
import 'package:expense_notes/model/response/auth_response.dart';
import 'package:expense_notes/service/auth_repository.dart';
import 'package:expense_notes/utils/storage_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthModel with ChangeNotifier {
  bool _isSignedIn = false;

  final IAuthRepository _authRepository;

  AuthModel(this._authRepository);

  bool get isSignedIn => _isSignedIn;

  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    final AuthResponse? auth = await _authRepository.signIn(
      email: email,
      password: password,
    );
    if (auth != null) {
      _isSignedIn = true;
      await StorageUtils.setItem(
        StorageKey.auth,
        jsonEncode(auth.toMap()),
      );
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> signUp({
    required String email,
    required String password,
  }) async {
    final AuthResponse? auth = await _authRepository.signUp(
      email: email,
      password: password,
    );
    return auth != null;
  }

  Future signOut(BuildContext context) async {
    await StorageUtils.deleteItem(StorageKey.auth);
    context.read<ExpenseModel>().clearData();
    _isSignedIn = false;
    notifyListeners();
  }

  void checkIfUserSignedIn() {
    final String? auth = StorageUtils.getItem(StorageKey.auth);
    _isSignedIn = auth != null;
  }
}
