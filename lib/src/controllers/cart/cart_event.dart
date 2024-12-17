import 'package:equatable/equatable.dart';
import 'package:hot_diamond_users/src/model/item/item_model.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();
}

class AddItemToCart extends CartEvent {
  final ItemModel item;
  final int quantity;

  const AddItemToCart(this.item, this.quantity);

  @override
  List<Object> get props => [item, quantity];
}
class FetchCartItems extends CartEvent {
  @override
  List<Object> get props => [];
}
class RemoveItemFromCart extends CartEvent {
  final ItemModel item;

  const RemoveItemFromCart(this.item);

  @override
  List<Object> get props => [item];
}

class ClearCart extends CartEvent {
  @override
  List<Object> get props => [];
}