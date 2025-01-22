import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hot_diamond_users/src/model/item/item_model.dart';
import 'package:hot_diamond_users/src/model/variation/variation_model.dart';

class CartItem {
  final ItemModel item;
  final int quantity;
  final VariationModel? selectedVariation;

  CartItem({
    required this.item,
    required this.quantity,
    this.selectedVariation,
  });

  factory CartItem.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CartItem(
      item: ItemModel.fromMap(data['item'] as Map<String, dynamic>),
      quantity: data['quantity'] as int,
      selectedVariation: data['selectedVariation'] != null
          ? VariationModel.fromMap(data['selectedVariation'] as Map<String, dynamic>)
          : null,
    );
  }

  // Add copyWith method
  CartItem copyWith({
    ItemModel? item,
    int? quantity,
    VariationModel? selectedVariation,
  }) {
    return CartItem(
      item: item ?? this.item,
      quantity: quantity ?? this.quantity,
      selectedVariation: selectedVariation ?? this.selectedVariation,
    );
  }

  double get totalPrice {
    if (selectedVariation != null) {
      return item.hasValidOffer
          ? item.calculateDiscountedPrice(selectedVariation!.price) * quantity
          : selectedVariation!.price * quantity;
    } else {
      return item.finalPrice * quantity;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'item': item.toMap(),
      'quantity': quantity,
      'selectedVariation': selectedVariation?.toMap(),
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartItem &&
          runtimeType == other.runtimeType &&
          item == other.item &&
          quantity == other.quantity &&
          selectedVariation == other.selectedVariation;

  @override
  int get hashCode =>
      item.hashCode ^ quantity.hashCode ^ selectedVariation.hashCode;
}