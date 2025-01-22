import 'package:equatable/equatable.dart';
import 'package:hot_diamond_users/src/model/address/address_model.dart';

// Define AddressEvent with Equatable
abstract class AddressEvent extends Equatable {
  const AddressEvent();

  @override
  List<Object?> get props => [];
}

class LoadAddresses extends AddressEvent {}

class AddAddress extends AddressEvent {
  final Address address;
  const AddAddress(this.address);

  @override
  List<Object?> get props => [address];
}

class UpdateAddress extends AddressEvent {
  final Address address;
  const UpdateAddress(this.address);

  @override
  List<Object?> get props => [address];
}

class DeleteAddress extends AddressEvent {
  final String addressId;
  const DeleteAddress(this.addressId);

  @override
  List<Object?> get props => [addressId];
}