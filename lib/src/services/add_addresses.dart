import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hot_diamond_users/src/model/address/address_model.dart';

class AddressService {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  AddressService({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  Future<List<Address>> getAddresses() async {
    final user = _auth.currentUser;
    if (user == null) throw  Exception('User not authenticated');

    final snapshot = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('addresses')
        .get();

    return snapshot.docs
        .map((doc) => Address.fromMap(doc.data(), doc.id))
        .toList();
  }

  Stream<List<Address>> addressesStream() {
    final user = _auth.currentUser;
    if (user == null) throw  Exception('User not authenticated');

    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('addresses')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Address.fromMap(doc.data(), doc.id)).toList());
  }

  Future<void> addAddress(Address address) async {
    final user = _auth.currentUser;
    if (user == null) throw  Exception('User not authenticated');

    // Start a batch write
    final batch = _firestore.batch();
    final addressesRef = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('addresses');

    // If this is set as default, update all other addresses to non-default
    if (address.isDefault) {
      final existingAddresses = await addressesRef.get();
      for (var doc in existingAddresses.docs) {
        batch.update(doc.reference, {'isDefault': false});
      }
    }

    // Add the new address
    batch.set(addressesRef.doc(address.id), address.toMap());

    // Commit the batch
    await batch.commit();
  }

  Future<void> updateAddress(Address address) async {
    final user = _auth.currentUser;
    if (user == null) throw  Exception('User not authenticated');

    final batch = _firestore.batch();
    final addressesRef = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('addresses');

    if (address.isDefault) {
      final existingAddresses = await addressesRef.get();
      for (var doc in existingAddresses.docs) {
        if (doc.id != address.id) {
          batch.update(doc.reference, {'isDefault': false});
        }
      }
    }

    batch.update(addressesRef.doc(address.id), address.toMap());
    await batch.commit();
  }

  Future<void> deleteAddress(String addressId) async {
    final user = _auth.currentUser;
    if (user == null) throw  Exception('User not authenticated');

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('addresses')
        .doc(addressId)
        .delete();
  }
}