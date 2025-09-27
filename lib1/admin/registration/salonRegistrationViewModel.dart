import 'package:flutter/material.dart';
import 'package:wellwait_app/models/service_provider_model.dart';
import '../../services/services.dart';
import '../../widget/snack_bar_widget.dart';

class SolonRegistrationViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final TextEditingController ownerFullNameController = TextEditingController();
  final TextEditingController salonNameController = TextEditingController();
  final TextEditingController salonFullAddressController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();
  final TextEditingController address2Controller = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController countryController = TextEditingController();

  String? selectedCity;
  String? selectedState;
  String? selectedCountry;

  List<String> cities = [];
  List<String> states = [];
  List<String> countries = [];
  ServicesProvider? serviceProviderInfo;
  int selectedIndex = 0;
  final ApiService apiService = ApiService();


  bool showProgressbar = false;
  bool isGoogleAuth = false;
  // final List<String> days = [
  //   "Monday",
  //   "Tuesday",
  //   "Wednesday",
  //   "Thursday",
  //   "Friday",
  //   "Saturday",
  //   "Sunday",
  // ];
  // List<bool> checkboxStates = List.generate(7, (index) => false);
  // bool firstAdditionalCheckboxSelected = false;
  // bool secondAdditionalCheckboxSelected = false;
  // TimeOfDay? openingTime;
  // TimeOfDay? closingTime;
  // TimeOfDay? lunchStartTime;
  // TimeOfDay? lunchEndTime;
  // bool isAllSelected = false;

  // void toggleSelectAll() {
  //   isAllSelected = !isAllSelected;
  //   for (int i = 0; i < checkboxStates.length; i++) {
  //     checkboxStates[i] = isAllSelected;
  //   }
  //   notifyListeners();
  // }

  initValues(bool isGoogleAuth, String email) {
    this.isGoogleAuth = isGoogleAuth;
    emailController.text = email;
    notifyListeners();
  }

  void refreshUI() {
    notifyListeners();
  }

  Future<void> updateServiceProvider(int id,String salonFullAddress,String location) async {
    showProgressbar = true;
    refreshUI();
    try {
      await _apiService.updateServiceProvider(
        id,
        ownerFullNameController.text,
        salonNameController.text,
        salonFullAddress,
        emailController.text,
        //mobileNumberController.text,
        location,
        cityController.text,
        stateController.text,
        countryController.text,
        pincodeController.text,
        address2Controller.text,
      );
      CustomSnackBar.showSnackBar("Update the salon detail is successfully!");
    } catch (error) {
      print(error);
      CustomSnackBar.showSnackBar("Updated is Failed!");
    } finally {
      showProgressbar = false;
      refreshUI();
    }
  }

  Future<void> fetchServiceProviderInfo(int serviceProviderId) async {
    showProgressbar = true;
    notifyListeners();
     //try {
      serviceProviderInfo = await apiService.getServiceProviderInfo(serviceProviderId);
      notifyListeners();
    // } catch (e) {
    //   print("Error fetching Info: $e");
    // }

    showProgressbar = false;
    notifyListeners();
  }
}
