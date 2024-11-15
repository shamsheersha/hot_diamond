// submit_button.dart
import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;
  final String text;

  const SubmitButton({
    super.key,
    required this.onPressed,
    required this.isLoading,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: isLoading ? null : onPressed,
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.red,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: isLoading
          ? const CircularProgressIndicator(color: Colors.white)
          : Text(text, style: const TextStyle(fontSize: 16)),
    );
  }
}
