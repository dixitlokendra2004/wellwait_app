import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../queue/queue_viewmodel.dart';
import '../utils/constants.dart';


class RatingViewModel extends ChangeNotifier {

  //late QueueViewModel queueViewModel;
  int selectedStar = 0;

//   int calculateServicesPrice() {
//     int totalPrice = 0;
//     for (var booking in queueViewModel.bookings) {
//       // Convert double price to int and handle null values gracefully
//       num price = booking.price ?? 0.0;
//       totalPrice += price.toInt(); // Convert double to int directly
//     }
//     return totalPrice;
//   }
//
// // Calculate the total price including platform fees
//   int calculateTotalPrice() {
//     int basePlatformFee = 50;
//     return basePlatformFee + calculateServicesPrice();
//   }



  refreshUI() {
    notifyListeners();
  }

  // Future<void> submitRating(int userId, int service_provider_id) async {
  //   // Define your API endpoint
  //   final String url = '$BASE_URL/ratings/$userId/$service_provider_id/$selectedStar';
  //
  //   try {
  //     final response = await http.post(Uri.parse(url));
  //
  //     if (response.statusCode == 200) {
  //       // Handle successful response
  //       print('Rating submitted successfully: ${json.decode(response.body)}');
  //     } else {
  //       // Handle error response
  //       print('Failed to submit rating: ${response.body}');
  //     }
  //   } catch (e) {
  //     print('Error submitting rating: $e');
  //   }
  // }

  Future<void> submitRating(int userId, int serviceProviderId) async {
    final url = Uri.parse('$BASE_URL/ratings');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_id': userId,
          'service_provider_id': serviceProviderId,
          'rating': selectedStar,
        }),
      );

      if (response.statusCode == 200) {
        print('Rating submitted successfully: ${json.decode(response.body)}');
      } else {
        print('Failed to submit rating: ${response.body}');
      }
    } catch (error) {
      print('Error submitting rating: $error');
    }
  }


}
