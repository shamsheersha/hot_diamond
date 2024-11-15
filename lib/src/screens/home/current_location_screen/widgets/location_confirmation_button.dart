import 'package:flutter/material.dart';
import 'package:hot_diamond_users/widgets/custom_Button.dart';
import 'package:hot_diamond_users/widgets/show_custom%20_snakbar.dart';

class LocationConfirmationButton extends StatelessWidget {
  final String selectedCity;
  final String selectedArea;
  final Function onConfirm;

  const LocationConfirmationButton({
    required this.selectedCity,
    required this.selectedArea,
    required this.onConfirm,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      onPressed: () async {
        if (selectedCity.isNotEmpty && selectedArea.isNotEmpty) {
          onConfirm();
        } else {
         showCustomSnackbar(context, 'Please select city and area');
        }
      },
      text: 'Confirm Location',
    );
  }
}
