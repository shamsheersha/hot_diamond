// import 'package:flutter/material.dart';
// import 'package:hot_diamond_users/utils/colorsssss.dart';

// class GoogleButtonWidget extends StatelessWidget {
//   final bool isLoading;
//   const GoogleButtonWidget({super.key, this.isLoading = false});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: MediaQuery.sizeOf(context).width * 0.93,
//       height: MediaQuery.sizeOf(context).height * 0.065,
//       decoration: BoxDecoration(
//           border: Border.all(width: 1, color: Colors.black),
//           borderRadius: BorderRadius.circular(5),
//           color: AppColors.lightScaffoldColor),
//       child: isLoading
//           ? Center(
//               child: SizedBox(
//                   height: 20,
//                   width: 20,
//                   child: CircularProgressIndicator(
//                     color: AppColors.darkScaffoldColor,
//                   )))
//           : Row(
//               children: [
//                 SizedBox(width: 50),
//                 Image.asset('assets/google_logo.png', width: 32),
//                 SizedBox(width: 37),
//                 Text(
//                   'Login with Google',
//                   style: TextStyle(color: Colors.black),
//                 ),
//               ],
//             ),
//     );
//   }
// }
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hot_diamond_users/blocs/auth/auth_bloc/authentication_bloc.dart';
import 'package:hot_diamond_users/blocs/auth/auth_bloc/authentication_event.dart';
import 'package:hot_diamond_users/blocs/auth/auth_bloc/authentication_state.dart';
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
