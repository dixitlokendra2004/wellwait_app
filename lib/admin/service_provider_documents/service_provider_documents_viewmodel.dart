// import 'package:flutter/cupertino.dart';
// import 'package:wellwait_app/admin/utils/admin_%20common_variable.dart';
//
// import '../../models/panel.dart';
// import '../../models/service_provider_model.dart';
// import '../../services/services.dart';
// import '../admin_email_login/admin_email_login_viewmodel.dart';
//
// class ServiceProviderDocumentsViewModel extends ChangeNotifier {
//
//   late AdminEmailLoginViewModel homePageViewModel;
//   List<ServicesProvider> serviceProvider = [];
//   bool isLoading = false;
//
//
//   final ApiService apiService = ApiService();
//
//   Future<void> fetchSalonServiceProvidersData() async {
//     isLoading = true;
//     notifyListeners();
//     try {
//       serviceProvider = await apiService.fetchAdminSalonServiceProviders(adminServiceProviderId);
//     } catch (e) {
//       print("Error fetching salon service providers: $e");
//     }
//     isLoading = false;
//     notifyListeners();
//   }
//
// }