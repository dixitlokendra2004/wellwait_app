import 'package:flutter/material.dart';
import '../../services/services.dart';
import '../../widget/snack_bar_widget.dart';

class SolonDetailViewModel extends ChangeNotifier {
  final TextEditingController ownerFullNameController = TextEditingController();
  final TextEditingController salonNameController = TextEditingController();
  final TextEditingController salonFullAddressController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();

  bool showProgressbar = false;
  bool isGoogleAuth = false;

  final ApiService _apiService = ApiService();

  initValues(bool isGoogleAuth, String email) {
    this.isGoogleAuth = isGoogleAuth;
    emailController.text = email;
    notifyListeners();
  }

  void refreshUI() {
    notifyListeners();
  }

  // Future<void> updateServiceProvider(int id,String salonFullAddress,String location) async {
  //     showProgressbar = true;
  //     refreshUI();
  //     try {
  //       await _apiService.updateServiceProvider(
  //         id,
  //         ownerFullNameController.text,
  //         salonNameController.text,
  //         salonFullAddress,
  //         emailController.text,
  //         //mobileNumberController.text,
  //         location,
  //       );
  //       CustomSnackBar.showSnackBar("Update the salon detail is successfully!");
  //     } catch (error) {
  //       print(error);
  //       CustomSnackBar.showSnackBar("Updated is Failed!");
  //     } finally {
  //       showProgressbar = false;
  //       refreshUI();
  //     }
  //   }
}
