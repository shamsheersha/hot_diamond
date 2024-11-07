import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hot_diamond_users/blocs/auth/auth_bloc/authentication_bloc.dart';
import 'package:hot_diamond_users/blocs/auth/auth_bloc/authentication_event.dart';
import 'package:hot_diamond_users/blocs/auth/auth_bloc/authentication_state.dart';
import 'package:hot_diamond_users/utils/fonts/fonts.dart';
import 'package:hot_diamond_users/screens/login_signup/login.dart';
import 'package:hot_diamond_users/utils/style/style.dart';
import 'package:hot_diamond_users/widgets/custom_textfield.dart';
import 'package:hot_diamond_users/widgets/phone_numberwidget.dart';
import 'package:hot_diamond_users/widgets/show_custom%20_snakbar.dart';

class SignUp extends StatelessWidget {
  SignUp({super.key});
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  final GlobalKey formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is SignUpSuccess) {
          Navigator.pop(context);
          showCustomSnackbar(context, 'Sign Up Successfull!');
        } else if(state is SignUpLoading){
          const Center(child: CircularProgressIndicator(),);
        }
        else if (state is SignUpFailture) {
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
                        offset: const Offset(0, -4)),
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
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Sign Up',
                            style:AppTextStyle.mainHeading ,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          const Text(
                            'Please sign up to get started',
                            style: TextStyle(fontSize: 16),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          CustomTextfield(
                            keyboardType: TextInputType.text,
                            isPassword: false,
                            autoFocus: false,
                            controller: _nameController,
                            hintText: 'Name',
                            labelText: 'Name',
                            validator: (value) => value == null || value.isEmpty ? 'Name is required' : null,
                          ),
                          const SizedBox(height: 10),
                          CustomTextfield(
                            keyboardType: TextInputType.emailAddress,
                            isPassword: false,
                            autoFocus: false,
                            controller: _emailController,
                            hintText: 'Email',
                            labelText: 'Email',
                            validator: (value) => value == null || !value.contains('@') ? 'Valid email required' : null,
                          ),
                          const SizedBox(height: 10),
                          CustomTextfield(
                            keyboardType: TextInputType.visiblePassword,
                            isPassword: true,
                            autoFocus: false,
                            controller: _passwordController,
                            hintText: 'Password',
                            labelText: 'Password',
                            validator: (value) => value != null && value.length < 6 ? 'Passwrd must more than 6 digits': null,
                          ),
                          const SizedBox(height: 10),
                          CustomTextfield(
                            keyboardType: TextInputType.visiblePassword,
                            isPassword: true,
                            autoFocus: false,
                            controller: _confirmPasswordController,
                            hintText: 'Confirm Password',
                            labelText: 'Confirm Password',
                            validator: (value){
                              if(value == null || value.trim().isEmpty){
                                return 'Confirm password is required';
                              }else if(value != _passwordController.text){
                                return 'Passwords do not match';
                              }return null;
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          PhoneNumberWidget(controller: _phoneNumberController),
                          const SizedBox(
                            height: 20,
                          ),
                          
                          Row(
                            children: [
                              Expanded(
                                child: TextButton(
                                  onPressed: () {
                                    context.read<AuthenticationBloc>().add(SignUpEvent(
                                        name: _nameController.text,
                                        email: _emailController.text,
                                        password: _passwordController.text,
                                        phoneNumber: _phoneNumberController.text,
                                        ));
                                  },
                                  style: redTextButton,
                                  child: const Text(
                                    'Login',
                                    style: AppTextStyle.submit,
                                  ),
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
    ));
  }
}
