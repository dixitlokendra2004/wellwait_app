import 'package:flutter/cupertino.dart';
import 'package:wellwait_app/admin/utils/admin_%20common_variable.dart';

import '../../services/services.dart';
import '../../widget/snack_bar_widget.dart';
import '../admin_email_login/admin_email_login_viewmodel.dart';

class AdminPanelViewModel extends ChangeNotifier {
  late AdminEmailLoginViewModel adminEmailLoginViewModel;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController serviceListController = TextEditingController();
  final ApiService _apiService = ApiService();
  bool isLoading = false;


  Future<void> addPanel() async {
    isLoading = true;
    notifyListeners();

    try {
      // Convert the price text to double
      double priceValue = double.tryParse(priceController.text) ?? 0.0; // Defaults to 0.0 if invalid
      // final result = await _apiService.addPanel(
      //   name: nameController.text,
      //   description: descriptionController.text,
      //   price: priceValue,
      //   serviceProviderId: adminServiceProviderId,
      //   serviceList: serviceListController.text,
      // );

      // Show a success SnackBar
      CustomSnackBar.showSnackBar("Panel added successfully");
    } catch (error) {
      // Show a failure SnackBar
      CustomSnackBar.showSnackBar("Failed to add panel: $error");
    }

    isLoading = false;
    notifyListeners();
  }


}