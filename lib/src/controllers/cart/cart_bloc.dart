import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hot_diamond_users/src/controllers/cart/cart_event.dart';
import 'package:hot_diamond_users/src/controllers/cart/cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final List<CartItem> _cartItems = [];

  CartBloc() : super(CartInitial()) {
    // Register event handlers
    on<AddItemToCart>(_onAddItemToCart);
    on<RemoveItemFromCart>(_onRemoveItemFromCart);
    on<ClearCart>(_onClearCart);
  }

  Future<void> _onAddItemToCart(
      AddItemToCart event, Emitter<CartState> emit) async {
    // Check if item already exists in cart
    final existingItemIndex =
        _cartItems.indexWhere((cartItem) => cartItem.item.id == event.item.id);

    if (existingItemIndex != -1) {
      // Update quantity of existing item
      _cartItems[existingItemIndex] = CartItem(
          _cartItems[existingItemIndex].item,
          _cartItems[existingItemIndex].quantity + event.quantity);
    } else {
      // Add new item to cart
      _cartItems.add(CartItem(event.item, event.quantity));
    }

    // Emit the updated cart state
    emit(CartUpdated(List.from(_cartItems)));
  }

  Future<void> _onRemoveItemFromCart(
      RemoveItemFromCart event, Emitter<CartState> emit) async {
    // Remove specific item from cart
    _cartItems.removeWhere((cartItem) => cartItem.item.id == event.item.id);

    // Emit the updated cart state
    emit(CartUpdated(List.from(_cartItems)));
  }

  Future<void> _onClearCart(ClearCart event, Emitter<CartState> emit) async {
    // Clear all items from cart
    _cartItems.clear();

    // Emit the initial cart state
    emit(CartInitial());
  }
}
