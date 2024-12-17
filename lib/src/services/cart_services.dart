// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:hot_diamond_users/src/model/item/item_model.dart';

// class CartServices {
//   final _firestore = FirebaseFirestore.instance;
//   final _auth = FirebaseAuth.instance;

//   // Get current user id
//   String get _userId => _auth.currentUser!.uid;

//   // Add item to cart
//   Future<void> addToCart(ItemModel item, int quantity) async {
//     try {
//       // Create a new map that includes the item data and quantity
//       final cartItemData = item.toMap();
//       cartItemData['quantity'] = quantity;

//       await _firestore
//           .collection('users')
//           .doc(_userId)
//           .collection('cart')
//           .doc(item.id)
//           .set(cartItemData);
//     } catch (error) {
//       print('Error adding item to cart: $error');
//       rethrow;
//     }
//   }

//   // Fetch cart items
//   Future<List<ItemModel>> fetchCartItems() async {
//     try {
//       final querySnapshot = await _firestore
//           .collection('users')
//           .doc(_userId)
//           .collection('cart')
//           .get();

//       return querySnapshot.docs.map((doc) {
//         // Convert the document to an ItemModel and include the quantity
//         final data = doc.data();
//         final item = ItemModel.fromFireStore(doc);
//         return item;
//       }).toList();
//     } catch (e) {
//       print('Error fetching cart items: $e');
//       return [];
//     }
//   }

//   // Remove item from cart
//   Future<void> removeFromCart(String itemId) async {
//     await _firestore
//         .collection('users')
//         .doc(_userId)
//         .collection('cart')
//         .doc(itemId)
//         .delete();
//   }

//   // Clear entire cart
//   Future<void> clearCart() async {
//     try {
//       final cartCollection =
//           _firestore.collection('users').doc(_userId).collection('cart');

//       // Get all documents in the cart
//       final snapShot = await cartCollection.get();

//       // Delete each document
//       for (DocumentSnapshot doc in snapShot.docs) {
//         await doc.reference.delete();
//       }
//     } catch (error) {
//       print('Error clearing cart: $error');
//       rethrow;
//     }
//   }
// }