import 'package:flutter/cupertino.dart';
import 'package:wellwait_app/models/service_provider_model.dart';
import 'package:wellwait_app/services/services.dart';

class ServiceDetailViewModel extends ChangeNotifier {
  List<ServicesProvider> salonByService = [];
  final ApiService apiService = ApiService();

  bool isLoading = true;

  fetchSalonByServices(String serviceName) async {
    try {
      salonByService = await apiService.getSalonByService(serviceName);
      print("salonByService ${salonByService}");
    } catch (e) {
      print("Error fetching services: $e");
    }
    isLoading = false;
    notifyListeners();
  }

  clearData() {
    salonByService = [];
    isLoading = true;
    notifyListeners();
  }

  refreshUI() {
    notifyListeners();
  }
}
