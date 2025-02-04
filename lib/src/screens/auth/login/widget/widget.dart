import 'package:flutter/material.dart';
import 'package:hot_diamond_users/src/screens/auth/forgot_password/forgot_password.dart';
import 'package:hot_diamond_users/src/screens/auth/sign_up/sign_up.dart';
import 'package:hot_diamond_users/utils/style/custom_button_styles.dart';
import 'package:hot_diamond_users/utils/style/custom_text_styles.dart';
import 'package:hot_diamond_users/widgets/custom_Button.dart';
import 'package:hot_diamond_users/src/screens/auth/widgets/google_button_widget.dart';
import 'package:hot_diamond_users/src/screens/auth/widgets/custom_textfield.dart';

// Login Form Widget
class LoginForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onLoginPressed;

  const LoginForm({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.onLoginPressed,
  });

  // Email TextField Widget
  Widget buildEmailTextField(TextEditingController emailController) {
    return CustomTextfield(
      controller: emailController,
      labelText: 'Email',
      hintText: 'Enter Email',
      keyboardType: TextInputType.emailAddress,
      autoFocus: false,
      isPassword: false,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Enter Email";
        } else if (!RegExp(
                r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
            .hasMatch(value)) {
          return "Enter a valid email";
        }
        return null;
      },
    );
  }

  // Password TextField Widget
  Widget buildPasswordTextField(TextEditingController passwordController) {
    return CustomTextfield(
      keyboardType: TextInputType.text,
      isPassword: true,
      autoFocus: false,
      controller: passwordController,
      hintText: 'Password',
      labelText: 'Password',
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Password is required';
        } else if (value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        return null;
      },
    );
  }

  // Forgot Password Button Widget
  Widget buildForgotPasswordButton(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) =>  ForgotPassword()));
        },
        style: CustomButtonStyles.transparentButtonStyle,
        child: const Text('Forgot Password?',style: CustomTextStyles.buttonText,),
      ),
    );
  }

  // Login Button Widget
  Widget buildLoginButton(VoidCallback onPressed) {
    return Row(
      children: [
        Expanded(
          child: CustomButton(text: 'Login', onPressed: onPressed),
        ),
      ],
    );
  }

  // Sign Up Button Widget
  Widget buildSignUpButton(BuildContext context) {
    return Row(
      children: [
        const Text("Don't have an account?",style: CustomTextStyles.bodyText2,),
        TextButton(
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) =>  SignUp()));
                emailController.clear();
                passwordController.clear();
          },
          style: CustomButtonStyles.transparentButtonStyle,
          child: const Text("Sign Up",style: CustomTextStyles.buttonText,),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
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
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text('Login', style:CustomTextStyles.headline1),
                  const SizedBox(height: 5),
                  const Text(
                    'Please sign in to your existing account',
                    style: CustomTextStyles.bodyText1,
                  ),
                  const SizedBox(height: 20),
                  buildEmailTextField(emailController),
                  const SizedBox(height: 10),
                  buildPasswordTextField(passwordController),
                  buildForgotPasswordButton(context),
                  buildLoginButton(onLoginPressed),
                  buildSignUpButton(context),
                  const GoogleLoginButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
