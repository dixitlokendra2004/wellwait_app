import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:wellwait_app/admin/utils/admin_%20common_variable.dart';
import 'package:wellwait_app/models/admin_notification.dart';

import '../../models/booking.dart';
import '../../services/services.dart';


class AdminNotificationViewModel extends ChangeNotifier {

  bool isLoading = false;
  final ApiService apiService = ApiService();

  List<AdminNotification> notifications = [];

  fetchData() async {
    notifications = await apiService.adminGetNotification(adminServiceProviderId);
    notifyListeners();
  }

  void refreshUI() {
    notifyListeners();
  }
}