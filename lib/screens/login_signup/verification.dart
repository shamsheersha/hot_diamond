import 'package:flutter/material.dart';
import 'package:hot_diamond_users/fonts/fonts.dart';
import 'package:hot_diamond_users/style/style.dart';
import 'package:hot_diamond_users/widgets/custom_textfield.dart';
import 'package:hot_diamond_users/widgets/otp_custom_textfield.dart';

class Verification extends StatelessWidget {
  const Verification({super.key});

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
                        offset: const Offset(0, -4))
                  ],
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30))),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                    child: Column(
                  children: [
                    const Text(
                      'Verification',
                      style: mainHeading,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text('We have sent a code to your email'),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('CODE'),
                        TextButton(
                            onPressed: () {},
                            style: redTextButtonStyle,
                            child: const Text(
                              'Resend OTP',
                              style: redColor,
                            ))
                      ],
                    ),
                    const CustomOTPField(),
                    const SizedBox(height: 20,),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () {},
                            style: redTextButton,
                            child: const Text(
                              'Done',
                              style: submit,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
              ),
            ))
          ],
        );
      }),
    );
  }
}
