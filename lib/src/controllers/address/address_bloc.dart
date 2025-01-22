import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hot_diamond_users/src/controllers/address/address_event.dart';
import 'package:hot_diamond_users/src/controllers/address/address_state.dart';
import 'package:hot_diamond_users/src/services/add_addresses.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  final AddressService _addressService;

  AddressBloc(this._addressService) : super(AddressInitial()) {
    on<LoadAddresses>(_onLoadAddresses);
    on<AddAddress>(_onAddAddress);
    on<UpdateAddress>(_onUpdateAddress);
    on<DeleteAddress>(_onDeleteAddress);
  }

  Future<void> _onLoadAddresses(
    LoadAddresses event,
    Emitter<AddressState> emit,
  ) async {
    emit(AddressLoading());
    try {
      final addresses = await _addressService.getAddresses();
      emit(AddressesLoaded(addresses));
    } catch (e) {
      emit(AddressError(e.toString()));
    }
  }

  Future<void> _onAddAddress(
    AddAddress event,
    Emitter<AddressState> emit,
  ) async {
    emit(AddressLoading());
    try {
      await _addressService.addAddress(event.address);
      // First emit success
      emit(AddressOperationSuccess());
      // Then load addresses
      final addresses = await _addressService.getAddresses();
      emit(AddressesLoaded(addresses));
    } catch (e) {
      emit(AddressError(e.toString()));
    }
  }

  Future<void> _onUpdateAddress(
    UpdateAddress event,
    Emitter<AddressState> emit,
  ) async {
    emit(AddressLoading());
    try {
      await _addressService.updateAddress(event.address);
      emit(AddressOperationSuccess());
      final addresses = await _addressService.getAddresses();
      emit(AddressesLoaded(addresses));
    } catch (e) {
      emit(AddressError(e.toString()));
    }
  }

  Future<void> _onDeleteAddress(
    DeleteAddress event,
    Emitter<AddressState> emit,
  ) async {
    emit(AddressLoading());
    try {
      await _addressService.deleteAddress(event.addressId);
      emit(AddressOperationSuccess());
      final addresses = await _addressService.getAddresses();
      emit(AddressesLoaded(addresses));
    } catch (e) {
      emit(AddressError(e.toString()));
    }
  }
}