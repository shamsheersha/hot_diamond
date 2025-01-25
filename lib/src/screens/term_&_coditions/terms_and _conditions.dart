import 'package:flutter/material.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

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
            _buildSection(
              'User Account',
              [
                'Users must provide accurate information',
                'One account per user',
                'Account security is user\'s responsibility',
                'Prohibited from sharing account credentials',
              ],
            ),
            const SizedBox(height: 16),
            _buildSection(
              'Order Policy',
              [
                'Accurate order information required',
                'Delivery or pickup options available',
                'Prices subject to change without notice',
                'Cancellation and refund policy applies',
              ],
            ),
            const SizedBox(height: 16),
            _buildSection(
              'Payment Terms',
              [
                'Payments processed via Razorpay',
                'Secure online payment methods',
                'Full payment required before order confirmation',
                'No refunds for customized orders',
              ],
            ),
            const SizedBox(height: 16),
            _buildSection(
              'Location and Notifications',
              [
                'User location used for delivery purposes',
                'Notifications related to order status',
                'Option to enable/disable notifications',
                'Location services can be revoked by user',
              ],
            ),
            const SizedBox(height: 16),
            _buildSection(
              'User Conduct',
              [
                'Prohibited from misusing the platform',
                'No offensive or inappropriate content',
                'Compliance with local laws and regulations',
                'Account termination for violation of terms',
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'By using our service, you agree to these terms.',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Last Updated: January 2025',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<String> points) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ...points.map((point) => Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('• ', style: TextStyle(fontWeight: FontWeight.bold)),
              Expanded(child: Text(point)),
            ],
          ),
        )),
      ],
    );
  }
}