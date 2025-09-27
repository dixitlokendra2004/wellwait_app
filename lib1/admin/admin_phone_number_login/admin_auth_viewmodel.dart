import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:wellwait_app/admin/utils/admin_ common_variable.dart';
import 'package:wellwait_app/models/service_provider_model.dart';
import '../../services/services.dart';
import '../../utils/sp_helper.dart';
import '../../widget/snack_bar_widget.dart';
import '../admin_register/admin_register_page.dart';
import '../dashboard/dashboard_page.dart';
import '../widget/bottom_bar/bottom_bar.dart';
import '../widget/top_nav_bar_widget.dart';
import 'admin_phone_number_page.dart';

class AdminAuthViewModel extends ChangeNotifier {
  final TextEditingController phoneNumberController = TextEditingController();
  bool isLoading = false;
  final SharedPreferenceService _sharedPreferenceService =
      SharedPreferenceService();
  final ApiService _apiService = ApiService();
  bool isGoogleLoginInProgress = false;
  ServicesProvider serviceProvider = ServicesProvider();

  void refreshUI() {
    notifyListeners();
  }

  Future<void> fetchSalonServiceProvidersData(int serviceProviderId) async {
    notifyListeners();
    serviceProvider =
        await _apiService.fetchAdminSalonServiceProviders(serviceProviderId);
    notifyListeners();
  }

  Future<void> loginAdminPartner(String mobileNumber) async {
    isLoading = true;
    refreshUI();
    try {
      final responseBody = await _apiService.loginPartner(mobileNumber);
      isLoading = false;
      refreshUI();

      if (responseBody['status'] == 1) {
        await _sharedPreferenceService.saveOriginalId(responseBody['id']);
        await _sharedPreferenceService.saveAdminPhoneCredentials(
            mobileNumber, responseBody['onboarding_complete'] ?? 0);
        if (responseBody['onboarding_complete'] == 1) {
          CustomSnackBar.showSnackBar("Login successful!");
          Get.to(() => const CustomBottomBar());
          phoneNumberController.text = '';
        } else if (responseBody['onboarding_complete'] == 0) {
          Get.to(() => StepperNavBar(isGoogleAuth: false));
          phoneNumberController.text = '';
        }
      } else {
        final response = await _apiService.initiatePartnerRegistration(
            phoneNumber: mobileNumber, isPhoneAuth: true);
        await _sharedPreferenceService.saveOriginalId(response['id']);
        Get.to(() => StepperNavBar(isGoogleAuth: false));
      }
    } catch (e) {
      isLoading = false;
      refreshUI();
      String errorMessage = e is Exception
          ? e.toString().replaceFirst('Exception: ', '')
          : e.toString();
      CustomSnackBar.showSnackBar("$errorMessage");
      print("Error: $e");
    }
  }

  loginAdminEmailPartner(String email) async {
    isLoading = true;
    refreshUI();
    try {
      final responseBody = await _apiService.emailLoginPartner(email);
      isLoading = false;
      refreshUI();
      if (responseBody['status'] == 1) {
        await _sharedPreferenceService.saveOriginalId(responseBody['id']);
        await _sharedPreferenceService.saveAdminEmailCredentials(
            email, responseBody['onboarding_complete']);
        if (responseBody['onboarding_complete'] == 1) {
          CustomSnackBar.showSnackBar("Login successful!");
          //Get.to(() => const DashBoardPage());
          Get.to(() => const CustomBottomBar());
        } else if (responseBody['onboarding_complete'] == 0) {
          Get.to(() => StepperNavBar(isGoogleAuth: true, email: email));
        }
      } else {
        final response = await _apiService.initiatePartnerRegistration(
            email: email, isPhoneAuth: false);
        await _sharedPreferenceService.saveOriginalId(response['id']);
        Get.to(() => StepperNavBar(isGoogleAuth: true, email: email));
      }
    } catch (e) {
      isLoading = false;
      refreshUI();
      String errorMessage = e is Exception
          ? e.toString().replaceFirst('Exception: ', '')
          : e.toString();
      CustomSnackBar.showSnackBar("$errorMessage");
      print("Error: $e");
    }
  }

  Future<void> tryAutoLogin() async {
    final SharedPreferenceService _sharedPreferenceService = SharedPreferenceService();
    String? number = (await _sharedPreferenceService.getAdminPhoneCredentials()) ?? "";
    try {
      isLoading = true;
      refreshUI();
      final responseBody = await _apiService.getPartnerById();
      isLoading = false;
      refreshUI();
      if (responseBody['status'] == 1) {
        await _sharedPreferenceService.saveOriginalId(responseBody['id']);
        print("OriginalId: ${responseBody['id']}");
        await _sharedPreferenceService.saveAdminPhoneCredentials(
            number, responseBody['onboarding_complete']);
        if (responseBody['onboarding_complete'] == 1) {
          //Get.off(() => DashBoardPage());
          Get.off(() => CustomBottomBar());
        } else {
          Get.to(
            () => StepperNavBar(
              isGoogleAuth: responseBody['onboarding_complete'] == 1,
              email: responseBody['email'],
            ),
          );
        }
      } else if(responseBody['status'] == -1) {
        _sharedPreferenceService.clearCredentials();
        Get.off(() => AdminPhoneNumberPage());
      }
    } catch (e) {
      isLoading = false;
      refreshUI();
      CustomSnackBar.showSnackBar("Error: $e");
      print("Error: $e");
    }
  }
}
