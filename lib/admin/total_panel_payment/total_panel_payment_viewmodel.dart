import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:wellwait_app/admin/utils/admin_%20common_variable.dart';
import 'package:wellwait_app/models/revenue_analysis.dart';
import '../../services/services.dart';

class AnalysisViewModel extends ChangeNotifier {
  int selectedIndex = 1;
  bool isLoading = false;
  final ApiService apiService = ApiService();
  RevenueAnalysis? revenueAnalysisData;
  int totalEarnings = 0;

  final List<String> filters = ["Today", "1W", "1M", "6M", "1Y", "MAX"];

  void refreshUI() {
    notifyListeners();
  }

  Future<void> fetchRevenuesAnalysis() async {
    isLoading = true;
    notifyListeners();
    String selectedFilter = filters[selectedIndex];
    revenueAnalysisData = await apiService.getRevenuesAnalysis(adminServiceProviderId, selectedFilter);
    calculateTotalEarnings();
    isLoading = false;
    notifyListeners();
  }

  void updateSelectedIndex(int index) {
    selectedIndex = index;
    fetchRevenuesAnalysis(); // Fetch API when a segment is selected
  }

  void calculateTotalEarnings() {
    totalEarnings = revenueAnalysisData?.panels?.fold(0, (sum, panel) => sum! + panel.earning!.toInt()) ?? 0;
    notifyListeners();
  }
}
