import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../utils/colors.dart';

class CustomTextInput extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final Widget? prefixIcon;

  const CustomTextInput({
    super.key,
    required this.hintText,
    required this.controller,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: prefixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: const BorderSide(color: Colors.teal),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: const BorderSide(color: Colors.teal),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: const BorderSide(color: Colors.teal),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: const BorderSide(color: Colors.teal),
        ),
        filled: true,
        hintStyle: const TextStyle(color: hintTextColor),
        fillColor: const Color(0xFFE0F7F8),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      ),
    );
  }
}

class CustomPhoneInput extends StatelessWidget {
  final TextEditingController controller;

  const CustomPhoneInput({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return IntlPhoneField(
      controller: controller,

      decoration: InputDecoration(
        hintText: 'Enter your number',
        hintStyle: const TextStyle(color: hintTextColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: primaryColor),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: primaryColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: primaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: primaryColor),
        ),
        filled: true,
        fillColor: inputFillColor,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      ),
      initialCountryCode: 'PK', // Set the initial country code
      onChanged: (phone) {
        // Handle changes if needed
      },

      style: const TextStyle(color: Colors.black),
      // dropdownTextStyle: const TextStyle(color: Colors.black),
      // dropdownIcon: const Icon(Icons.arrow_drop_down, color: Colors.black),
    );
  }
}
