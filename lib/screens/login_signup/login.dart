import 'package:flutter/material.dart';
import 'package:hot_diamond_users/fonts/fonts.dart';
import 'package:hot_diamond_users/screens/login_signup/forgot_password.dart';
import 'package:hot_diamond_users/screens/login_signup/sign_up.dart';
import 'package:hot_diamond_users/style/style.dart';
import 'package:hot_diamond_users/widgets/custom_textfield.dart';

class Login extends StatelessWidget {
  Login({super.key});
  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
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
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'Login',
                              style: mainHeading,
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Please sign in to your existing account',
                              style: TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 20),
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
                              controller: emailController,
                              labelText: 'Email',
                              keyboardType: TextInputType.emailAddress,
                              isPassword: false,
                              autoFocus: false,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Enter Email";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 10),
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Enter Password',
                                style: normalHeading,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            CustomTextfield(
                              controller: passwordController,
                              labelText: 'Password',
                              keyboardType: TextInputType.number,
                              isPassword: true,
                              autoFocus: false,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Enter Password";
                                }
                                return null;
                              },
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ForgotPassword()));
                                },
                                style: redTextButtonStyle,
                                child: const Text('Forgot Password?'),
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: TextButton(
                                    onPressed: () {},
                                    style: redTextButton,
                                    child:const Text('Login',style: submit,),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Text("Don't have an account?"),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> SignUp()));
                                  },
                                  style: redTextButtonStyle,
                                  child: const Text(
                                    "Sign Up",
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
