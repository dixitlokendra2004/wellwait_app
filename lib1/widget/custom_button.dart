import 'package:flutter/material.dart';

class CustomButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double buttonHeight;
  final double buttonWidth;
  final double borderRadius;
  final double buttonSize;
  final Color buttonColor;
  final Color borderColor;
  final double borderWidth;
  final Color textColor;
  final IconData? icon; // New parameter for the icon

  const CustomButtonWidget({
    Key? key,
    required this.text,
    required this.onPressed,
    this.buttonHeight = 50, // Default button height
    this.buttonWidth = 150, // Default button width
    this.borderRadius = 5, // Default circular radius
    this.buttonSize = 16, // Default button size
    this.buttonColor = Colors.blue, // Default button color
    this.borderColor = Colors.transparent, // Default border color (no border)
    this.borderWidth = 2.0, // Default border width
    this.textColor = Colors.white, // Default text color
    this.icon, // Icon is optional
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: buttonHeight,
      width: buttonWidth,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          padding: EdgeInsets.zero, // Removed padding to ensure content is centered
          textStyle: TextStyle(fontSize: buttonSize),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side: BorderSide(
              color: borderColor, // Use the passed border color
              width: borderWidth, // Use the passed border width
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                color: textColor, // Match the icon color with text color
              ),
              SizedBox(width: 8), // Space between icon and text
            ],
            Text(
              text,
              style: TextStyle(
                color: textColor, // Use the passed text color
                fontWeight: FontWeight.w700,
                fontSize: buttonSize, // Use buttonSize for text size
              ),
            ),
          ],
        ),
      ),
    );
  }
}
