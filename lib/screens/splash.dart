import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hot_diamond_users/blocs/splash/splash_bloc.dart';
import 'package:hot_diamond_users/screens/login_signup/login/login.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<SplashBloc, SplashState>(
        listener: (context, state) {
          if(state.isCompleted){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx)=>  Login()));
          }
        },
        child: Center(
          child: BlocBuilder<SplashBloc, SplashState>(
            builder: (context, state) {
              return AnimatedOpacity(opacity: state.opacity, duration: const Duration(seconds: 3),child: Image.asset('assets/840ccc14-b0e1-4ec2-8b65-3332ab05c32b_page-0003.png'),);
            },
          ),
        ),
      ),
    );
  }
}
