import 'package:equatable/equatable.dart';
import 'package:hot_diamond_users/src/model/item/item_model.dart';

abstract class CartState extends Equatable {
  const CartState();
}

class CartInitial extends CartState {
  @override  
  List<Object> get props => [];
}

class CartUpdated extends CartState {
  final List<CartItem> items;

  const CartUpdated(this.items);

  @override
  List<Object> get props => [items];
}
class CartError extends CartState {
  final String message; // Error message
  const CartError(this.message);
  @override
  List<Object> get props => [message];
}
class CartItem {
  final ItemModel item;
  final int quantity;

  CartItem(this.item, this.quantity);
}
