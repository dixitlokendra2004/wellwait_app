import 'package:flutter/cupertino.dart';

import '../../models/panel.dart';
import '../../models/salon_timing.dart';
import '../../services/services.dart';

class ServiceProviderTimingViewModels extends ChangeNotifier {

  List<SalonTiming> salonTiming = [];
  bool isLoading = false;


  final ApiService apiService = ApiService();
  Future<void> fetchSalonTimings(String salonId) async {
    try {
      // Fetch the salon timings directly as List<SalonTiming>
      salonTiming = await apiService.getSalonTimings(salonId);
      print("salon timing: ${salonTiming}");
      notifyListeners();
    } catch (e) {
      print("Error fetching salon timings: $e");
      throw Exception('Failed to load salon timings');
    }
  }


  void refreshUI() {
    notifyListeners();
  }
}