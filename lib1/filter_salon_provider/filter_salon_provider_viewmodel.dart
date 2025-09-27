import 'package:flutter/cupertino.dart';

import '../models/service_provider_model.dart';
import '../services/services.dart';

class FilterSalonProviderViewModel extends ChangeNotifier {

  bool isLoading = false;
  final ApiService apiService = ApiService();
  List<ServicesProvider> filterServiceProvider = [];




  void refreshUI() {
    notifyListeners();
  }

  Future<void> fetchSalonServiceProvidersData() async {
    isLoading = true;
    notifyListeners();
    try {
      filterServiceProvider = await apiService.fetchSalonServiceProviders();
    } catch (e) {
      print("Error fetching salon service providers: $e");
    }
    isLoading = false;
    notifyListeners();
  }

}