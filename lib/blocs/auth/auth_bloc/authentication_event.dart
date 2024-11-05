import 'package:equatable/equatable.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();
  @override
  List<Object> get props => [];
}
//! Sign-Up Event
class SignUpEvent extends AuthenticationEvent {
  final String name;
  final String email;
  final String password;
  final String phoneNumber;

  const SignUpEvent({
    required this.name,
    required this.email,
    required this.password,
    required this.phoneNumber,
  });

  @override
  List<Object> get props => [name, email, password, phoneNumber];
}


//! Login Event
class SignInEvent extends AuthenticationEvent {
  final String email;
  final String password;

  const SignInEvent({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class ForgotPasswordEvent extends AuthenticationEvent{
  final String email;
  const ForgotPasswordEvent({required this.email});

  @override  
  List<Object> get props => [email];
}


class SignOutEvent extends AuthenticationEvent{}

class GoogleSignInEvent extends AuthenticationEvent{}