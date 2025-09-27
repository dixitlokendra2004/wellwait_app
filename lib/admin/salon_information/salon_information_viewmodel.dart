import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import '../../models/salon_timing.dart';
import '../../services/services.dart';
import '../../widget/snack_bar_widget.dart';

class SalonInformationViewModel extends ChangeNotifier {
  bool showProgressbar = false;
  final List<String> days = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday",
  ];
  List<bool> checkboxStates = List.generate(7, (index) => false);
  bool firstAdditionalCheckboxSelected = false;
  bool secondAdditionalCheckboxSelected = false;
  TimeOfDay? openingTime;
  TimeOfDay? closingTime;
  TimeOfDay? lunchStartTime;
  TimeOfDay? lunchEndTime;
  bool isAllSelected = false;
  final ApiService services = ApiService();
  List<SalonTiming>? serviceProviderTimings;



  // Function to toggle the selection of all checkboxes
  void toggleSelectAll() {
    isAllSelected = !isAllSelected;
    for (int i = 0; i < checkboxStates.length; i++) {
      checkboxStates[i] = isAllSelected;
    }
    notifyListeners(); // Notify listeners to rebuild UI
  }

  void refreshUI() {
    notifyListeners();
  }


  Future<void> fetchSalonTimings(String salonId) async {
    try {
      serviceProviderTimings = await services.getServiceProviderTimings(salonId);

      if (serviceProviderTimings != null && serviceProviderTimings!.isNotEmpty) {
        print("Salon timings fetched: $serviceProviderTimings");
      } else {
        print("No salon timings available.");
      }

      notifyListeners();
    } catch (e) {
      print("Error fetching salon timings: $e");
      throw Exception('Failed to load salon timings');
    }
  }


  Future<Map<String, dynamic>> updateTiming(
      int salonId,
      List<String> days,
      TimeOfDay startTime,
      TimeOfDay endTime,
      TimeOfDay? lunchStart,
      TimeOfDay? lunchEnd,
      ) async {
    showProgressbar = true;
    notifyListeners();
    final startTimeString = '${startTime.hour}:${startTime.minute}';
    final endTimeString = '${endTime.hour}:${endTime.minute}';
    final lunchStartString = lunchStart != null ? '${lunchStart.hour}:${lunchStart.minute}' : null;
    final lunchEndString = lunchEnd != null ? '${lunchEnd.hour}:${lunchEnd.minute}' : null;
    final response = await services.updateSalonTiming(
      salonId: salonId,
      days: days,
      startTime: startTimeString,
      endTime: endTimeString,
      lunchStart: lunchStartString,
      lunchEnd: lunchEndString,
    );
    showProgressbar = false;
    notifyListeners();
    return response;
  }



}
