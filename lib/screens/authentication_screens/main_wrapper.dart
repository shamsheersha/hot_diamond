import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hot_diamond_users/screens/authentication_screens/login_signup/login/login.dart';
import 'package:hot_diamond_users/screens/main_screens/home_screen.dart';
import 'package:hot_diamond_users/screens/main_screens/order_type/order_type.dart';

class MainWrapper extends StatelessWidget {
  const MainWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(stream: FirebaseAuth.instance.authStateChanges(), builder: (context, snapshot) {
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