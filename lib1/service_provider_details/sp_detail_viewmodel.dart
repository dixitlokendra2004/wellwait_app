import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/panel.dart';
import '../models/count.dart'; // Ensure the Count model is properly imported
import '../models/salon_timing.dart';
import '../services/services.dart';

class SPDetailViewModel extends ChangeNotifier {
  List<Map<String, String>> selectedServices = [];
  List<Panel> panels = [];
  int? openedPanelIndex;

  //int serviceIndex = 0;
  int panelsIndex = 0;
  int countIndex = 0;
  bool isExpanded = false;
  List<SalonTiming> salonTiming = [];

  final ApiService apiService = ApiService();

  void onServiceAdded(String title, String subtitle, String imagePath,
      int serviceId, int panelId) {
    selectedServices.add({
      'services': title,
      'prices': subtitle,
      'imagePath': imagePath,
      'id': serviceId.toString(),
      'panelId': panelId.toString()
    });
    notifyListeners();
  }

  void onServiceRemoved(serviceId, panelId) {
    selectedServices.removeWhere((service) =>
        service['id'] == serviceId.toString() &&
        service['panelId'] == panelId.toString());
    notifyListeners(); // Notify listeners to rebuild UI
  }

  Future<void> fetchPanels(int serviceProviderId) async {
    // try {
      panels = await apiService.fetchPanels(serviceProviderId);
      notifyListeners();
    // } catch (e) {
    //   print("Error fetching panels: $e");
    //   throw Exception('Failed to load panels');
    // }
  }

  Future<void> fetchBookingCount() async {
    try {
      for (var p in panels) {
        Count count = await apiService.getBookingCount(p.id!);
        p.queueCount = count.count;
      }
      notifyListeners();
    } catch (e) {
      print("Error fetching booking count: $e");
      throw Exception('Failed to fetch booking count');
    }
  }

  Future<void> fetchSalonTimings(String salonId) async {
    try {
      // Fetch the salon timings directly as List<SalonTiming>
      salonTiming = await apiService.fetchSalonTimings(salonId);
      print("salon timing: ${salonTiming}");
      notifyListeners();
    } catch (e) {
      print("Error fetching salon timings: $e");
      throw Exception('Failed to load salon timings');
    }
  }

  clearData() {
    selectedServices = [];
    panels = [];
    openedPanelIndex = null;
    panelsIndex = 0;
    countIndex = 0;
    isExpanded = false;
    salonTiming = [];
  }
}
