part of 'user_details_bloc.dart';

abstract class UserDetailsState extends Equatable {
  const UserDetailsState();
  
  @override
  List<Object> get props => [];
}

 class UserDetailsInitial extends UserDetailsState {}

 class UserDetailsLoading extends UserDetailsState{}

 class UserDetailsLoaded extends UserDetailsState{
  final String name;
  final String phoneNumber;

  const UserDetailsLoaded({required this.name,required this.phoneNumber});

  @override  
  List<Object> get props => [name,phoneNumber];
 }

class UserDetailsError extends UserDetailsState{
  final String error;

  const UserDetailsError({required this.error});

  @override  
  List<Object> get props => [error];
}
