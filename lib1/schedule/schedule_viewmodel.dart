import 'package:flutter/cupertino.dart';
import '../models/booking.dart';
import '../models/service_provider_model.dart';
import '../services/services.dart';
import '../utils/common_variables.dart';

class ScheduleViewModel extends ChangeNotifier {
  List<Booking> pastBookings = [];
  List<Booking> todayBooking = [];
  List<ServicesProvider> serviceProvider = [];
  bool isLoading = false;
  String? errorMessage;
  int selectedIndex = 0;
  final ApiService apiService = ApiService();

  Future<void> fetchData() async {
    isLoading = true;
    notifyListeners();
    try {
      List<Booking>  response = await apiService.bookingPending(userId!);
      final todayMidnight = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
      pastBookings = response.where((booking) {
        final bookingDate = DateTime.parse(booking.createdAt.toString());
        return bookingDate.isBefore(todayMidnight);
      }).toList();
      print("bookingbefore: ${pastBookings}");
      todayBooking = response.where((booking) {
        final bookingDate = DateTime.parse(booking.createdAt.toString());
        return bookingDate.isAfter(todayMidnight);
      }).toList();
      print("bookingtoday: ${todayBooking}");
      errorMessage = null;
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchSalonServiceProvidersById(int id) async {
    isLoading = true;
    notifyListeners();
    try {
      serviceProvider = await apiService.fetchSalonServiceProviderById(id);
      print('service_provider: ${serviceProvider}');
    } catch (e) {
      print("Error fetching salon service providers: $e");
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> cancelBooking(int bookingId) async {
    isLoading = true; // Start loading
    notifyListeners();

    try {
      await apiService.cancelBooking(bookingId); // Call API to cancel booking
      // Remove booking from the list
      todayBooking.removeWhere((booking) => booking.id == bookingId);
      errorMessage = null; // Clear any previous error
    } catch (e) {
      errorMessage = e.toString(); // Handle the error
    } finally {
      isLoading = false; // Stop loading
      notifyListeners(); // Refresh UI
    }
  }

  void refreshUI() {
    notifyListeners();
  }

}
