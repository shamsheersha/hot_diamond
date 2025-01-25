import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Data Collection and Usage'),
            _buildPolicyItem(
              'Authentication',
              'We collect and store your email address and password securely using Firebase Authentication. Your login credentials are encrypted and protected.',
            ),
            _buildPolicyItem(
              'User Profile Information',
              'We collect and store your phone number and profile images. Profile images are uploaded to Cloudinary and the URL is stored in Firebase for efficient management.',
            ),
            _buildPolicyItem(
              'Location Services',
              'We access your device location to provide personalized services such as delivery tracking and nearby restaurant recommendations. Your live location is retrieved on the home screen with your explicit consent.',
            ),
            _buildPolicyItem(
              'Order Information',
              'We collect order type preferences (delivery or pickup), address details, order history, and favorites to enhance your user experience.',
            ),
            _buildSectionTitle('Payment Processing'),
            _buildPolicyItem(
              'Online Payments',
              'We use Razorpay for secure online payment processing. Payment information is handled directly by Razorpay and we do not store your complete payment details.',
            ),
            _buildSectionTitle('Data Security'),
            _buildPolicyItem(
              'Data Protection',
              'We implement industry-standard security measures to protect your personal information. All data is encrypted during transmission and storage.',
            ),
            _buildPolicyItem(
              'Third-Party Services',
              'We use Firebase, Cloudinary, and Razorpay to provide enhanced services. These services have their own privacy policies which you can review on their respective websites.',
            ),
            _buildSectionTitle('User Consent and Control'),
            _buildPolicyItem(
              'Consent',
              'By using our app, you consent to the collection and use of your information as described in this privacy policy. You can withdraw consent or request data deletion at any time.',
            ),
            _buildPolicyItem(
              'Data Access and Deletion',
              'You have the right to access, modify, or delete your personal information. Please contact our support team to exercise these rights.',
            ),
            const SizedBox(height: 20),
            const Center(
              child: Text(
                'Last Updated: January 2024',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.blue[700],
        ),
      ),
    );
  }

  Widget _buildPolicyItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: const TextStyle(
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}