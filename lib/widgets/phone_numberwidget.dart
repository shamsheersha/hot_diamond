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
  String? _phoneErrorMessage;

  //  phone number lengths for different countries
  Map<String, int> countryPhoneLengths = {
    'IN': 10, // India
    'US': 10, // USA
    'GB': 10, // UK
    'CA': 10, // Canada
    'DE': 11, // Germany
    'SA': 9, //Saudi Arabia
  };

  // Function to get the valid phone number length for the selected country
  int _getValidPhoneNumberLength(String countryCode) {
    return countryPhoneLengths[countryCode] ?? 10; // Default to 10 digits if not specified
  }

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
                  _phoneErrorMessage = null; // Clear error message when country changes
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
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 10),
            ],
          ),
        ),

        // Phone Number Input Field
        Expanded(
          child: TextFormField(
            controller: widget.controller,
            keyboardType: TextInputType.phone,
            autofocus: false,
            cursorColor: Colors.black,
            validator: (value) {
              if(value == null || value.isEmpty)return 'Phone number is required';
              if(value.length != _getValidPhoneNumberLength(_selectedCountry.countryCode)){
                return 'Phone number should be ${_getValidPhoneNumberLength(_selectedCountry.countryCode)}digits';
              }return null;
            },
            
            decoration: InputDecoration(
              labelText: 'Phone number',
              hintText: 'Phone number',
              border: OutlineInputBorder(),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 2.0),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 1.0),
              ),
              labelStyle: const TextStyle(color: Colors.black),
              errorText: _phoneErrorMessage, // Display error message here
            ),
          ),
        ),
      ],
    );
  }
}
