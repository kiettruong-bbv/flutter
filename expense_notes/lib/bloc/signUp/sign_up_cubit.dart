import 'package:expense_notes/bloc/signUp/sign_up_state.dart';
import 'package:expense_notes/model/auth.dart';
import 'package:expense_notes/repository/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpCubit extends Cubit<SignUpState> {
  final IAuthRepository _authRepository;

  SignUpCubit(this._authRepository) : super(SignUpInitial());

  void onEmailChanged(String email) {
    emit(EmailUpdate());
  }

  void onPasswordChanged(String password) {
    emit(PasswordUpdate());
  }

  Future signUp({
    required String email,
    required String password,
  }) async {
    emit(SignUpLoading());
    try {
      final AuthResponse? auth = await _authRepository.signUp(
        email: email,
        password: password,
      );
      if (auth != null) {
        emit(SignUpSuccess());
      } else {
        emit(const SignUpFailure(message: 'Sign up failed.'));
      }
    } catch (e) {
      emit(
        SignUpFailure(message: e.toString()),
      );
    }
  }
}
