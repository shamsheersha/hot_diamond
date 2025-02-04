import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hot_diamond_users/src/screens/auth/login/widget/widget.dart';
import 'package:hot_diamond_users/src/controllers/auth/authentication_bloc.dart';
import 'package:hot_diamond_users/src/controllers/auth/authentication_event.dart';
import 'package:hot_diamond_users/src/controllers/auth/authentication_state.dart';
import 'package:hot_diamond_users/src/screens/home/order_type/order_type.dart';
import 'package:hot_diamond_users/widgets/show_custom%20_snakbar.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _onLoginPressed() {
    if (formKey.currentState!.validate()) {
      context.read<AuthenticationBloc>().add(
            SignInEvent(
              email: emailController.text.trim(),
              password: passwordController.text.trim(),
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            showCustomSnackbar(context, 'Login Success');
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const OrderType()));
          } else if (state is LoginLoading) {
            showCustomSnackbar(context, 'Loading...');
          } else if (state is LoginFailure) {
            showCustomSnackbar(context, state.error,
                isError: true);
          }
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                Image.asset(
                  'assets/840ccc14-b0e1-4ec2-8b65-3332ab05c32b_page-0003.png',
                  width: double.infinity,
                  height: 280,
                  fit: BoxFit.cover,
                ),
                LoginForm(
                    formKey: formKey,
                    emailController: emailController,
                    passwordController: passwordController,
                    onLoginPressed: _onLoginPressed)
              ],
            );
          },
        ),
      ),
    );
  }
}
