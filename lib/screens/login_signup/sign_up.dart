import 'package:flutter/material.dart';
import 'package:hot_diamond_users/fonts/fonts.dart';
import 'package:hot_diamond_users/screens/login_signup/login.dart';
import 'package:hot_diamond_users/style/style.dart';
import 'package:hot_diamond_users/widgets/custom_textfield.dart';
import 'package:hot_diamond_users/widgets/phone_numberwidget.dart';

class SignUp extends StatelessWidget {
  SignUp({super.key});
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  final GlobalKey formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
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
                            'Sing Up',
                            style: mainHeading,
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
                          ),
                          const SizedBox(height: 10),
                          CustomTextfield(
                            keyboardType: TextInputType.emailAddress,
                            isPassword: false,
                            autoFocus: false,
                            controller: _emailController,
                            hintText: 'Email',
                            labelText: 'Email',
                          ),
                          const SizedBox(height: 10),
                          CustomTextfield(
                            keyboardType: TextInputType.emailAddress,
                            isPassword: true,
                            autoFocus: false,
                            controller: _passwordController,
                            hintText: 'Password',
                            labelText: 'Password',
                          ),
                          const SizedBox(height: 10),
                          CustomTextfield(
                            keyboardType: TextInputType.emailAddress,
                            isPassword: false,
                            autoFocus: false,
                            controller: _confirmPasswordController,
                            hintText: 'Confirm Password',
                            labelText: 'Confirm Password',
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          PhoneNumberWidget(controller: phoneNumberController),
                          const SizedBox(
                            height: 10,
                          ),
                          // Row(
                          //   children: [
                          //     Expanded(
                          //       child: CustomTextfield(
                          //         keyboardType: TextInputType.emailAddress,
                          //         isPassword: false,
                          //         autoFocus: false,
                          //         controller: _genderController,
                          //         hintText: 'Gender (Optional)',
                          //         labelText: 'Gender ',
                          //       ),
                          //     ),
                          //     SizedBox(width: 5,),
                          //     Expanded(
                          //       child: CustomTextfield(
                          //         keyboardType: TextInputType.emailAddress,
                          //         isPassword: false,
                          //         autoFocus: false,
                          //         controller: _dateOfBirthController,
                          //         hintText: 'Date of Birth (Optional)',
                          //         labelText: 'Date of Birth',
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          const SizedBox(height: 10,),
                          Row(
                            children: [
                              Expanded(
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Login()));
                                  },
                                  style: redTextButton,
                                  child: const Text(
                                    'Login',
                                    style: submit,
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
    );
  }
}
