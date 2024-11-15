import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRepository {



  //! ADDING LOCATION DETAILS TO EXISTING COLLECTION
  Future<void> storeLocationInFirestore(String city, String area) async {
  try {
    // Query the 'users' collection for the document with the current user's email
    QuerySnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email)
        .get();

    // Check if the user document exists
    if (userSnapshot.docs.isNotEmpty) {
      // Get the first document from the query results
      DocumentSnapshot userDoc = userSnapshot.docs.first;

      // Update the document with the new city, area, and createdAt fields
      await userDoc.reference.update({
        'city': city,
        'area': area,
        'createdAt': Timestamp.now(), // Store the current timestamp
      });

      log('User location updated successfully!');
    } else {
      log('User not found with the email: ${FirebaseAuth.instance.currentUser!.email}');
    }
  } catch (e) {
    log('Error updating location: $e');
  }
}
}