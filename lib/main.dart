import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hot_diamond_users/src/controllers/cart/cart_bloc.dart';
import 'package:hot_diamond_users/src/controllers/category/category_bloc.dart';
import 'package:hot_diamond_users/src/controllers/favorite/favorite_bloc.dart';
import 'package:hot_diamond_users/src/controllers/favorite/favorite_event.dart';
import 'package:hot_diamond_users/src/controllers/item/item_bloc.dart';
import 'package:hot_diamond_users/src/controllers/location/location_bloc.dart';
import 'package:hot_diamond_users/src/controllers/location/location_event.dart';
import 'package:hot_diamond_users/src/screens/home/splash/splash.dart';
import 'package:hot_diamond_users/src/controllers/auth/authentication_bloc.dart';
import 'package:hot_diamond_users/src/controllers/splash/splash_bloc.dart';
import 'package:hot_diamond_users/src/controllers/user_details/user_details_bloc.dart';
import 'package:hot_diamond_users/src/services/auth_repository.dart';
import 'package:location/location.dart' as loc;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    if (kIsWeb) {
      await Firebase.initializeApp(
          options: const FirebaseOptions(
              apiKey: "AIzaSyAg_WC6OaMoZ5JpQsQ-rH_HRCbas81fP7Y",
              authDomain: "hotdiamond-dc51c.firebaseapp.com",
              projectId: "hotdiamond-dc51c",
              storageBucket: "hotdiamond-dc51c.firebasestorage.app",
              messagingSenderId: "175234495774",
              appId: "1:175234495774:web:fbfa20be7c93bb46e5850f",
              measurementId: "G-ZJME8C5VKM"));
    } else {
      await Firebase.initializeApp();
    }

    // Ensure FirebaseAuth persists the session across app restarts
    // await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
  } catch (e) {
    log('Firebase Initialization error $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = AuthRepository();
    loc.Location locationService = loc.Location();
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => SplashBloc()..add(StartSplash())),
          BlocProvider(
              create: (context) => AuthenticationBloc(authRepository: auth)),
          BlocProvider(
              create: (context) =>
                  UserDetailsBloc(authRepository: AuthRepository())
                    ..add(FetchUserDetails())),
          BlocProvider(
            create: (context) =>
                LocationBloc(locationController: locationService)..add(FetchLocationEvent()),
          ),
          BlocProvider(
            create: (context) => CategoryBloc(),
          ),
          BlocProvider(
            create: (context) => ItemBloc(),
          ),
          BlocProvider(
            create: (context) => FavoriteBloc(
                auth: FirebaseAuth.instance,
                firestore: FirebaseFirestore.instance)
              ..add(LoadFavorites()),
          ),
          BlocProvider(create: (context) => CartBloc())
        ],
        child: MaterialApp(
            title: 'Hot Diamond Users',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
                primaryColor: Colors.red,
                // appBarTheme: const AppBarTheme(color: Colors.red),
                scaffoldBackgroundColor: Colors.grey[100]),
            home: const Splash()));
  }
}
