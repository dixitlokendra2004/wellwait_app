import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:wellwait_app/services/services.dart';

class NotificationViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  List notifications = [];

  fetchData() async {
    notifications = await _apiService.getNotifications();
    notifyListeners();
  }

  refreshUI() {
    notifyListeners();
  }
}
