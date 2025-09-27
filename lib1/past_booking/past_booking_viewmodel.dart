import 'package:flutter/cupertino.dart';

import '../models/booking.dart';
import '../services/services.dart';

class PastBookingVieModel extends ChangeNotifier {

  List<Booking> bookings = [];
  bool isLoading = false;
  String? errorMessage;
  final ApiService apiService = ApiService();

  Future<void> fetchData() async {
    isLoading = true;
    notifyListeners();

    try {
      bookings = await apiService.fetchPastBooking();
      errorMessage = null; // Clear any previous error
    } catch (e) {
      errorMessage = e.toString(); // Handle the error
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void refreshUI() {
    notifyListeners();
  }
}
