import 'dart:convert';
import 'dart:typed_data'; // For Uint8List
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:wellwait_app/admin/utils/admin_%20common_variable.dart';
import '../../services/services.dart';
import '../../utils/constants.dart'; // Ensure BASE_URL is defined here

class AdminSettingsViewModel extends ChangeNotifier {
  String adminImage = "";
  List<Uint8List> selectedAdminImages = [];
  final ApiService servicesAPI = ApiService();
  bool isLoading = false;



  void refreshUI() {
    notifyListeners();
  }
}
