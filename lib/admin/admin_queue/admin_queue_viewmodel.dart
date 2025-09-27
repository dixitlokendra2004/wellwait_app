import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import '../../models/booking.dart';
import '../../services/services.dart';

class AdminQueueViewModel extends ChangeNotifier {
  List<Booking> bookings = [];
  bool isLoading = false;
  String? errorMessage;
  final ApiService apiService = ApiService();
  String formattedDate = DateFormat('d MMM yyyy').format(DateTime.now());

  Future<void> fetchData(int serviceProviderId) async {
    isLoading = true;
    notifyListeners();

    try {
      bookings = await apiService.fetchBookings(serviceProviderId);
      errorMessage = null; // Clear any previous error
    } catch (e) {
      errorMessage = e.toString(); // Handle the error
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Map<int, bool> bookingStartStatus = {};

  Future<void> updateBookingStarted(int bookingId) async {
    try {
      await apiService.startBooking(bookingId);

      // Update the status to reflect that the "Start" button was clicked
      bookingStartStatus[bookingId] = true;
      notifyListeners(); // Refresh UI after updating booking
    } catch (e) {
      errorMessage = e.toString(); // Handle any error during update
      notifyListeners(); // Notify listeners in case of error
    }
  }

  Map<int, bool> bookingFinishedStatus = {};

  Future<void> updateBookingFinished(int bookingId) async {
    try {
      await apiService.updateBookingFinished(bookingId);
      bookingFinishedStatus[bookingId] = true;
      notifyListeners(); // Refresh UI after updating booking
    } catch (e) {
      errorMessage = e.toString(); // Handle any error during update
      notifyListeners(); // Notify listeners in case of error
    }
  }

  refreshUI() {
    notifyListeners();
  }
}
