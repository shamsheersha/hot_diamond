import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hot_diamond_users/src/model/item/item_model.dart';

class ItemService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<ItemModel>> fetchAllItems() async {
    final snapshot = await _firestore.collection('items').get();
    return snapshot.docs.map((doc) => ItemModel.fromFireStore(doc)).toList();
  }

  Future<List<ItemModel>> fetchItemsByCategory(String categoryId) async {
    final snapshot = await _firestore
        .collection('items')
        .where('categoryId', isEqualTo: categoryId)
        .get();
    return snapshot.docs.map((doc) => ItemModel.fromFireStore(doc)).toList();
  }

  Future<List<ItemModel>> searchItems(String query) async {
    final snapshot = await _firestore
        .collection('items')
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThanOrEqualTo: '$query\uf8ff')
        .get();
    return snapshot.docs.map((doc) => ItemModel.fromFireStore(doc)).toList();
  }

  //! fetchItemById method
  Future<ItemModel> fetchItemById(String itemId) async {
    final docSnapshot = await _firestore.collection('items').doc(itemId).get();

    if (!docSnapshot.exists) {
      throw Exception('Item not found');
    }

    return ItemModel.fromFireStore(docSnapshot);
  }

  //! updateItem method
  Future<void> updateItem(ItemModel item) async {
    await _firestore.collection('items').doc(item.id).set(item.toMap(), SetOptions(merge: true));
  }
}
