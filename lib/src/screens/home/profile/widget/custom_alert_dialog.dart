import 'package:flutter/material.dart';

// Custom Alert Dialog class
class CustomAlertDialog {
  static Future<void> showCustomDialog(BuildContext context, String title, String message) {
    return showDialog(
      context: context,
      barrierDismissible: false, // Set to false to prevent dismissing by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0), // Custom rounded corners
          ),
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}