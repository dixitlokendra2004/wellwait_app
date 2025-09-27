import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../filter_salon_provider/filter_salon_provider_page.dart';
import '../../models/service_provider_model.dart';
import '../../service_provider_details/service_provider_detail_page.dart';
import '../../services/services.dart';
import '../../utils/sp_helper.dart';

class FilterViewModel extends ChangeNotifier {

  List<ServicesProvider> filterSalonProvider = [];
  bool isLoading = false;
  final ApiService _apiService = ApiService();
  String? errorMessage;

  void refreshUI() {
    notifyListeners();
  }

  Future<void> fetchSalonProviders(
      String? category,
      String? rating,
      String? service,
      double? distance,
      String? priceRange,
      ) async {
    isLoading = true;
    notifyListeners();

    try {
      final data = await _apiService.fetchSalonProviders(
        category!,
        rating!,
        service!,
        distance!,
        priceRange!,
      );
      //filterSalonProvider = data;
      Get.to(() => FilterSalonProviderPage());
    } catch (error) {
      errorMessage = error.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}