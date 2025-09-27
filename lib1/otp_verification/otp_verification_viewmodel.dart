import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../models/booking.dart';
import '../services/services.dart';
import '../utils/common_variables.dart';
import '../utils/sp_helper.dart';
import '../widget/bottom_bar_widget.dart';
import '../widget/snack_bar_widget.dart';

class OtpVerificationViewModel extends ChangeNotifier {
  TextEditingController otpController = TextEditingController();
  bool isLoading = false;
  final FirebaseAuth auth = FirebaseAuth.instance;

  void refreshUI() {
    notifyListeners();
  }
}
