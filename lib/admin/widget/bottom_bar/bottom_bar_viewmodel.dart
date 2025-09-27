

import 'package:flutter/cupertino.dart';

import '../../../models/count.dart';
import '../../../models/panel.dart';
import '../../../models/service_provider_model.dart';
import '../../../models/salon_timing.dart';
import '../../../models/services.dart';
import '../../../services/services.dart';


class BottomBarViewModel extends ChangeNotifier {
  List<Panel> panels = [];
  bool isLoading = false;
  List<SalonTiming> salonTiming = [];
  List<ServiceModel> services = [];

  final ApiService apiService = ApiService();

  Future<void> fetchPanels(int serviceProviderId) async {
    try {
      panels = await apiService.fetchPanels(serviceProviderId);
      notifyListeners();
    } catch (e) {
      print("Error fetching panels: $e");
      throw Exception('Failed to load panels');
    }
  }

  void refreshUI() {
    notifyListeners();
  }

  Future<void> fetchBookingCount() async {
    try {
      for(var p in panels) {
        Count count = await apiService.getBookingCount(p.id!);
        p.queueCount = count.count;
      }
      print("count");
      notifyListeners();
    } catch (e) {
      print("Error fetching booking count: $e");
      throw Exception('Failed to fetch booking count');
    }
  }

  updateFcmToken() {
    apiService.updateFCMToken();
  }

  Future<void> fetchSalonTimings(String salonId) async {
    try {
      // Fetch the salon timings directly as List<SalonTiming>
      salonTiming = await apiService.fetchSalonTimings(salonId);
      notifyListeners();
    } catch (e) {
      print("Error fetching salon timings: $e");
      throw Exception('Failed to load salon timings');
    }
  }

  Future<void> fetchServiceData() async {
    isLoading = true;
    notifyListeners();
    try {
      services = await apiService.services(); // Fetch services
    } catch (e) {
      print("Error fetching services: $e");
    }
    isLoading = false;
    notifyListeners();
  }

}