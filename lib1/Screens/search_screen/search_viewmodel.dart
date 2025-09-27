import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:wellwait_app/models/categories.dart';

import '../../models/service_provider_model.dart';
import '../../services/services.dart';

class SearchViewModel extends ChangeNotifier {
  final TextEditingController searchController = TextEditingController();
  List<ServicesProvider> salonResults = [];
  List<ServicesProvider> filteredSalons = [];
  bool isLoading = false;
  String errorMessage = '';
  final ApiService apiService = ApiService();
  Map<String, int> searchCounts = {};
  List<String> mostPopularSearches = [];

  // List of salons that are searched twice
  List<String> favoriteSalons = [];
  List<Subcategories> searchCount = [];

  refreshUI() {
    notifyListeners();
  }

  Future<void> fetchSalonServiceProvidersData() async {
    isLoading = true;
    notifyListeners();
    try {
      salonResults = await apiService.fetchSalonServiceProviders();
      filteredSalons = salonResults;
    } catch (e) {
      print("Error fetching salon service providers: $e");
    }
    isLoading = false;
    notifyListeners();
  }

  searchSalon(String query) {

    if (query.isEmpty) {
      filteredSalons =
          List.from(salonResults); // Reset list when text is cleared
    } else {
      filteredSalons = salonResults.where((salon) {
        return (salon.salonName?.toLowerCase().contains(query.toLowerCase()) ??
                false) ||
            (salon.services.any((service) =>
                    service.name?.toLowerCase().contains(query.toLowerCase()) ??
                    false) ??
                false);
      }).toList();
    }
    notifyListeners();
  }

  Future<void> fetchIncreaseSearchCount(String categoryName) async {
    isLoading = true;
    notifyListeners();
    try {
      var response = await apiService.increaseSearchCount(categoryName);
      var updatedSearchCount = await apiService.subcategories();
      searchCount = updatedSearchCount;
      print("Updated search counts: ${searchCount}");
    } catch (e) {
      print("Error fetching salon service providers: $e");
    }
    isLoading = false;
    notifyListeners();
  }

  fetchSearchCount() async {
    isLoading = true;
    notifyListeners();
    try {
      searchCount = await apiService.subcategories();
      sortSearchCountDescending();
    } catch (e) {
      print("Error fetching salon service providers: $e");
    }
    isLoading = false;
    notifyListeners();
  }

  sortSearchCountDescending() {
    searchCount.sort((a, b) => b.searchCount!.compareTo(a.searchCount!
        .toInt())); // Assuming `searchCount` is a field in `Subcategories`
    notifyListeners();
  }
}
