import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import '../models/booking.dart';
import '../models/count.dart';
import '../models/panel.dart';
import '../services/services.dart';

class QueueViewModel extends ChangeNotifier {
  int? selectedIndex;
  final ApiService apiService = ApiService();
  String formattedDate = DateFormat('d MMM yyyy').format(DateTime.now());

  List<Booking> bookings = [];
  bool isLoading = false;
  String? errorMessage;
  int selectIndex = 0;
  List<Panel> panels = [];

  Future<void> fetchData(int serviceProviderId) async {
    isLoading = true;
    notifyListeners();

    try {
      bookings = await apiService.fetchBookings(serviceProviderId);
      errorMessage = null;
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> cancelBooking(int bookingId) async {
    isLoading = true;
    notifyListeners();

    try {
      await apiService.cancelBooking(bookingId);
      bookings.removeWhere((booking) => booking.id == bookingId);
      errorMessage = null;
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void refreshUI() {
    notifyListeners();
  }

  // Fetch booking count and update UI
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

  Future<void> fetchPanels(int serviceProviderId) async {
    // try {
    panels = await apiService.fetchPanels(serviceProviderId);
    notifyListeners();
    // } catch (e) {
    //   print("Error fetching panels: $e");
    //   throw Exception('Failed to load panels');
    // }
  }

}
