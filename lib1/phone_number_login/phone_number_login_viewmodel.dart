import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../Screens/registration/registration_screen.dart';
import '../models/booking.dart';
import '../services/services.dart';
import '../utils/common_variables.dart';
import '../utils/sp_helper.dart';
import '../widget/bottom_bar_widget.dart';
import '../widget/snack_bar_widget.dart';

class PhoneNumberLoginViewModel extends ChangeNotifier {
  bool otpSent = false;
  bool isLoading = false;
  bool showProgressBar = false;
  String? verificationId;
  final SharedPreferenceService _sharedPreferenceService =
      SharedPreferenceService();
  final ApiService _apiService = ApiService();
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> loginUser(String mobileNumber) async {
    isLoading = true;
    refreshUI();
    try {
      final responseBody = await _apiService.userLoginPhoneNumber(mobileNumber);
      print("response bodsssy: ${responseBody}");
      if (responseBody['error'] == null) {
        userEmail = responseBody['email'] ?? '';
        userName = responseBody['username'] ?? '';
        userPhoneNumber = responseBody['phone_number'] ?? '';
        userProfileImage = responseBody['photo'] ?? '';
        userGender = responseBody['gender'] ?? 0;
        location = responseBody['location'] ?? '';
        final birthdayString = responseBody['birthday'];
        if (birthdayString != null && birthdayString.isNotEmpty) {
          try {
            userBirthday = DateTime.parse(birthdayString);
          } catch (e) {
            userBirthday = null;
          }
        }

        await _sharedPreferenceService.saveUserId(responseBody['id'] ?? 0);
        await _sharedPreferenceService.saveUserLoginType(responseBody['is_phone_auth'] ?? 0);
        await _sharedPreferenceService.saveUsername(userName);
        await _sharedPreferenceService
            .saveUserPhoneNumber(userPhoneNumber ?? '');
        await _sharedPreferenceService.saveUserEmail(userEmail);
        await _sharedPreferenceService
            .saveUserBirthday(userBirthday?.toIso8601String() ?? '');
        await _sharedPreferenceService.saveUserGender(userGender);
        await _sharedPreferenceService.saveUserProfileImage(userProfileImage);
        await _sharedPreferenceService.saveUserLocation(location);

        isLoading = false;
        refreshUI();

        await _sharedPreferenceService.savePhoneCredentials(mobileNumber);
        CustomSnackBar.showSnackBar("Login successful!");
        Get.offAll(() => BottomBar());
        mobileNumber = '';
      } else {
        Get.off(
          () => RegistrationScreen(
            isGoogleAuth: false,
            phoneNumber: mobileNumber,
          ),
        );
      }
    } catch (e) {
      isLoading = false;
      refreshUI();
      String errorMessage = e is Exception
          ? e.toString().replaceFirst('Exception: ', '')
          : e.toString();
      CustomSnackBar.showSnackBar("$errorMessage");
      print("Error: $e");
    }
  }

  loginEmail(String email) async {
    isLoading = true;
    refreshUI();
    try {
      final responseBody = await _apiService.userLoginEmail(email);
      print("response body: ${responseBody}");
      // Check if email exists in the database
      if (responseBody['email'] == null || responseBody['email'].isEmpty) {
        isLoading = false;
        refreshUI();
        Get.to(() => RegistrationScreen(isGoogleAuth: true, email: email));
        return;
      }
      userEmail = responseBody['email'] ?? '';
      userName = responseBody['username'] ?? '';
      userPhoneNumber = responseBody['phone_number'] ?? '';
      userProfileImage = responseBody['photo'] ?? '';
      userGender = responseBody['gender'] ?? 0;
      location = responseBody['location'] ?? '';

      // Parse birthday if it exists and is valid
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

      // Save the user information
      await _sharedPreferenceService.saveUserId(responseBody['id'] ?? 0);
      await _sharedPreferenceService.saveUserLoginType(responseBody['is_phone_auth'] ?? 0);
      await _sharedPreferenceService.saveUsername(userName);
      await _sharedPreferenceService.saveUserPhoneNumber(userPhoneNumber ?? '');
      await _sharedPreferenceService.saveUserEmail(userEmail);
      await _sharedPreferenceService
          .saveUserBirthday(userBirthday?.toIso8601String() ?? '');
      await _sharedPreferenceService.saveUserGender(userGender);
      await _sharedPreferenceService.saveUserProfileImage(userProfileImage);
      await _sharedPreferenceService.saveUserLocation(location);

      isLoading = false;
      refreshUI();

      await _sharedPreferenceService.saveGmailCredentials(email);
      CustomSnackBar.showSnackBar("Login successful!");
      Get.offAll(() => BottomBar());
    } catch (e) {
      isLoading = false;
      refreshUI();
      String errorMessage = e is Exception
          ? e.toString().replaceFirst('Exception: ', '')
          : e.toString();
      CustomSnackBar.showSnackBar("$errorMessage");
      print("Error: $e");
    }
  }

  void refreshUI() {
    notifyListeners();
  }
}
