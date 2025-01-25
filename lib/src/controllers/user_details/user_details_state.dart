
import 'package:equatable/equatable.dart';

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
  final String? profileImage;

  const UserDetailsLoaded({
    required this.name,
    required this.email,
    required this.phoneNumber,
    this.profileImage,
  });

  @override
  List<Object?> get props => [name, email, phoneNumber, profileImage];
}


class UserDetailsUpdated extends UserDetailsState {}
class UserDetailsError extends UserDetailsState {
  final String error;

  const UserDetailsError({required this.error});

  @override
  List<Object?> get props => [error];
}
