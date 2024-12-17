part of 'user_details_bloc.dart';

abstract class UserDetailsEvent extends Equatable {
  const UserDetailsEvent();

  @override
  List<Object?> get props => [];
}

class FetchUserDetails extends UserDetailsEvent {}
class UpdateUserDetails extends UserDetailsEvent {
  final String name;
  final String email;
  final String phoneNumber;

  const UpdateUserDetails({
    required this.name,
    required this.email,
    required this.phoneNumber,
  });
}