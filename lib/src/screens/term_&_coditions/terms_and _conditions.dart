import 'package:flutter/material.dart';
import 'package:hot_diamond_users/widgets/custom_button.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms and Conditions'),
        backgroundColor: Colors.grey[100],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome to Hot Diamond',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'By using the Hot Diamond app, you agree to the following terms and conditions. Please read them carefully.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            _buildSectionTitle('1. User Accounts'),
            const Text(
              'Users can create accounts using email, password, or Google login for account management. Users can add, edit, or delete their addresses in the address section and update profile details like name, email, phone number, and profile photo.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 20),
            _buildSectionTitle('2. Orders and Payments'),
            const Text(
              'Orders and payments are processed using Razorpay and Cash on Delivery (COD) options.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 20),
            _buildSectionTitle('3. Favorites, Cart, and Checkout'),
            const Text(
              'Users can manage their favorite items, add items to the cart, and proceed with the checkout process seamlessly.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 20),
            _buildSectionTitle('4. Account Deletion'),
            const Text(
              'Users can request account deletion if they no longer wish to use the app.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 20),
            _buildSectionTitle('5. Notifications'),
            const Text(
              'Users will receive notifications about updates, promotions, and order status.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 20),
            _buildSectionTitle('6. No Network Indication'),
            const Text(
              'The app will notify users when there is no network connection.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 20),
            _buildSectionTitle('7. Limitation of Liability'),
            const Text(
              'Hot Diamond is not responsible for any damages or losses incurred while using the app.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 20),
            _buildSectionTitle('8. Access to Google Current Location'),
            const Text(
              'The app may access your current location using Google services to enhance user experience and provide location-based features.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 30),
            Center(
              child: CustomButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                text:  'Agree and Continue',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}