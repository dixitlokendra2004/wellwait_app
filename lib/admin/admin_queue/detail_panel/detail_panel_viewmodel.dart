import 'package:flutter/cupertino.dart';

import '../../../models/booking.dart';
import '../../../models/customer.dart';
import '../../../services/services.dart';
import '../../utils/admin_ common_variable.dart';

class DetailPanelViewModel extends ChangeNotifier {
  ApiService apiService = ApiService();
  List<Booking> panelBooking = [];
  bool isLoading = false;
  Map<int, bool> bookingStartStatus = {};
  String? errorMessage;
  List<Customer> customers = [];
  int panelId = 0;

  init(int? panelId) {
    this.panelId = panelId ?? 0;
    fetchBookings();
  }

  Future<void> fetchBookings() async {
    isLoading = true;
    notifyListeners();
    try {
      panelBooking = await apiService.getPanelBookings(panelId);
      notifyListeners();
    } catch (e) {
      print("Error fetching bookings: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> startedBooking(int bookingId) async {
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

  Future<void> endBookings(int bookingId) async {
    try {
      await apiService.endBooking(bookingId);
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

  Future<void> fetchCustomer() async {
    isLoading = true;
    notifyListeners();
    try {
      customers = await apiService.getCustomers(adminServiceProviderId);
    } catch (error) {
      print("Error fetching customers: $error");
    }
    isLoading = false;
    notifyListeners();
  }

  void refreshUI() {
    notifyListeners();
  }
}
