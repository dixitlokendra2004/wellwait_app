import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;

import '../../email_login/email_login_page.dart';
import '../../phone_number_login/phone_number_login_page.dart';
import '../../utils/constants.dart';
import '../../widget/bottom_bar_widget.dart';
import '../../widget/snack_bar_widget.dart';

class RegistrationViewModel extends ChangeNotifier {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailAddressController = TextEditingController();
  //final TextEditingController phoneNumberController = TextEditingController();
  bool showProgressbar = false;
  bool obscurePassword = true;
  String selectedCountryCode = '+91';

  Future<void> registerUser(
      bool isGoogleAuth, String? email, String? phoneNumber) async {
    showProgressbar = true;
    refreshUI();
    email = isGoogleAuth ? email : emailAddressController.text;
    String userName = nameController.text;
    try {
      final response = await http.post(
        Uri.parse('$BASE_URL/register'),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          'email': email,
          'phone_number': phoneNumber,
          'is_phone_auth': !isGoogleAuth,
          'username': userName,
        }),
      );
      showProgressbar = false;
      refreshUI();
      if (response.statusCode == 200) {
        CustomSnackBar.showSnackBar("User registered successfully!");
        //await getUsers(); // Call get users after successful registration
        Get.to(() => PhoneNumberLoginPage());
        nameController.text = "";
        emailAddressController.text = "";
      } else {
        CustomSnackBar.showSnackBar(
            "Failed to register user: ${response.body}");
      }
    } catch (e) {
      CustomSnackBar.showSnackBar("Error: $e");
      showProgressbar = false;
      refreshUI();
    }
  }

  void refreshUI() {
    notifyListeners();
  }
}
