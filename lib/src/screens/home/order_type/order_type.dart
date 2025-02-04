import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hot_diamond_users/src/controllers/location/location_bloc.dart';
import 'package:hot_diamond_users/src/controllers/location/location_event.dart';
import 'package:hot_diamond_users/src/screens/home/home_screen/home_screen.dart';
import 'package:hot_diamond_users/src/screens/home/order_type/widget/order_type_button.dart';
import 'package:hot_diamond_users/src/services/notification_service/nortification_service.dart';
import 'package:hot_diamond_users/utils/style/custom_text_styles.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
// ... other imports remain the same

class OrderType extends StatefulWidget {
  const OrderType({super.key});

  @override
  State<OrderType> createState() => _OrderTypeState();
}

class _OrderTypeState extends State<OrderType> {
  @override
  void initState() {
    notificationHandler();
    super.initState();
  }

  void notificationHandler() {
    FirebaseMessaging.onMessage.listen((event) async {
      log(event.notification!.title.toString());
      NortificationService().showNotification(event);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Add maximum width constraint for web
          final maxWidth = MediaQuery.of(context).size.width;
          final isWeb = maxWidth > 600; // Threshold for web layout

          return SingleChildScrollView(  // Add scroll capability
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: isWeb ? 500 : 500,  // Adjust height for web
                    child: Image.asset(
                      'assets/840ccc14-b0e1-4ec2-8b65-3332ab05c32b_page-0003.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    constraints: BoxConstraints(
                      maxWidth: isWeb ? 800 : double.infinity,  // Limit width on web
                    ),
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
                      padding: EdgeInsets.symmetric(
                        horizontal: isWeb ? 40 : 20,
                        vertical: 20,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Welcome to Hot Diamond 👋',
                            style: CustomTextStyles.headline2,
                          ),
                          const Text(
                            'Please select your order type to continue',
                            style: CustomTextStyles.bodyText2,
                          ),
                          SizedBox(height: isWeb ? 60 : 90),
                          Center(  // Center the buttons on web
                            child: SizedBox(
                              width: isWeb ? 400 : double.infinity,  // Limit button width on web
                              child: Column(
                                children: [
                                  OrderTypeButton(
                                    label: 'Delivery',
                                    icon: MdiIcons.truckDelivery,
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => const HomeScreen(),
                                        ),
                                      );
                                      context.read<LocationBloc>().add(FetchLocationEvent());
                                    },
                                  ),
                                  const SizedBox(height: 10),
                                  OrderTypeButton(
                                    label: 'Pick Up',
                                    icon: MdiIcons.food,
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => const HomeScreen(),
                                        ),
                                      );
                                      context.read<LocationBloc>().add(FetchLocationEvent());
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}