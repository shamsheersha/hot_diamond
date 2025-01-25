import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hot_diamond_users/src/enum/discount_type.dart';
import 'package:hot_diamond_users/src/model/offer/offer_model.dart';
import 'package:hot_diamond_users/src/model/variation/variation_model.dart';

class ItemModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final String categoryId;
  final List<String> imageUrls;
  final List<VariationModel> variations;
  final OfferModel? offer;
  final bool isInStock;

  ItemModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.categoryId,
    required this.imageUrls,
    this.variations = const [],
    this.offer,
    this.isInStock = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'categoryId': categoryId,
      'imageUrls': imageUrls,
      'variations': variations.map((v) => v.toMap()).toList(),
      'offer': offer?.toMap(),
      'isInStock': isInStock,
    };
  }

  factory ItemModel.fromMap(Map<String, dynamic> map, {String? id}) {
    return ItemModel(
      id: id ?? map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      price: (map['price'] is double)
          ? map['price']
          : (map['price']?.toDouble() ?? 0.0),
      categoryId: map['categoryId'] as String,
      imageUrls: List<String>.from(map['imageUrls'] ?? []),
      variations: (map['variations'] as List<dynamic>? ?? [])
          .map((v) => VariationModel.fromMap(v as Map<String, dynamic>))
          .toList(),
      offer: map['offer'] != null ? OfferModel.fromMap(map['offer']) : null,
      isInStock: map['isInStock'] as bool? ?? true,
    );
  }

  factory ItemModel.fromFireStore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return ItemModel(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] is double)
          ? data['price']
          : (data['price']?.toDouble() ?? 0.0),
      categoryId: data['categoryId'] ?? '',
      imageUrls: List<String>.from(data['imageUrls'] ?? []),
      variations: (data['variations'] as List<dynamic>? ?? [])
          .map((v) => VariationModel.fromMap(v as Map<String, dynamic>))
          .toList(),
      offer: data['offer'] != null ? OfferModel.fromMap(data['offer']) : null,
      isInStock: data['isInStock'] as bool? ?? true,
    );
  }

  bool get hasValidOffer {
    if (offer == null || !offer!.isEnabled) return false;
    final now = DateTime.now();
    return now.isAfter(offer!.startDate) && now.isBefore(offer!.endDate);
  }

  double calculateDiscountedPrice(double originalPrice) {
    if (!hasValidOffer) return originalPrice;

    if (offer!.discountType == DiscountType.percentage) {
      return originalPrice - (originalPrice * (offer!.discountValue / 100));
    } else {
      return originalPrice - offer!.discountValue;
    }
  }

  double get finalPrice {
    double basePrice = price;
    if (variations.isNotEmpty) {
      basePrice = variations.map((v) => v.price).reduce((a, b) => a < b ? a : b);
    }
    return hasValidOffer ? calculateDiscountedPrice(basePrice) : basePrice;
  }
}
