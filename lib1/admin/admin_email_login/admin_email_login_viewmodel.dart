import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import '../../service_provider_details/service_provider_detail_page.dart';
import '../../services/services.dart';
import '../../utils/sp_helper.dart';
import '../../widget/snack_bar_widget.dart';
import '../admin_queue/admin_queue_page.dart';
import '../dashboard/dashboard_page.dart';
import '../widget/top_nav_bar_widget.dart';

class AdminEmailLoginViewModel extends ChangeNotifier {
  final TextEditingController emailAddressController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool showProgressbar = false;
  bool obscurePassword = true;

  final SharedPreferenceService _sharedPreferenceService = SharedPreferenceService();
  final ApiService _apiService = ApiService();

  int? serviceProviderId;


  void refreshUI() {
    notifyListeners();
  }

  Future<void> loginAdminPartner(BuildContext context) async {
    // showProgressbar = true;
    // refreshUI();
    // final String email = emailAddressController.text;
    // final String password = passwordController.text;
    //
    // try {
    //   final responseBody = await _apiService.loginPartner(email, password);
    //   showProgressbar = false;
    //   refreshUI();
    //
    //   serviceProviderId = responseBody['id'];
    //
    //   // Save originalId
    //   if (serviceProviderId != null) {
    //     await _sharedPreferenceService.saveOriginalId(serviceProviderId!);
    //   }
    //
    //   await _sharedPreferenceService.saveAdminCredentials(email, password,responseBody['onboarding_complete']);
    //
    //   CustomSnackBar.showSnackBar("Login successful!");
    //
    //
    //   if (responseBody['onboarding_complete'] == 1) {
    //     Get.to(() => DashBoardPage());
    //     emailAddressController.text = '';
    //     passwordController.text = '';
    //   } else if (responseBody['onboarding_complete'] == 0) {
    //     Get.to(() => StepperNavBar());
    //     emailAddressController.text = '';
    //     passwordController.text = '';
    //   }
    //
    // } catch (e) {
    //   showProgressbar = false;
    //   refreshUI();
    //   String errorMessage = e is Exception ? e.toString().replaceFirst('Exception: ', '') : e.toString();
    //   CustomSnackBar.showSnackBar("$errorMessage");
    //   print("Error: $e");
    // }
  }


  Future<int?> loadOriginalId() async {
    serviceProviderId = await _sharedPreferenceService.getOriginalId();
    notifyListeners(); // Notify listeners to refresh the UI if needed
    return serviceProviderId;
  }

  Future<void> tryAutoLogin() async {
    // final SharedPreferenceService _sharedPreferenceService = SharedPreferenceService();
    // String? email = await _sharedPreferenceService.getEmail();
    // final String? password = await _sharedPreferenceService.getPassword();
    // if(email == null || password == null) return ;
    // try {
    //   showProgressbar = true;
    //   refreshUI();
    //   final responseBody = await _apiService.loginPartner(email, password);
    //   showProgressbar = false;
    //   refreshUI();
    //   serviceProviderId = responseBody['id'];
    //   if (serviceProviderId != null) {
    //     await _sharedPreferenceService.saveOriginalId(serviceProviderId!);
    //   }
    //   await _sharedPreferenceService.saveAdminCredentials(email, password,responseBody['onboarding_complete']);
    //   CustomSnackBar.showSnackBar("Login successful!");
    //   if (responseBody['onboarding_complete'] == 1) {
    //     //Get.to(() => AdminQueuePage());
    //     Get.to(() => DashBoardPage());
    //   } else if (responseBody['onboarding_complete'] == 0) {
    //     Get.to(() => StepperNavBar());
    //   }
    // } catch (e) {
    //   showProgressbar = false;
    //   refreshUI();
    //   CustomSnackBar.showSnackBar("Error: $e");
    //   print("Error: $e");
    // }
  }

}

