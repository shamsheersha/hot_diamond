import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';

class PhoneNumberWidget extends StatefulWidget {
  final TextEditingController controller;

  const PhoneNumberWidget({super.key, required this.controller});

  @override
  State<PhoneNumberWidget> createState() => _PhoneNumberWidgetState();
}

class _PhoneNumberWidgetState extends State<PhoneNumberWidget> {
  Country _selectedCountry = Country.parse('IN'); // Default country India

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Country Flag and Code Picker
        GestureDetector(
          onTap: () {
            showCountryPicker(
              context: context,
              showPhoneCode: true,
              onSelect: (Country country) {
                setState(() {
                  _selectedCountry = country;
                });
              },
            );
          },
          child: Row(
            children: [
              Text(
                _selectedCountry.flagEmoji,
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(width: 8),
              Text(
                '+${_selectedCountry.phoneCode}',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 10),
            ],
          ),
        ),

        // Phone Number Input Field
        Expanded(
          child: TextField(
            controller: widget.controller,
            keyboardType: TextInputType.phone,
            autofocus: false,
            decoration: const InputDecoration(
              labelText: 'Phone number',
              hintText: ' phone number',
              border: OutlineInputBorder(),
              
              focusedBorder:  OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 2.0),
              ),
              enabledBorder:  OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 1.0),
              ),
              labelStyle:  TextStyle(color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }
}
