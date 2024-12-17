import 'package:cloud_firestore/cloud_firestore.dart';

class ItemModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final String categoryId;
  final List<String> imageUrls; // List of image URLs

  ItemModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.categoryId,
    required this.imageUrls,
  });

  //! Convert ItemModel to Map (for Firebase)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'categoryId': categoryId,
      'imageUrls': imageUrls, // Storing list of image URLs
    };
  }

  //! Create ItemModel from Map (for fetching from Firebase)
  factory ItemModel.fromMap(Map<String, dynamic> map, {String? id}) {
    return ItemModel(
      id: id ?? map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      price: map['price'] is double
          ? map['price']
          : (map['price']?.toDouble() ?? 0.0),
      categoryId: map['categoryId'] as String,
      imageUrls: List<String>.from(map['imageUrls'] ?? []), // Convert list
    );
  }

  //! Create ItemModel from Firestore DocumentSnapshot
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
    );
  }
}
