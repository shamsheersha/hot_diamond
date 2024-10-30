part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SignUpEvent extends AuthEvent {
  final String name;
  final String email;
  final String password;
  final String phone;

  SignUpEvent(
      {required this.name,
      required this.email,
      required this.password,
      required this.phone});

  @override
  List<Object> get props => [name, email, password, phone];
}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  LoginEvent({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}
