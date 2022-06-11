import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class RootState extends Equatable {
  const RootState();

  @override
  List<Object> get props => [];
}

class Uninitialized extends RootState {}

class Unauthenticated extends RootState {}

class Authenticated extends RootState {}

class NoInternetConnection extends RootState {}
