import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;
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

  Future<String?> signUp(
      {required String name,
      required String email,
      required String password,
      required String phoneNumber}) async {
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
      //Create user in Firebase Auth
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      // Store additional user info in Firebase
      await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({'name': name, 'email': email, 'phoneNumber': phoneNumber});
      return userCredential.user?.uid;
    } on FirebaseAuthException catch (e) {
      log('SIGNUP AUTHORISATION ERROR');
      if (e.code == 'email-already-in-use') {
        handleError('Email is already in use.');
      } else if (e.code == 'invalid-email') {
        handleError('Email is not valid');
      } else if (e.code == 'weak-password') {
        handleError('Pasword is weak');
      } else {
        handleError('Sign-Up failed. Please try again.');
      }
    } catch (e) {
      log('SIGNUP UNKNOWN ERROR');
      handleError('Error: Something went wrong');
    }
    return null;
  }

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

  //! GOOGLE SIGN-IN METHOD
  Future<User?> googleSignIn() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if(googleUser == null){
        throw Exception('Google Sign-In aborted');
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(accessToken:  googleAuth.accessToken,idToken:  googleAuth.idToken);

      UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);


      if(userCredential.additionalUserInfo?.isNewUser  ?? false){
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'name': userCredential.user!.displayName,
          'email': userCredential.user!.email,
          'phoneNumber': userCredential.user!.phoneNumber
        });
      }
      return userCredential.user;
    } catch (e) {
      log("GOOGLE AUTHORISATION ERROR");
      handleError("Error: Something went wrong");
    }
    return null;
  }
}
