import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String phoneNumber;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.phoneNumber,
  });

  // Factory method to create a UserModel from Firestore data
  factory UserModel.fromFirestore(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return UserModel(
      uid: snapshot.id,
      name: data['name'] ?? 'No Name',
      email: data['email'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
    );
  }

  // Convert UserModel to a map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
    };
  }
}
