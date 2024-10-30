import 'package:flutter/material.dart';

var redTextButtonStyle = TextButton.styleFrom(
  padding:const EdgeInsets.all(0),
  
  foregroundColor: Colors.red,
  backgroundColor: Colors.transparent,
  minimumSize:const Size(0,0),
);

var redTextButton = ButtonStyle(
  foregroundColor: WidgetStateProperty.all(const Color(0xFFFFFFFF)), // Pure white text for all states
  backgroundColor: WidgetStateProperty.all(Colors.red), // Red background
  padding: WidgetStateProperty.all(
    const EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
  ),
  shape: WidgetStateProperty.all(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(5),
    ),
  ),
);
