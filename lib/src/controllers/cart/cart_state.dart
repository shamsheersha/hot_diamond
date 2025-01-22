import 'package:equatable/equatable.dart';
import 'package:hot_diamond_users/src/model/cart/cart_item_model.dart';

abstract class CartState extends Equatable {
  const CartState();
}

class CartInitial extends CartState {
  @override
  List<Object> get props => [];
}

class CartLoading extends CartState {
  @override
  List<Object> get props => [];
}

class CartUpdated extends CartState {
  final List<CartItem> items;

  const CartUpdated(this.items);

  double get totalCartPrice {
    return items.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  @override
  List<Object> get props => [items];
}

class CartError extends CartState {
  final String message;

  const CartError(this.message);

  @override
  List<Object> get props => [message];
}