// main_wrapper.dart
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hot_diamond_users/src/controllers/connectivity/connectivity_bloc.dart';
import 'package:hot_diamond_users/src/controllers/connectivity/connectivity_event.dart';
import 'package:hot_diamond_users/src/controllers/connectivity/connectivity_state.dart';
import 'package:hot_diamond_users/src/screens/auth/login/login.dart';
import 'package:hot_diamond_users/src/screens/connectivity_checker/no_internet_screen.dart';
import 'package:hot_diamond_users/src/screens/home/order_type/order_type.dart';
import 'package:hot_diamond_users/src/services/notification_service/nortification_service.dart';

class MainWrapper extends StatelessWidget {
  const MainWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ConnectivityBloc, ConnectivityState>(
      listener: (context, connectivityState) {
        if (connectivityState.isConnected) {
          // Trigger a rebuild when the network is connected
          context.read<ConnectivityBloc>().add(CheckConnectivity());
        }
      },
      child: BlocBuilder<ConnectivityBloc, ConnectivityState>(
        builder: (context, connectivityState) {
          if (!connectivityState.isConnected) {
            return NoInternetScreen(
              onRetry: () {
                context.read<ConnectivityBloc>().add(CheckConnectivity());
              },
            );
          }

          return Scaffold(
            body: StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                log('AuthState Changed: ${snapshot.data}');
                
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Error'));
                } else {
                  if (snapshot.data == null) {
                    return const Login();
                  } else {
                    NortificationService().uploadFcmToken();
                    return const OrderType();
                  }
                }
              },
            ),
          );
        },
      ),
    );
  }
}