import 'package:flutter/material.dart';
import 'package:hot_diamond_users/src/screens/auth/widgets/custom_textfield.dart';
import 'package:hot_diamond_users/src/screens/auth/widgets/phone_numberwidget.dart';

class UserDetailsForm extends StatelessWidget {
  final String name;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;

  const UserDetailsForm({
    required this.name,
    required this.nameController,
    required this.emailController,
    required this.phoneController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Text(
            'Hello $name',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 30),
          _buildInputField(
            icon: Icons.person_outline,
            child: CustomTextfield(
              isPassword: false,
              hintText: 'Name',
              controller: nameController,
              labelText: 'Name',
            ),
          ),
          const SizedBox(height: 20),
          _buildInputField(
            icon: Icons.email_outlined,
            child: CustomTextfield(
              controller: emailController,
              hintText: 'Email',
              labelText: 'Email',
              isPassword: false,
            ),
          ),
          const SizedBox(height: 20),
          _buildInputField(
            icon: Icons.phone_outlined,
            child: PhoneNumberWidget(controller: phoneController),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required Widget child,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Icon(icon, color: Colors.grey),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}