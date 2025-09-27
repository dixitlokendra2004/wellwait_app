import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class AdminOtpVerificationViewModel extends ChangeNotifier {
  TextEditingController otpVerificationController = TextEditingController();
  bool isLoading = false;
  final FirebaseAuth auth = FirebaseAuth.instance;
  StreamController<ErrorAnimationType>? errorController;
  String currentText = "";
  String enteredOtp = "";

  getCurrentText(value) {
    currentText = value;
  }




  void refreshUI() {
    notifyListeners();
  }

}