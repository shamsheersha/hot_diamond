import 'package:flutter/material.dart';
import 'package:hot_diamond_users/screens/main_screens/home/home_screen.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class OrderType extends StatelessWidget {
  const OrderType({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: LayoutBuilder(
      builder: (context, constraints) {
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
                      offset: const Offset(0, -4),
                    ),
                  ],
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Welcome to Hot Diamond 👋',
                        style: TextStyle(fontSize: 23),
                      ),
                      const Text('Please select your order type to continue'),
                      const SizedBox(
                        height: 90,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=> const HomeScreen()));
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.black, // Icon and text color
                          padding: const EdgeInsets.symmetric(
                              vertical: 12), // Padding around the button
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(12), // Border radius
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Row(
                            mainAxisAlignment:
                                MainAxisAlignment.start, // Align to the left
                            children: [
                              Icon(MdiIcons.truckDelivery),
                              const SizedBox(width: 8), // Space between icon and text
                              const Text('Delivery'), // Text on the right
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10,),
                      ElevatedButton(
                        onPressed: () {
                           Navigator.of(context).push(MaterialPageRoute(builder: (context)=> const HomeScreen()));
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.black, // Icon and text color
                          padding: const EdgeInsets.symmetric(
                              vertical: 12), // Padding around the button
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(12), // Border radius
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Row(
                            mainAxisAlignment:
                                MainAxisAlignment.start, // Align to the left
                            children: [
                              Icon(MdiIcons.food),
                              const SizedBox(width: 8), // Space between icon and text
                              const Text('Pick Up'), // Text on the right
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    ));
  }
}
