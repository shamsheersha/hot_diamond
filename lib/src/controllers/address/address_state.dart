import 'package:equatable/equatable.dart';
import 'package:hot_diamond_users/src/model/address/address_model.dart';

abstract class AddressState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddressInitial extends AddressState {}

class AddressLoading extends AddressState {}

class AddressesLoaded extends AddressState {
  final List<Address> addresses;

  AddressesLoaded(this.addresses);

  @override
  List<Object?> get props => [addresses];
}

class AddressOperationSuccess extends AddressState {}

class AddressError extends AddressState {
  final String message;

  AddressError(this.message);

  @override
  List<Object?> get props => [message];
}
