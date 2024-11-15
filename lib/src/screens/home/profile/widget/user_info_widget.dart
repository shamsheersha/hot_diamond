import 'package:flutter/material.dart';

class UserData extends StatelessWidget {
  final String name;
  final String phoneNumber;

  const UserData({
    super.key,
    required this.name,
    required this.phoneNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: const TextStyle(
            color: Colors.black,
            decoration: TextDecoration.none,
            fontSize: 20,
          ),
        ),
        Text(
          phoneNumber,
          style: const TextStyle(
            color: Colors.black,
            decoration: TextDecoration.none,
            fontSize: 15,
          ),
        ),
      ],
    );
  }
}
