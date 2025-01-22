import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hot_diamond_users/src/controllers/location/location_event.dart';
import 'package:hot_diamond_users/src/screens/home/current_location_screen/current_location_screen.dart';
import 'package:hot_diamond_users/src/screens/home/order_type/widget/order_type_button.dart';
import 'package:hot_diamond_users/src/services/user_repository.dart';
import 'package:hot_diamond_users/utils/style/custom_text_styles.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../controllers/location/location_bloc.dart';

class OrderType extends StatelessWidget {
  const OrderType({super.key});

  @override
  Widget build(BuildContext context) {
    final UserRepository userRepository = UserRepository();
    return Scaffold(
      body: LayoutBuilder(
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
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Welcome to Hot Diamond 👋',
                          style: CustomTextStyles.headline2,
                        ),
                        const Text(
                          'Please select your order type to continue',
                          style: CustomTextStyles.bodyText2,
                        ),
                        const SizedBox(height: 90),
                        OrderTypeButton(
                          label: 'Delivery',
                          icon: MdiIcons.truckDelivery,
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => CurrentLocationScreen(userRepository: userRepository,),
                              ),
                            );
                            context
                                .read<LocationBloc>()
                                .add(FetchLocationEvent());
                          },
                        ),
                        const SizedBox(height: 10),
                        OrderTypeButton(
                          label: 'Pick Up',
                          icon: MdiIcons.food,
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => CurrentLocationScreen(userRepository: UserRepository(),),
                              ),
                            );
                            context
                                .read<LocationBloc>()
                                .add(FetchLocationEvent());
                          },
                        ),
                      ],
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
