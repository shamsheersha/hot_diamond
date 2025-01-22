import 'package:equatable/equatable.dart';
import 'package:hot_diamond_users/src/model/cart/cart_item_model.dart';
import 'package:hot_diamond_users/src/model/item/item_model.dart';
import 'package:hot_diamond_users/src/model/variation/variation_model.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class LoadCart extends CartEvent {}

class AddItemToCart extends CartEvent {
  final ItemModel item;
  final int quantity;
  final VariationModel? selectedVariation;

  const AddItemToCart(this.item, this.quantity, {this.selectedVariation});

  @override
  List<Object?> get props => [item, quantity, selectedVariation];
}

class RemoveItemFromCart extends CartEvent {
  final ItemModel item;
  final VariationModel? selectedVariation;

  const RemoveItemFromCart(this.item, {this.selectedVariation});

  @override
  List<Object?> get props => [item, selectedVariation];
}

class UpdateCartItemQuantity extends CartEvent {
  final CartItem cartItem;
  final int newQuantity;

  const UpdateCartItemQuantity(this.cartItem, this.newQuantity);

  @override
  List<Object?> get props => [cartItem, newQuantity];
}

class ClearCart extends CartEvent {}
