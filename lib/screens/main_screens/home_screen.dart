import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hot_diamond_users/blocs/authentication/auth_bloc/authentication_bloc.dart';
import 'package:hot_diamond_users/blocs/authentication/auth_bloc/authentication_event.dart';
import 'package:hot_diamond_users/blocs/authentication/auth_bloc/authentication_state.dart';

import 'package:hot_diamond_users/screens/authentication_screens/login_signup/login/login.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      Center(child:  BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          if(state is LogOutLoading){
           const  Center(child: CircularProgressIndicator(),);
          }else if(state is LogOutSuccess){
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=> Login()), (route)=> false);
          }
        },
        child: ElevatedButton(onPressed: ()async{
          context.read<AuthenticationBloc>().add(SignOutEvent());
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=> Login()), (route)=> false);
        }, child: Text('Log Out')),
      ),)
    );
  }
}