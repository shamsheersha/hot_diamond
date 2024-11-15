
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:hot_diamond_users/src/controllers/auth/authentication_bloc.dart';
import 'package:hot_diamond_users/src/controllers/auth/authentication_event.dart';
import 'package:hot_diamond_users/src/controllers/auth/authentication_state.dart';
import 'package:hot_diamond_users/src/screens/home/order_type/order_type.dart';
import 'package:hot_diamond_users/utils/style/custom_text_styles.dart';
import 'package:hot_diamond_users/widgets/show_custom%20_snakbar.dart';

class GoogleLoginButton extends StatelessWidget {
  const GoogleLoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is GoogleLogInSuccess) {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => const OrderType
              ()));
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
        label: const Text('Sign in with Google',style: CustomTextStyles.bodyText1,),
        onPressed: () {
          // Trigger the Google sign-in event
          context.read<AuthenticationBloc>().add(GoogleSignInEvent());
        },
      ),
    );
  }
}
