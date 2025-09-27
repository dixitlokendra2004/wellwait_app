import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:wellwait_app/admin/admin_phone_number_login/admin_phone_number_page.dart';

import '../../utils/constants.dart';
import '../../widget/snack_bar_widget.dart';
import '../admin_email_login/admin_email_login_page.dart';


class AdminRegisterViewModel extends ChangeNotifier {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailAddressController = TextEditingController();
  final formKey1 = GlobalKey<FormState>();
  bool showProgressbar = false;
  bool obscurePassword = true;

  Future<void> registerAdminPartner(bool isGoogleAuth, String? email, String? phoneNumber) async {
    if (!formKey1.currentState!.validate()) return;
    showProgressbar = true;
    refreshUI();
    email = isGoogleAuth ? email : emailAddressController.text;
    String userName = nameController.text;
    try {
      final response = await http.post(Uri.parse('$BASE_URL/register_partner'),
        headers: {"Content-Type": "application/json",},
        body: jsonEncode({
          'email': email,
          'mobile_number': phoneNumber,
          'is_phone_auth': !isGoogleAuth,
          'name': userName,
        }),
      );
      showProgressbar = false;
      refreshUI();
      if (response.statusCode == 200) {
        // Successful registration
        CustomSnackBar.showSnackBar("User registered successfully!");
        // await getUsers();
        Get.to(() => const AdminPhoneNumberPage());
        emailAddressController.text = "";
        nameController.text = '';
      } else {
        CustomSnackBar.showSnackBar("Failed to register user: ${response.body}");
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
