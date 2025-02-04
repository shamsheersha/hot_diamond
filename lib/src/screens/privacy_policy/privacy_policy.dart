import 'package:flutter/material.dart';
import 'package:hot_diamond_users/widgets/custom_button.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Privacy Policy',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Hot Diamond is committed to protecting your privacy. This privacy policy outlines how we collect, use, and safeguard your information.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            _buildSectionTitle('1. Information We Collect'),
            const Text(
              'We collect personal information such as your name, email, phone number, and profile photo when you create an account. Additionally, we collect addresses you add to the address section and payment details for order processing.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 20),
            _buildSectionTitle('2. How We Use Your Information'),
            const Text(
              'Your information is used to manage your account, process orders, deliver notifications, and provide a personalized user experience. Location data is used to offer location-based features.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 20),
            _buildSectionTitle('3. Data Sharing'),
            const Text(
              'We do not share your personal information with third parties except for payment processing (Razorpay) and as required by law.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 20),
            _buildSectionTitle('4. Data Security'),
            const Text(
              'We use appropriate security measures to protect your data from unauthorized access, alteration, disclosure, or destruction.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 20),
            _buildSectionTitle('5. Account Management'),
            const Text(
              'You can update your profile details, including your name, email, phone number, and address. You may also request account deletion at any time.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 20),
            _buildSectionTitle('6. Cookies and Tracking Technologies'),
            const Text(
              'We may use cookies and similar technologies to improve app performance and user experience.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 20),
            _buildSectionTitle('7. Changes to This Privacy Policy'),
            const Text(
              'We may update this privacy policy from time to time. Any changes will be communicated through the app.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 30),
            Center(
              child: CustomButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                text: 'Agree and Continue',
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
