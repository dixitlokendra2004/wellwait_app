import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wellwait_app/services/services.dart';
import 'package:wellwait_app/utils/util.dart';
import '../../home_screen/home_screen_viewmodel.dart';
import '../../service_provider_details/sp_detail_viewmodel.dart';
import '../../utils/common_variables.dart';
import '../../utils/constants.dart';
import '../../utils/sp_helper.dart';
import '../../widget/snack_bar_widget.dart';

class BookingScreen2ViewModel extends ChangeNotifier {
  late SPDetailViewModel beautySalonViewModel;
  late HomeScreenViewModel homePageViewModel;

  final SharedPreferenceService sharedPreferenceService =
      SharedPreferenceService();

  int salonServicesIndex = 0;
  int serviceIndex = 0;
  bool isLoading = false;

  // Calculate the total price of selected services
  int calculateServicesPrice() {
    int totalPrice = 0;
    for (var service in beautySalonViewModel.selectedServices) {
      totalPrice += int.tryParse(service['prices'] ?? '0') ?? 0;
    }
    return totalPrice;
  }

  // Calculate the total price including platform fees
  int calculateTotalPrice(servicesLength) {
    int basePlatformFee = servicesLength * 50;
    return basePlatformFee + calculateServicesPrice();
  }

  // Function to make the booking API call
  Future<void> bookAppointment({
    required String scheduledDate,
    required int status,
  }) async {
    if (beautySalonViewModel.selectedServices.isEmpty) {
      return;
    }
    isLoading = true;
    notifyListeners();
    try {
      final List<Map<String, dynamic>> bookings =
          beautySalonViewModel.selectedServices.map((service) {
        return {
          'scheduled_date': scheduledDate,
          'service_provider_id': serviceProviderId,
          'panel_id': service['panelId'],
          'price': service['prices'],
          'status': status,
          'serviceId': service['id'],
        };
      }).toList();

      var response = await ApiService().addBooking(
        userId: userId,
        bookings: bookings,
      );

      if (response.statusCode == 201) {
        final bookingData = jsonDecode(response.body);
        CustomSnackBar.showSnackBar("Bookings created successfully");
        print('Bookings created successfully: $bookingData');
      } else {
        Util.getSnackBar('Failed to create bookings');
      }
    } catch (error) {
      Util.getSnackBar('Error creating bookings: $error');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void refreshUI() {
    notifyListeners();
  }

  clearData() {
    salonServicesIndex = 0;
    serviceIndex = 0;
  }
}
