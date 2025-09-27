import 'package:flutter/material.dart';

import '../utils/colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color;
  final Color? textColor;
  final bool isBordered;
  final IconData? icon;
  final Widget? iconWidget;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color,
    this.textColor,
    this.isBordered = false,
    this.icon,
    this.iconWidget,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: isBordered
          ? ElevatedButton.icon(
              icon: iconWidget ??
                  Icon(
                    icon,
                    color: textColor ?? Colors.black,
                  ),
              label: Text(
                text,
                style: TextStyle(
                  color: textColor ?? Colors.black,
                  fontSize: 14,
                  
                  fontWeight: FontWeight.w400,
                ),
              ),
              style: ElevatedButton.styleFrom(
                foregroundColor: textColor ?? Colors.black,
                backgroundColor: color ?? Colors.transparent,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  side: isBordered
                      ? BorderSide(color: textColor ?? hintTextColor)
                      : BorderSide.none,
                ),
              ),
              onPressed: onPressed,
            )
          : ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: textColor ?? Colors.black,
                backgroundColor: color ?? Colors.transparent,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  side: isBordered
                      ? BorderSide(color: textColor ?? hintTextColor)
                      : BorderSide.none,
                ),
              ),
              onPressed: onPressed,
              child: Text(
                text,
                style: TextStyle(
                  color: textColor ?? Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  
                ),
              ),
            ),
    );
  }
}
