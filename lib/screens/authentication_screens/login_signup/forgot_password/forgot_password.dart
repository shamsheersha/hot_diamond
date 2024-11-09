import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hot_diamond_users/blocs/authentication/auth_bloc/authentication_bloc.dart';
import 'package:hot_diamond_users/blocs/authentication/auth_bloc/authentication_event.dart';
import 'package:hot_diamond_users/blocs/authentication/auth_bloc/authentication_state.dart';
import 'package:hot_diamond_users/utils/fonts/fonts.dart';
import 'package:hot_diamond_users/utils/style/style.dart';
import 'package:hot_diamond_users/widgets/custom_textfield.dart';
import 'package:hot_diamond_users/widgets/show_custom%20_snakbar.dart';

class ForgotPassword extends StatelessWidget {
  ForgotPassword({super.key});

  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // Regex pattern for basic email validation
  final String emailPattern =
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          if (state is ForgotPasswordSuccess) {
            showCustomSnackbar(context, 'Please check your Gmail');
          } else if (state is ForgotPasswordFailure) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error)));
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
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 8,
                        offset: const Offset(0, -4),
                      )
                    ],
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            const Text(
                              'Forgot Password',
                              style: AppTextStyle.mainHeading,
                            ),
                            const SizedBox(height: 10),
                            const Text(
                                'Please enter your email to reset password'),
                            const SizedBox(height: 20),
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Enter Email',
                                style: AppTextStyle.normalHeading,
                              ),
                            ),
                            const SizedBox(height: 5),
                            CustomTextfield(
                              controller: _emailController,
                              labelText: 'Email',
                              keyboardType: TextInputType.emailAddress,
                              isPassword: false,
                              autoFocus: false,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Enter Email";
                                } else if (!RegExp(emailPattern)
                                    .hasMatch(value)) {
                                  return "Enter a valid email address";
                                }
                                return null;
                              },
                              hintText: 'Email',
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  child: BlocBuilder<AuthenticationBloc,
                                      AuthenticationState>(
                                    builder: (context, state) {
                                      return TextButton(
                                        onPressed: state
                                                is ForgotPasswordLoading
                                            ? null
                                            : () {
                                                // Validate form fields
                                                if (_formKey.currentState!
                                                    .validate()) {
                                                  final email =
                                                      _emailController.text;
                                                  context
                                                      .read<
                                                          AuthenticationBloc>()
                                                      .add(ForgotPasswordEvent(
                                                          email: email));
                                                } else {
                                                  showCustomSnackbar(context,
                                                      'Please enter a valid Email');
                                                }
                                              },
                                        style: redTextButton,
                                        child: const Text(
                                          'Submit',
                                          style: AppTextStyle.submit,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
