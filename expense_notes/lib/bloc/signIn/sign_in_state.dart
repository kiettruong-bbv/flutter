import 'package:equatable/equatable.dart';
import 'package:expense_notes/model/auth.dart';

abstract class SignInState extends Equatable {
  const SignInState();

  @override
  List<Object> get props => [];
}

class SignInInitial extends SignInState {}

class SignInLoading extends SignInState {}

class EmailUpdate extends SignInState {}

class PasswordUpdate extends SignInState {}

class SignInSuccess extends SignInState {
  final AuthResponse authResponse;

  const SignInSuccess({required this.authResponse});

  @override
  List<Object> get props => [authResponse];
}

class SignInFailure extends SignInState {
  final String message;

  const SignInFailure({required this.message});

  @override
  List<Object> get props => [message];
}
