import 'dart:io';

import 'package:flutter/cupertino.dart';

class SettingsViewModel extends ChangeNotifier {

  // Variables to manage notification states
  bool bookingActivityNotification = false;
  bool messageNotification = false;
  bool emailNotification = true;

  refreshUI() {
    notifyListeners();
  }

}
