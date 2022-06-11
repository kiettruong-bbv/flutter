import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class ThemeState extends Equatable {
  const ThemeState();

  @override
  List<Object> get props => [];
}

class ThemeInitial extends ThemeState {}

class ThemeUpdated extends ThemeState {
  final ThemeMode themeMode;

  const ThemeUpdated({required this.themeMode});

  @override
  List<Object> get props => [themeMode];
}
