import 'package:flutter/material.dart';
import 'package:hot_diamond_users/utils/style/custom_text_styles.dart';
import 'package:hot_diamond_users/widgets/custom_Button.dart';
import 'package:hot_diamond_users/src/screens/auth/widgets/custom_textfield.dart';
import 'package:hot_diamond_users/src/screens/auth/widgets/phone_numberwidget.dart';

class SignUpForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final TextEditingController phoneNumberController;
  final VoidCallback onSignUpPressed;

  const SignUpForm({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.phoneNumberController,
    required this.onSignUpPressed,
  });

  // Email regex pattern for validation
  final String emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';

  // Name TextField Widget
  Widget buildNameTextField() {
    return CustomTextfield(
      controller: nameController,
      labelText: 'Name',
      hintText: 'Enter Name',
      keyboardType: TextInputType.text,
      autoFocus: false,
      isPassword: false,
      validator: (value) => value == null || value.trim().isEmpty
          ? 'Name is required'
          : null,
    );
  }

  // Email TextField Widget
  Widget buildEmailTextField() {
    return CustomTextfield(
      controller: emailController,
      labelText: 'Email',
      hintText: 'Enter Email',
      keyboardType: TextInputType.emailAddress,
      autoFocus: false,
      isPassword: false,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Email is required';
        } else if (!RegExp(emailPattern).hasMatch(value)) {
          return 'Enter a valid email';
        }
        return null;
      },
    );
  }

  // Password TextField Widget
  Widget buildPasswordTextField() {
    return CustomTextfield(
      controller: passwordController,
      labelText: 'Password',
      hintText: 'Enter Password',
      keyboardType: TextInputType.visiblePassword,
      autoFocus: false,
      isPassword: true,
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

  // Confirm Password TextField Widget
  Widget buildConfirmPasswordTextField() {
    return CustomTextfield(
      controller: confirmPasswordController,
      labelText: 'Confirm Password',
      hintText: 'Confirm Password',
      keyboardType: TextInputType.visiblePassword,
      autoFocus: false,
      isPassword: true,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Confirm password is required';
        } else if (value != passwordController.text) {
          return 'Passwords do not match';
        }
        return null;
      },
    );
  }

  // Phone Number Widget
  Widget buildPhoneNumberField() {
    return PhoneNumberWidget(controller: phoneNumberController);
  }

  // Sign Up Button Widget
  Widget buildSignUpButton() {
    return Row(
      children: [
        Expanded(
          child: CustomButton(text: 'Sign Up', onPressed: onSignUpPressed),
          // child: TextButton(
          //   onPressed: onSignUpPressed,
          //   style: redTextButton,
          //   child: const Text('Sign Up', style: AppTextStyle.submit),
          // ),
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
            ),
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
                  const Text('Sign Up', style: CustomTextStyles.headline1),
                  const SizedBox(height: 5),
                  const Text(
                    'Please sign up to get started',
                    style: CustomTextStyles.bodyText1,
                  ),
                  const SizedBox(height: 20),
                  buildNameTextField(),
                  const SizedBox(height: 10),
                  buildEmailTextField(),
                  const SizedBox(height: 10),
                  buildPasswordTextField(),
                  const SizedBox(height: 10),
                  buildConfirmPasswordTextField(),
                  const SizedBox(height: 10),
                  buildPhoneNumberField(),
                  const SizedBox(height: 20),
                  buildSignUpButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
