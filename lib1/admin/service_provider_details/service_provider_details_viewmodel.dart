// import 'package:flutter/cupertino.dart';
//
// import '../../models/panel.dart';
// import '../../models/service_provider_model.dart';
// import '../../services/services.dart';
//
// class ServiceProviderDetailsViewModel extends ChangeNotifier {
//
//   List<ServicesProvider> serviceProvider = [];
//   bool isLoading = false;
//
//
//   final ApiService apiService = ApiService();
//
//   Future<void> fetchSalonServiceProvidersById(int id) async {
//     isLoading = true;
//     notifyListeners();
//     try {
//       serviceProvider = await apiService.fetchSalonServiceProviderById(id);
//       print('service_provider: ${serviceProvider}');
//     } catch (e) {
//       print("Error fetching salon service providers: $e");
//     }
//     isLoading = false;
//     notifyListeners();
//   }
//
//   Future<void> fetchSalonServiceProvidersData(int serviceProviderId) async {
//     isLoading = true;
//     notifyListeners();
//     try {
//       serviceProvider = await apiService.fetchAdminSalonServiceProviders(serviceProviderId);
//     } catch (e) {
//       print("Error fetching salon service providers: $e");
//     }
//     isLoading = false;
//     notifyListeners();
//   }
//
//   void refreshUI() {
//     notifyListeners();
//   }
//
// }