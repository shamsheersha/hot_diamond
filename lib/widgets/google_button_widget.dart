
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:hot_diamond_users/blocs/authentication/auth_bloc/authentication_bloc.dart';
import 'package:hot_diamond_users/blocs/authentication/auth_bloc/authentication_event.dart';
import 'package:hot_diamond_users/blocs/authentication/auth_bloc/authentication_state.dart';
import 'package:hot_diamond_users/screens/main_screens/home_screen.dart';
import 'package:hot_diamond_users/widgets/show_custom%20_snakbar.dart';

class GoogleLoginButton extends StatelessWidget {
  const GoogleLoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is GoogleLogInSuccess) {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => const HomeScreen()));
        } else if (state is GoogleLogInLoading) {
          const Center(
            child: CircularProgressIndicator(color: Colors.black,),
          );
        } else if (state is GoogleLogInFailture) {
          showCustomSnackbar(context, e.toString());
        }
      },
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 50),
          shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          side:const BorderSide(color: Colors.black,width: 0)
        ),
        icon: Image.asset('assets/google_logo.png',
            height: 24, width: 24), // Add a Google logo
        label: const Text('Sign in with Google'),
        onPressed: () {
          // Trigger the Google sign-in event
          context.read<AuthenticationBloc>().add(GoogleSignInEvent());
        },
      ),
    );
  }
}
