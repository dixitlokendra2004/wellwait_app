import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import '../services/services.dart';
import '../utils/common_variables.dart';
import '../utils/sp_helper.dart';
import '../widget/bottom_bar_widget.dart';
import '../widget/snack_bar_widget.dart';

class EmailLoginViewModel extends ChangeNotifier {
  final TextEditingController emailAddressController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool showProgressbar = false;
  bool obscurePassword = true;
  final SharedPreferenceService _sharedPreferenceService =
      SharedPreferenceService();
  final ApiService _apiService = ApiService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void refreshUI() {
    notifyListeners();
  }

  Future<void> loginUser(BuildContext context) async {
    showProgressbar = true;
    refreshUI();
    final String email = emailAddressController.text;
    final String password = passwordController.text;
    try {
      final responseBody = await _apiService.loginUser(email, password);
      userName = responseBody['userName'];
      userPhoneNumber = responseBody['phone_number'];
      userEmail = responseBody['email'];
      userProfileImage = responseBody['photo'];
      userGender = responseBody['gender'];

      final birthdayString = responseBody['birthday'];
      print("Login birthdayString : ${birthdayString}");
      if (birthdayString != null && birthdayString.isNotEmpty) {
        try {
          userBirthday = DateTime.parse(birthdayString);
          print('Login Birthday date : ${userBirthday}');
          print('birthdayString : ${birthdayString}');
        } catch (e) {
          print("Error parsing birthday: $e");
          userBirthday = null;
        }
      }

      // print('User ID: $userId');
      // print('User Name: $userName');
      // print('User Phone Number: $userPhoneNumber');
      // print('User Email: $userEmail');
      // print('User Birthday: $userBirthday');
      // print('User Gender: $userGender');
      // print('User photo: $userProfileImage');

      await _sharedPreferenceService.saveUserId(responseBody['userId']!);
      await _sharedPreferenceService.saveUsername(userName);
      await _sharedPreferenceService.saveUserPhoneNumber(userPhoneNumber ?? '');
      await _sharedPreferenceService.saveUserEmail(userEmail);
      await _sharedPreferenceService
          .saveUserBirthday(userBirthday?.toIso8601String() ?? '');
      await _sharedPreferenceService.saveUserGender(userGender);
      await _sharedPreferenceService.saveUserProfileImage(userProfileImage);

      showProgressbar = false;
      refreshUI();

      await _sharedPreferenceService.saveCredentials(email, password);
      CustomSnackBar.showSnackBar("Login successful!");
      login();
      //Get.to(() => BottomBar());
      emailAddressController.text = "";
      passwordController.text = "";
    } catch (e) {
      showProgressbar = false;
      refreshUI();
      String errorMessage = e is Exception
          ? e.toString().replaceFirst('Exception: ', '')
          : e.toString();
      CustomSnackBar.showSnackBar("$errorMessage");
      print("Error: $e");
    }
  }

  void login() async {
    //setState(() {_viewModel.showProgressbar = true;});
    try {
      await _auth.signInWithEmailAndPassword(
        email: emailAddressController.text.trim(),
        password: passwordController.text.trim(),
      );
      CustomSnackBar.showSnackBar("Login successful!");
      Get.to(() => BottomBar());
      // Navigate to the home screen or another page
    } on FirebaseAuthException catch (e) {
      String message = e.message ?? 'An error occurred';
      CustomSnackBar.showSnackBar(message);
    } finally {
      //setState(() {_viewModel.showProgressbar = false;});
    }
  }
}
