import 'package:flutter/material.dart';

class OrderType extends StatelessWidget {
  const OrderType({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        return Column(
          children: [
            Image.asset(
              'assets/840ccc14-b0e1-4ec2-8b65-3332ab05c32b_page-0003.png',
              width: double.infinity,
              height: 500,
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
                      topRight: Radius.circular(30)),
                ),
                child: Padding(padding: 
                const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Text('Welcome to Hot Diamond')
                  ],
                ),),
              ),
            ),
          ],
        );
      }),
    );
  }
}
