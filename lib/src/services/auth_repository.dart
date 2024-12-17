import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hot_diamond_users/src/model/user/user_model.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  User? get currentUser => _firebaseAuth.currentUser;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn;

  AuthRepository(
      {FirebaseAuth? firebaseAuth,
      FirebaseFirestore? firestore,
      GoogleSignIn? googleSignIn})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn();

  // For handling errors without the "Exception:" prefix
  void handleError(String errorMessage) {
    log(errorMessage); // Log the error
    throw errorMessage; // Directly throw the string error message
  }

  Future<String?> signUp({
    required String name,
    required String email,
    required String password,
    required String phoneNumber,
  }) async {
    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        phoneNumber.isEmpty) {
      throw Exception('All fields are required');
    }

    if (password.length < 6) {
      throw Exception('Password must be at least 6 characters');
    }

    try {
      // Create user in Firebase Auth
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      final userModel = UserModel(
        uid: userCredential.user!.uid,
        name: name,
        email: email,
        phoneNumber: phoneNumber,
      );

      // Store additional user info in Firestore
      await _firestore
          .collection('users')
          .doc(userModel.uid)
          .set(userModel.toFirestore());
      return userCredential.user?.uid;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        handleError('Email is already in use.');
      } else if (e.code == 'invalid-email') {
        handleError('Email is not valid');
      } else if (e.code == 'weak-password') {
        handleError('Password is weak');
      } else {
        handleError('Sign-Up failed. Please try again.');
      }
    } catch (e) {
      handleError('Error: Something went wrong');
    }
    return null;
  }

  //! LOGIN
  Future logIn({required String email, required String password}) async {
    if (email.isEmpty || password.isEmpty) {
      throw Exception('Email and password are required');
    }

    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseException catch (e) {
      log('LOGIN AUTHORISATION ERROR');
      if (e.code == 'user-not-found') {
        handleError('No account found with this email.');
      } else if (e.code == 'wrong-password') {
        handleError('Incorrect password.');
      } else {
        log('UNKNOWN EXCEPTION $e');
        handleError('Login failed. Incorrect credentials.');
      }
    } catch (e) {
      log('LOGIN UNKNOWN ERROR $e');
      handleError('Error: Something went wrong $e');
    }
  }

  //! F O R G O T - P A S S W O R D
  Future forgotPassword(String email) async {
    if (email.isEmpty) {
      throw Exception('Email is required');
    }
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      // handling errors
      log("Something went wrong. Error: $e");
      handleError('Something went wrong. Error: $e');
    }
  }

  //!   SIGN OUT METHOD
  Future signOut() async {
    try {
      await _firebaseAuth.signOut();
      await _googleSignIn.signOut();
    } catch (e) {
      // handling errors
      log("Something went wrong. Error: $e");
      handleError('Something went wrong. Error: $e ');
    }
  }

  //! GOOGLE LOGIN
  Future<User?> googleSignIn() async {
    try {
      // Sign out from Google in case there's a previous session
      await _googleSignIn.signOut();
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        throw Exception('Google Sign-In was canceled by the user');
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      if (googleAuth.accessToken == null || googleAuth.idToken == null) {
        throw Exception('Failed to retrieve Google token');
      }

      final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

      UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      // Check if the user is new and store user data
      DocumentSnapshot snapshot = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (!snapshot.exists) {
        // If the user doesn't exist, create a new document with their details
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'name': userCredential.user!.displayName ??
              'No Name', // Ensure a name exists
          'email': userCredential.user!.email,
          'phoneNumber': userCredential.user!.phoneNumber ??
              '', // If phoneNumber is null, set it to empty
        });
      }

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      log('GOOGLE AUTH ERROR: ${e.message}');
      throw Exception('Google Login Failed: ${e.message}');
    } catch (e) {
      log('GOOGLE AUTHORIZATION ERROR: ${e.toString()}');
      throw Exception('Error: Something went wrong');
    }
  }

//! GET DATA FROM FIREBASE
  Future<UserModel?> getUserDetails() async {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      try {
        DocumentSnapshot snapshot =
            await _firestore.collection('users').doc(currentUser.uid).get();
        if (snapshot.exists) {
          return UserModel.fromFirestore(snapshot);
        } else {
          return null; // User data not found
        }
      } catch (e) {
        throw Exception('Error fetching user details: $e');
      }
    }
    // If no current user is logged in
    return null;
  }
}
