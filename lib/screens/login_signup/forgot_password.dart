import 'package:flutter/material.dart';
import 'package:hot_diamond_users/fonts/fonts.dart';
import 'package:hot_diamond_users/screens/login_signup/verification.dart';
import 'package:hot_diamond_users/style/style.dart';
import 'package:hot_diamond_users/widgets/custom_textfield.dart';

class ForgotPassword extends StatelessWidget {
  ForgotPassword({super.key});
  final TextEditingController _emailController = TextEditingController();

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
                fit: BoxFit.cover),
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
                      topRight: Radius.circular(30)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SingleChildScrollView(
                    child: Form(
                        child: Column(
                      children: [
                        const Text(
                          'Forgot Password',
                          style: mainHeading,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text('Please sign in to your existing account'),
                        const SizedBox(
                          height: 20,
                        ),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Enter Email',
                            style: normalHeading,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        CustomTextfield(
                          controller: _emailController,
                          labelText: 'Email',
                          keyboardType: TextInputType.text,
                          isPassword: false,
                          autoFocus: false,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Enter Email";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: TextButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                 Verification()));
                                    },
                                    style: redTextButton,
                                    child: const Text(
                                      'SEND CODE',
                                      style: submit,
                                    )))
                          ],
                        )
                      ],
                    )),
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
