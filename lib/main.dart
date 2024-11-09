import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hot_diamond_users/blocs/authentication/auth_bloc/authentication_bloc.dart';
import 'package:hot_diamond_users/blocs/splash/splash_bloc.dart';
import 'package:hot_diamond_users/screens/splash_screen.dart/splash.dart';
import 'package:hot_diamond_users/services/auth_repository.dart';

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
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => SplashBloc()..add(StartSplash())),
          BlocProvider(
              create: (context) => AuthenticationBloc(authRepository: auth)),
        ],
        child: MaterialApp(
            title: 'Hot Diamond Users',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
                primaryColor: Colors.red,
                appBarTheme: const AppBarTheme(color: Colors.red),
                scaffoldBackgroundColor: Colors.white),
            home: const Splash()));
  }
}
