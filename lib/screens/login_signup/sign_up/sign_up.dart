import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hot_diamond_users/blocs/authentication/auth_bloc/authentication_bloc.dart';
import 'package:hot_diamond_users/blocs/authentication/auth_bloc/authentication_event.dart';
import 'package:hot_diamond_users/blocs/authentication/auth_bloc/authentication_state.dart';
import 'package:hot_diamond_users/screens/login_signup/sign_up/widgets.dart';
import 'package:hot_diamond_users/widgets/show_custom%20_snakbar.dart';

class SignUp extends StatelessWidget {
  SignUp({super.key});
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Email regex pattern for validation
  final String emailPattern =
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          if (state is SignUpSuccess) {
            Navigator.pop(context);
            showCustomSnackbar(context, 'Sign Up Successful!');
          } else if (state is SignUpLoading) {
            showCustomSnackbar(context, 'Loading...');
          } else if (state is SignUpFailture) {
            showCustomSnackbar(context, state.error);
          }
        },
        child: LayoutBuilder(builder: (context, constraints) {
          return Column(
            children: [
              Image.asset(
                'assets/840ccc14-b0e1-4ec2-8b65-3332ab05c32b_page-0003.png',
                width: double.infinity,
                height: 280,
                fit: BoxFit.cover,
              ),
              SignUpForm(
                  formKey: _formKey,
                  nameController: _nameController,
                  emailController: _emailController,
                  passwordController: _passwordController,
                  confirmPasswordController: _confirmPasswordController,
                  phoneNumberController: _phoneNumberController,
                  onSignUpPressed: () {
                    if (_formKey.currentState!.validate()) {
                      context.read<AuthenticationBloc>().add(SignUpEvent(
                          name: _nameController.text.trim(),
                          email: _emailController.text.trim(),
                          password: _passwordController.text.trim(),
                          phoneNumber: _phoneNumberController.text.trim()));
                    }
                  })
            ],
          );
        }),
      ),
    );
  }
}
