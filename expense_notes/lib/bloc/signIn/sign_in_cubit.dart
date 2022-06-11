import 'package:expense_notes/bloc/signIn/sign_in_state.dart';
import 'package:expense_notes/model/auth.dart';
import 'package:expense_notes/repository/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInCubit extends Cubit<SignInState> {
  final IAuthRepository _authRepository;

  SignInCubit(this._authRepository) : super(SignInInitial());

  void onEmailChanged(String email) {
    emit(EmailUpdate());
  }

  void onPasswordChanged(String password) {
    emit(PasswordUpdate());
  }

  Future signIn({
    required String email,
    required String password,
  }) async {
    emit(SignInLoading());
    try {
      final AuthResponse? auth = await _authRepository.signIn(
        email: email,
        password: password,
      );
      if (auth != null) {
        await _authRepository.storeAuthInfo(authResponse: auth);
        emit(SignInSuccess(authResponse: auth));
      } else {
        emit(
          const SignInFailure(
            message: 'Sign in failed.',
          ),
        );
      }
    } catch (e) {
      emit(
        SignInFailure(message: e.toString()),
      );
    }
  }
}
