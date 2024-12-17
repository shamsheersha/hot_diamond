part of 'user_details_bloc.dart';

abstract class UserDetailsState extends Equatable {
  const UserDetailsState();

  @override
  List<Object?> get props => [];
}

class UserDetailsInitial extends UserDetailsState {}

class UserDetailsLoading extends UserDetailsState {}

class UserDetailsLoaded extends UserDetailsState {
  final String name;
  final String email;
  final String phoneNumber;

  const UserDetailsLoaded({
    required this.name,
    required this.email,
    required this.phoneNumber,
  });

  @override
  List<Object?> get props => [name, email, phoneNumber];
}


class UserDetailsUpdated extends UserDetailsState {}
class UserDetailsError extends UserDetailsState {
  final String error;

  const UserDetailsError({required this.error});

  @override
  List<Object?> get props => [error];
}
