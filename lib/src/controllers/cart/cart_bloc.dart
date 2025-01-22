import 'dart:async';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hot_diamond_users/src/controllers/cart/cart_event.dart';
import 'package:hot_diamond_users/src/controllers/cart/cart_state.dart';
import 'package:hot_diamond_users/src/services/cart_services.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartService _cartService;

  CartBloc({
    required CartService cartService,
  })  : _cartService = cartService,
        super(CartInitial()) {
    on<LoadCart>(_onLoadCart);
    on<AddItemToCart>(_onAddItemToCart);
    on<RemoveItemFromCart>(_onRemoveItemFromCart);
    on<ClearCart>(_onClearCart);
    on<UpdateCartItemQuantity>(_onUpdateCartItemQuantity);
  }

  Future<void> _onLoadCart(LoadCart event, Emitter<CartState> emit) async {
    emit(CartLoading());
    log('Loading cart...');

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        log('User not authenticated in CartBloc');
        emit(const CartError('User not authenticated'));
        return;
      }

      final cartItems = await _cartService.getCart();
      log('Received ${cartItems.length} cart items');
      emit(CartUpdated(cartItems));
    } catch (error) {
      log('Exception in _onLoadCart', error: error);
      emit(CartError(error.toString()));
    }
  }

  Future<void> _onUpdateCartItemQuantity(
    UpdateCartItemQuantity event,
    Emitter<CartState> emit,
  ) async {
    // Get current state
    if (state is CartUpdated) {
      final currentState = state as CartUpdated;
      final updatedItems = currentState.items.map((item) {
        if (item.item.id == event.cartItem.item.id && 
            item.selectedVariation == event.cartItem.selectedVariation) {
          return item.copyWith(quantity: event.newQuantity);
        }
        return item;
      }).toList();

      // Emit updated state immediately
      emit(CartUpdated(updatedItems));

      try {
        // Update in backend
        await _cartService.updateCartItemQuantity(
          event.cartItem.item.id,
          event.newQuantity,
          variation: event.cartItem.selectedVariation,
        );
      } catch (error) {
        // If backend update fails, revert to original state
        emit(CartUpdated(currentState.items));
        emit(CartError(error.toString()));
      }
    }
  }

  Future<void> _onAddItemToCart(
      AddItemToCart event, Emitter<CartState> emit) async {
    try {
      await _cartService.addToCart(
        event.item,
        event.quantity,
        selectedVariation: event.selectedVariation,
      );
      add(LoadCart());
    } catch (error) {
      emit(CartError(error.toString()));
    }
  }

  Future<void> _onRemoveItemFromCart(
      RemoveItemFromCart event, Emitter<CartState> emit) async {
    if (state is CartUpdated) {
      final currentState = state as CartUpdated;
      final updatedItems = currentState.items.where((item) => 
        item.item.id != event.item.id || 
        item.selectedVariation != event.selectedVariation
      ).toList();

      // Emit updated state immediately
      emit(CartUpdated(updatedItems));

      try {
        await _cartService.removeFromCart(
          event.item.id,
          variation: event.selectedVariation,
        );
      } catch (error) {
        // If backend update fails, revert to original state
        emit(CartUpdated(currentState.items));
        emit(CartError(error.toString()));
      }
    }
  }

  Future<void> _onClearCart(ClearCart event, Emitter<CartState> emit) async {
    try {
      await _cartService.clearCart();
      emit(const CartUpdated([]));
    } catch (error) {
      emit(CartError(error.toString()));
    }
  }
}