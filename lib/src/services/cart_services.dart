import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hot_diamond_users/src/model/cart/cart_item_model.dart';
import 'package:hot_diamond_users/src/model/item/item_model.dart';
import 'package:hot_diamond_users/src/model/variation/variation_model.dart';
class CartService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String _createCartItemId(String itemId, VariationModel? variation) {
    if (variation == null) return itemId;
    return '$itemId-${variation.id}';
  }

 Future<void> addToCart(ItemModel item, int quantity, {VariationModel? selectedVariation}) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    final cartRef = _firestore.collection('users').doc(user.uid).collection('cart');
    final cartItemId = _createCartItemId(item.id, selectedVariation);

    // Check if item with this variation already exists
    final existingItem = await cartRef.doc(cartItemId).get();
    
    if (existingItem.exists) {
      // If item exists, update quantity
      final currentQuantity = existingItem.data()?['quantity'] ?? 0;
      await cartRef.doc(cartItemId).update({
        'quantity': currentQuantity + quantity,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } else {
      // If item doesn't exist, create new cart item
      final cartData = {
        'item': item.toMap(),
        'quantity': quantity,
        'selectedVariation': selectedVariation?.toMap(),
        'updatedAt': FieldValue.serverTimestamp(),
      };
      await cartRef.doc(cartItemId).set(cartData);
    }
  }
  Future<void> updateCartItemQuantity(
    String itemId,
    int quantity, {
    VariationModel? variation,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    final cartItemId = _createCartItemId(itemId, variation);
    
    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('cart')
        .doc(cartItemId)
        .update({
          'quantity': quantity,
          'updatedAt': FieldValue.serverTimestamp(),
        });
  }
    Future<CartItem?> getCartItemByVariation(String itemId, VariationModel? variation) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    final cartItemId = _createCartItemId(itemId, variation);
    final doc = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('cart')
        .doc(cartItemId)
        .get();

    if (doc.exists && doc.data() != null) {
      return CartItem.fromFirestore(doc);
    }
    return null;
  }
  Future<void> removeFromCart(String itemId, {VariationModel? variation}) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    final cartItemId = _createCartItemId(itemId, variation);

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('cart')
        .doc(cartItemId)
        .delete();
  }

  Future<void> clearCart() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    final cartRef = _firestore.collection('users').doc(user.uid).collection('cart');
    final cartItems = await cartRef.get();

    for (var doc in cartItems.docs) {
      await doc.reference.delete();
    }
  }

  // Changed from Stream to Future
  Future<List<CartItem>> getCart() async {
    final user = _auth.currentUser;
    if (user == null) {
      log('No authenticated user found in CartService.getCart()');
      throw Exception('User not authenticated');
    }

    log('Fetching cart for user: ${user.uid}');
    
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('cart')
          .get();

      log('Received cart snapshot with ${snapshot.docs.length} items');
      
      return snapshot.docs
          .map((doc) => CartItem.fromFirestore(doc))
          .toList();
    } catch (e) {
      log('Error fetching cart items', error: e);
      rethrow;
    }
  }
}