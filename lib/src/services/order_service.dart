import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hot_diamond_users/src/enum/checkout_enums.dart';
import 'package:hot_diamond_users/src/model/address/address_model.dart';
import 'package:hot_diamond_users/src/model/cart/cart_item_model.dart';
import 'package:hot_diamond_users/src/model/order/order_model.dart';

class OrderServices {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<OrderModel> createOrder({
    required List<CartItem> items,
    required Address deliveryAddress,
    required double totalAmount,
    required PaymentMethod paymentMethod,
  }) async {
    try {
      final userId = _auth.currentUser!.uid;
      final orderRef = _firestore.collection('orders').doc();

      final orderData = {
        'userId': userId,
        'items': items.map((item) => item.toMap()).toList(),
        'deliveryAddress': deliveryAddress.toMap(),
        'totalAmount': totalAmount,
        'createdAt': FieldValue.serverTimestamp(), // Use server timestamp
        'status': OrderStatus.pending.toString().split('.').last,
        'paymentMethod': paymentMethod.toString().split('.').last,
      };

      await orderRef.set(orderData);

      // Fetch the created document to get the server timestamp
      final createdDoc = await orderRef.get();
      final createdData = createdDoc.data() as Map<String, dynamic>;

      return OrderModel.fromMap(createdData, orderRef.id);
    } catch (error) {
      throw Exception('Failed to create order: $error');
    }
  }

  Future<List<OrderModel>> fetchUserOrders() async {
    try {
      final userId = _auth.currentUser!.uid;
      
      // Query with proper index usage
      final orderSnapshot = await _firestore
          .collection('orders')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get()
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw Exception('Request timeout: Please check your internet connection'),
          );

      return orderSnapshot.docs
          .map((doc) => OrderModel.fromMap(
                Map<String, dynamic>.from(doc.data()),
                doc.id,
              ))
          .toList();
    } catch (error) {
      if (error is FirebaseException && error.code == 'failed-precondition') {
        throw Exception(
          'Database index not found. Please wait a few minutes for the index to be created and try again.',
        );
      }
      throw Exception('Failed to fetch orders: $error');
    }
  }

  Future<void> updateOrderStatus({
    required String orderId,
    required OrderStatus newStatus,
  }) async {
    try {
      await _firestore.collection('orders').doc(orderId).update({
        'status': newStatus.toString().split('.').last,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (error) {
      throw Exception('Failed to update order status: $error');
    }
  }
}