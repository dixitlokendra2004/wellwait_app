import 'package:flutter/material.dart';

class AdminLoginViewModel extends ChangeNotifier {
  final TextEditingController mobileNumberController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool showProgressbar = false;




  void refreshUI() {
    notifyListeners();
  }

}
