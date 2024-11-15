import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hot_diamond_users/src/screens/auth/login/login.dart';
import 'package:hot_diamond_users/src/screens/home/order_type/order_type.dart';

class MainWrapper extends StatelessWidget {
  const MainWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(stream: FirebaseAuth.instance.authStateChanges(), builder: (context, snapshot) {
        log('AuthState Changed: ${snapshot.data}');
        if(snapshot.connectionState == ConnectionState.waiting){
          return const Center(child: CircularProgressIndicator(),);
        }else if(snapshot.hasError){
          return const Center(child: Text('Error'),);
        }else{
          if(snapshot.data == null){
            return const Login();
          }else{
            return const OrderType();
          }
        }
      },),
    );
  }
}