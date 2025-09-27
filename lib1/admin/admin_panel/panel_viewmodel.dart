import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:wellwait_app/disposable_provider.dart';
import 'package:wellwait_app/models/panel.dart';

import '../../services/services.dart';
import '../../widget/snack_bar_widget.dart';
import '../utils/admin_ common_variable.dart';

class AddPanelViewModel extends DisposableProvider {
  String? selectedService;
  List<String> services = [
    "Haircut",
    "Waxing",
    "Coloring",
    "Spa",
    "Nails",
    "Fical",
    "Makeup",
    "Message"
  ];
  List<String> selectedServices = [];

  TextEditingController panelNameController = TextEditingController();
  TextEditingController responsiblePersonController = TextEditingController();
  Map<String, String> servicePrices = {};
  Map<String, TextEditingController> serviceControllers = {};
  bool isLoading = false;
  final ApiService _apiService = ApiService();
  TimeOfDay? lunchStartTime;
  TimeOfDay? lunchEndTime;

  double getTotalPrice() {
    double total = 0.0;
    for (var service in selectedServices) {
      double price = double.tryParse(servicePrices[service] ?? "0.0") ?? 0.0;
      total += price;
    }
    return total;
  }

  initPanelDetails(Panel panel) {
    panelNameController.text = panel.name ?? "";
    responsiblePersonController.text = panel.responsiblePerson ?? "";
    selectedServices = panel.serviceList?.split(",") ?? [];
    selectedServices.forEach((item) {
      servicePrices[item] = "0";
    });
    lunchStartTime = TimeOfDay.fromDateTime(
        DateFormat.Hm().parse(panel.lunchStart ?? "0:0"));
    lunchEndTime =
        TimeOfDay.fromDateTime(DateFormat.Hm().parse(panel.lunchEnd ?? "0:0"));
    notifyListeners();
  }

  Future<void> addPanel() async {
    isLoading = true;
    notifyListeners();
    var lunchStartString = lunchStartTime != null ? '${lunchStartTime?.hour}:${lunchStartTime?.minute}' : null;
    var lunchEndString = lunchEndTime != null ? '${lunchEndTime?.hour}:${lunchEndTime?.minute}' : null;
    String formattedServices = selectedServices.join(", ");
    try {
      double totalPrice = getTotalPrice();

      final result = await _apiService.addPanel(
        name: panelNameController.text,
        responsiblePerson: responsiblePersonController.text,
        price: totalPrice,
        serviceProviderId: adminServiceProviderId,
        serviceList: formattedServices,
        lunchStart: lunchStartString.toString(),
        lunchEnd: lunchEndString.toString(),
      );
      CustomSnackBar.showSnackBar("Panel added successfully");
      notifyListeners();
    } catch (error) {
      CustomSnackBar.showSnackBar("Failed to add panel: $error");
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> updatePanelDetails({
    required int? panelId,
    required TimeOfDay? lunchStart,
    required TimeOfDay? lunchEnd,
  }) async {
    if(panelId == null) return;
    isLoading = true;
    notifyListeners();
    final lunchStartString =
        lunchStart != null ? '${lunchStart.hour}:${lunchStart.minute}' : null;
    final lunchEndString =
        lunchEnd != null ? '${lunchEnd.hour}:${lunchEnd.minute}' : null;
    String formattedServices = selectedServices.join(", ");
    double totalPrice = getTotalPrice();

    bool isUpdated = await _apiService.updatePanel(
      panelId: panelId,
      name: panelNameController.text,
      responsiblePerson: responsiblePersonController.text,
      price: totalPrice,
      serviceList: formattedServices,
      lunchStart: lunchStartString.toString(),
      lunchEnd: lunchEndString.toString(),
      serviceProviderId: adminServiceProviderId,
    );

    isLoading = false;
    notifyListeners();

    if (isUpdated) {
      print("Panel updated successfully");
    } else {
      print("Failed to update panel");
    }
  }

  void refreshUI() {
    notifyListeners();
  }

  @override
  void disposeValues() {
    selectedService = null;
    services = [
      "Haircut",
      "Waxing",
      "Coloring",
      "Spa",
      "Nails",
      "Fical",
      "Makeup",
      "Message"
    ];
    selectedServices = [];
    panelNameController = TextEditingController();
    responsiblePersonController = TextEditingController();
    servicePrices = {};
    serviceControllers = {};
    isLoading = false;
    lunchStartTime = null;
    lunchEndTime = null;
  }
}
