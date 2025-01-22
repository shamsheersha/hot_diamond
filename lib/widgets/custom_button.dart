import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color color;
  final TextStyle textStyle;
  final EdgeInsetsGeometry padding;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.color = Colors.red,
    this.textStyle = const TextStyle(
        color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
    this.padding = const EdgeInsets.symmetric(vertical: 15, horizontal: 24),
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: onPressed == null
                  ? Colors.grey
                  : color, // Disable button color
              padding: padding,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: onPressed,
            child: isLoading
                ? const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  )
                : Text(
                    text,
                    style: textStyle,
                  ),
          ),
        ),
      ],
    );
  }
}
