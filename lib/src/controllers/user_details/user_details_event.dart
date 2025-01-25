

import 'package:equatable/equatable.dart';

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

class UpdateProfileImage extends UserDetailsEvent {
  final String imagePath;
  final String email;

  const UpdateProfileImage({
    required this.imagePath,
    required this.email,
  });

  @override
  List<Object> get props => [imagePath, email];
}