import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:wellwait_app/admin/admin_queue/detail_panel/detail_panel_viewmodel.dart';
import 'package:wellwait_app/disposable_provider.dart';
import 'package:wellwait_app/models/services.dart';
import 'package:wellwait_app/services/services.dart';
import 'package:wellwait_app/utils/util.dart';

class AddCustomerViewModel extends DisposableProvider {
  TextEditingController customerNameController = TextEditingController();
  List<ServiceModel> selectedServices = [];
  bool isLoading = false;

  double getTotalPrice() {
    double total = 0.0;
    for (var service in selectedServices) {
      double price = service.price?.toDouble() ?? 0.0;
      total += price;
    }
    return total;
  }

  addService(ServiceModel service) {
    if (!selectedServices.any((item) => item.id == service.id)) {
      selectedServices.add(service);
      notifyListeners();
    }
  }

  removeService(int index) {
    selectedServices.removeAt(index);
    notifyListeners();
  }

  Future<void> bookAppointment({
    required int? serviceProviderId,
    required int? panelId,
  }) async {
    if (selectedServices.isEmpty) {
      Util.getSnackBar("Select Services to continue");
      return;
    }

    try {
      final List<Map<String, dynamic>> bookings =
          selectedServices.map((service) {
        return {
          'scheduled_date':
              DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
          'service_provider_id': serviceProviderId,
          'panel_id': panelId,
          'price': service.price,
          'serviceId': service.id,
        };
      }).toList();

      var response = await ApiService().addBooking(
        addUser: true,
        customerName: customerNameController.text,
        bookings: bookings,
      );

      if (response.statusCode == 201) {
        await Provider.of<DetailPanelViewModel>(Get.context!, listen: false)
            .fetchBookings();
        Get.back();
      } else {
        Util.getSnackBar('Failed to create bookings');
      }
    } catch (error) {
      Util.getSnackBar('Error creating bookings: $error');
    }
  }

  void refreshUI() {
    notifyListeners();
  }

  @override
  void disposeValues() {
    customerNameController = TextEditingController();
    selectedServices = [];
    isLoading = false;
  }
}
