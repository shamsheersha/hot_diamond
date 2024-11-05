import 'package:equatable/equatable.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

// General initial state for all
class AuthenticationInitial extends AuthenticationState {}

//! S I G N - U P
class SignUpLoading extends AuthenticationState {}

class SignUpSuccess extends AuthenticationState {}

class SignUpFailture extends AuthenticationState {
  final String error;
  const SignUpFailture({required this.error});

  @override
  List<Object> get props => [error];
}

//! L O G I N
class LoginLoading extends AuthenticationState {}

class LoginSuccess extends AuthenticationState {}

class LoginFailture extends AuthenticationState {
  final String error;
  const LoginFailture({required this.error});

  @override
  List<Object> get props => [error];
}

//! R E S E T - P A S S W O R D
class ForgotPasswordLoading extends AuthenticationState {}

class ForgotPasswordSuccess extends AuthenticationState {}

class ForgotPasswordFailture extends AuthenticationState {
  final String error;
  const ForgotPasswordFailture({required this.error});

  @override
  List<Object> get props => [error];
}

//! L O G - O U T
class LogOutLoading extends AuthenticationState {}

class LogOutSuccess extends AuthenticationState {}

class LogOutFailture extends AuthenticationState {
  final String error;
  const LogOutFailture({required this.error});

  @override
  List<Object> get props => [error];
}

//! G O O G L E - S I G N U P
class GoogleLogInLoading extends AuthenticationState {}

class GoogleLogInSuccess extends AuthenticationState {}

class GoogleLogInFailture extends AuthenticationState {
  final String error;
  const GoogleLogInFailture({required this.error});

  @override
  List<Object> get props => [error];
}
