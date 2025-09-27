import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import '../../models/booking.dart';
import '../../services/services.dart';


class TransactionsViewModel extends ChangeNotifier {

  int selectedIndex = 0;
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;
  String selectedStatus = "";
  bool isLoading = false;
  List<Booking> paymentBooking = [];
  final ApiService apiService = ApiService();


  Future<void> fetchTransactions(int serviceProviderId) async {
    isLoading = true;
    notifyListeners();
    String formattedStartDate = selectedStartDate != null ? DateFormat('yyyy-MM-dd').format(selectedStartDate!) : "";
    String formattedEndDate = selectedEndDate != null ? DateFormat('yyyy-MM-dd').format(selectedEndDate!) : "";
    try {
      paymentBooking = await apiService.getSalonTransactions(
        serviceProviderId: serviceProviderId,
        startDate: formattedStartDate,
        endDate: formattedEndDate,
      );
    } catch (e) {
      print("Error: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  void refreshUI() {
    notifyListeners();
  }
}