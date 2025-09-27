import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:wellwait_app/admin/utils/admin_%20common_variable.dart';
import 'package:wellwait_app/utils/util.dart';
import '../admin/admin_phone_number_login/admin_phone_number_page.dart';
import '../models/admin_notification.dart';
import '../models/booking.dart';
import '../models/categories.dart';
import '../models/count.dart';
import '../models/customer.dart';
import '../models/favorite.dart';
import '../models/panel.dart';
import '../models/revenue_analysis.dart';
import '../models/service_provider_banner.dart';
import '../models/service_provider_image.dart';
import '../models/service_provider_model.dart';
import '../models/salon_timing.dart';
import '../models/services.dart';
import '../phone_number_login/phone_number_login_page.dart';
import '../utils/common_variables.dart';
import '../utils/constants.dart';
import '../utils/sp_helper.dart';

class ApiService {
  final SharedPreferenceService _sharedPreferenceService =
      SharedPreferenceService();

  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    final response = await http.post(
      Uri.parse('$BASE_URL/login'),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );
    if (response.statusCode == 200) {
      // Parse and return the response body
      return jsonDecode(response.body);
    } else {
      throw Exception('Login failed: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> loginPartner(String phoneNumber) async {
    try {
      final response = await http.post(
        Uri.parse('$BASE_URL/phone_number_loginpartner'),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          'mobile_number': phoneNumber,
        }),
      );

      if (response.statusCode == 200) {
        print("loginPartner: ${jsonEncode(response.body)}");
        return jsonDecode(response.body);
      } else {
        print("admin otp: ${jsonEncode(response.body)}");
        return {
          'message': 'Error: ${response.body}',
        };
      }
    } catch (error) {
      print("Error occurred: $error");
      return {
        'error': true,
        'message': 'Error occurred: $error',
      };
    }
  }

  Future<Map<String, dynamic>> initiatePartnerRegistration({
    String email = "",
    String phoneNumber = "",
    required bool isPhoneAuth,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$BASE_URL/initiate_partner_registration'),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          'email': email,
          'mobile_number': phoneNumber,
          'is_phone_auth': isPhoneAuth,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          'message': 'Error: ${response.body}',
        };
      }
    } catch (error) {
      return {
        'error': true,
        'message': 'Error occurred: $error',
      };
    }
  }

  Future<Map<String, dynamic>> getPartnerById() async {
    try {
      final response = await http.post(
        Uri.parse('$BASE_URL/get_partner_by_id'),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          'serviceProviderId': adminServiceProviderId,
        }),
      );

      if (response.statusCode == 200) {
        print("partnerId: ${jsonDecode(response.body)}");
        return jsonDecode(response.body);
      } else {
        await _sharedPreferenceService.clearCredentials();
        Get.off(() => PhoneNumberLoginPage());
        print("else Error: ${response.body}");
        return {
          'message': 'Error: ${response.body}',
        };
      }
    } catch (error) {
      print("'Error occurred: $error'");
      return {
        'error': true,
        'message': 'Error occurred: $error',
      };
    }
  }

  Future<Map<String, dynamic>> updateServiceProviderDocuments({
    required int id,
    required String panCard,
    required String gstIn,
    required String bankAccountNumber,
    required String bankIfscCode,
  }) async {
    final url = Uri.parse('$BASE_URL/update_service_provider_bank_details/$id');

    try {
      final body = {
        'pan_card': panCard,
        'gst_in': gstIn,
        'bank_account_number': bankAccountNumber,
        'bank_ifsc_code': bankIfscCode,
      };

      // Make the PUT request
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      // Handle the response
      if (response.statusCode == 200) {
        return jsonDecode(response.body); // Return response data
      } else {
        return {
          'error': true,
          'message': 'Error: ${response.body}',
        };
      }
    } catch (error) {
      return {
        'error': true,
        'message': 'Error: $error',
      };
    }
  }

  Future<Map<String, dynamic>> addService({
    required String category,
    required String name,
    required double price,
    required String imageUrl,
    required int serviceProviderId,
  }) async {
    final url = Uri.parse('$BASE_URL/services/servicespartner');

    // Prepare request body
    final body = {
      'name': name,
      'category': category,
      'price': price,
      'promo_image': imageUrl,
      'rating': 0, // Default rating
      'category_type': category,
      'service_provider_id': serviceProviderId,
    };

    try {
      // Make POST request
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      // Handle response
      if (response.statusCode == 201) {
        return jsonDecode(response.body); // Success
      } else {
        return {
          'error': true,
          'message': jsonDecode(response.body)['error'],
        }; // Error
      }
    } catch (error) {
      return {
        'error': true,
        'message': 'Error occurred: $error',
      };
    }
  }

  Future<void> updateServiceProvider(
    int id,
    String name,
    String salonName,
    String address,
    String email,
    String location,
    String city,
    String state,
    String country,
    String pincode,
    String address2,
  ) async {
    final url = Uri.parse('$BASE_URL/update_service_provider_info/$id');

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'name': name,
        'salon_name': salonName,
        'address': address,
        'email': email,
        'location': location,
        'city': city,
        'state': state,
        'country': country,
        'pincode': pincode,
        'address_2': address2,
      }),
    );

    if (response.statusCode == 200) {
      // Handle success
      print("Update response: ${response.body}");
    } else {
      // Handle error
      throw Exception('Failed to update service provider: ${response.body}');
    }
  }

  // Method to fetch subcategories from the API
  Future<List<Subcategories>> subcategories() async {
    final response = await http.get(Uri.parse('$BASE_URL/subcategories'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      print(jsonEncode(response.body));
      return data.map((item) => Subcategories.fromJson(item)).toList();
    } else {
      throw Exception('Failed to fetch subcategories: ${response.statusCode}');
    }
  }

  Future<Map> updateFCMToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    final response = await http.post(
      Uri.parse('$BASE_URL/update-fcm-token'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "user_id": adminServiceProviderId > 0 ? adminServiceProviderId : userId,
        "fcm_token": token,
        "isAdmin": adminServiceProviderId > 0
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return {};
    }
  }

  // Method to fetch subcategories from the API
  Future<List<Favorite>> getMyFavorite() async {
    final response =
        await http.get(Uri.parse('$BASE_URL/getmyfavorite?user_id=$userId'));
    print("userId: ${userId}");
    if (response.statusCode == 200) {
      // Parse the response and map it to the model
      print("favorite response: ${jsonEncode(response.body)}");
      return favoriteFromJson(response.body);
    } else {
      throw Exception('Failed to fetch favorite: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> addToFavorite(
      {required int serviceProviderId}) async {
    final url = Uri.parse('$BASE_URL/addmyfavorite');
    try {
      final body = {
        'user_id': userId,
        'service_provider_id': serviceProviderId
      };
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      print(body);
      print('Response Status Code: ${response.statusCode}');
      if (response.statusCode == 200) {
        print(response.statusCode);
        return jsonDecode(response.body); // Success: return response data
      } else {
        print('Error');
        return {
          'error': true,
          'message': jsonDecode(response.body)['error'],
        }; // Error: return error message
      }
    } catch (error) {
      return {
        'error': true,
        'message': 'Error occurred: $error',
      };
    }
  }

  Future<Map<String, dynamic>> removeFromFavorite(
      {required int serviceProviderId}) async {
    final url = Uri.parse('$BASE_URL/removemyfavorite');
    try {
      final body = {
        'user_id': userId,
        'service_provider_id': serviceProviderId
      };
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      print(body);
      print('Response Status Code: ${response.statusCode}');
      if (response.statusCode == 200) {
        print(response.statusCode);
        return jsonDecode(response.body); // Success: return response data
      } else {
        print('Error');
        return {
          'error': true,
          'message': jsonDecode(response.body)['error'],
        }; // Error: return error message
      }
    } catch (error) {
      return {
        'error': true,
        'message': 'Error occurred: $error',
      };
    }
  }

  // Method to fetch service providers
  Future<List<ServicesProvider>> fetchSalonServiceProviders() async {
    final url = Uri.parse('$BASE_URL/salon_service_providers');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'user_id': userId}),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body);
      print('Salon Response body: ${jsonResponse}');
      final services = jsonResponse
          .map((service) => ServicesProvider.fromJson(service))
          .toList();
      print("salon service provider: ${services.length}");
      return services;
    } else {
      throw Exception(
          'Failed to load service providers: ${response.statusCode}');
    }
  }

  Future<ServicesProvider> fetchAdminSalonServiceProviders(
      int serviceProviderId) async {
    final url =
        Uri.parse('$BASE_URL/get_salon_service_providers/$serviceProviderId');
    final response = await http.get(url);

    // Print the status code and response body for debugging
    print('Status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse =
          json.decode(response.body) as Map<String, dynamic>;
      return ServicesProvider.fromJson(jsonResponse);
    } else {
      throw Exception(
          'Failed to load service providers: ${response.statusCode}');
    }
  }

  Future<List<ServicesProvider>> fetchSalonServiceProviderById(int id) async {
    final url = Uri.parse('$BASE_URL/get_service_provider_by_id/$id');
    final response = await http.get(url);

    // Print the status code and response body for debugging
    print('Status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((service) => ServicesProvider.fromJson(service))
          .toList();
    } else {
      throw Exception(
          'Failed to load service providers: ${response.statusCode}');
    }
  }

  // Method to fetch services from the API
  Future<List<ServiceModel>> services() async {
    final response = await http.get(Uri.parse('$BASE_URL/services'));

    if (response.statusCode == 200) {
      // Parse the response and map it to the model
      //print("service name: ${jsonDecode(response.body)}");
      return serviceModelFromJson(response.body);
    } else {
      throw Exception('Failed to fetch services: ${response.statusCode}');
    }
  }

  Future<void> increaseViewCount(int service_provider_id) async {
    final url = '$BASE_URL/increase_view_count/$service_provider_id';
    final response = await http.put(Uri.parse(url));

    if (response.statusCode != 200) {
      throw Exception('Failed to increase view count');
    }
  }

  Future<List<Panel>> fetchPanels(int serviceProviderId) async {
    final response =
        await http.get(Uri.parse('$BASE_URL/panels/$serviceProviderId'));
    print(response.body);
    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((json) => Panel.fromJson(json)).toList();
    } else {
      return [];
    }
  }

  Future<bool> setPanelStatus(int panelId, int status) async {
    final url = Uri.parse('$BASE_URL/set_panel_status');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'panel_id': panelId,
          'status': status,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      return false;
    }
  }

  Future<Count> getBookingCount(int panelId) async {
    DateTime now = DateTime.now();
    String scheduledDate = DateFormat('yyyy-MM-dd').format(now);
    final response = await http.get(Uri.parse(
        '$BASE_URL/bookings/count?scheduled_date=$scheduledDate&panel_id=$panelId'));

    if (response.statusCode == 200) {
      return countFromJson(response.body); // Parse JSON to Count object
    } else {
      throw Exception('Failed to load booking count');
    }
  }

  Future<List<SalonTiming>> fetchSalonTimings(String salonId) async {
    String day = _getDayOfWeek(DateTime.now().weekday);
    final response =
        await http.get(Uri.parse('$BASE_URL/salon_timings/$salonId/$day'));
    print("fetchSalonTiming: ${jsonEncode(response.body)}");
    if (response.statusCode == 200) {
      // Decode the response body to List and map to SalonTiming objects
      List<dynamic> jsonResponse = json.decode(response.body);
      print("response salonTiming: ${response.body}");
      return List<SalonTiming>.from(
          jsonResponse.map((json) => SalonTiming.fromJson(json)));
    } else {
      return [];
    }
  }

  String _getDayOfWeek(int weekday) {
    switch (weekday) {
      case 1:
        return "Monday";
      case 2:
        return "Tuesday";
      case 3:
        return "Wednesday";
      case 4:
        return "Thursday";
      case 5:
        return "Friday";
      case 6:
        return "Saturday";
      case 7:
        return "Sunday";
      default:
        return "";
    }
  }

  Future<List<Booking>> fetchBookings(int serviceProviderId) async {
    // Construct the query parameters
    DateTime now = DateTime.now();
    String scheduledDate = DateFormat('yyyy-MM-dd').format(now);
    final Uri uri = Uri.parse('$BASE_URL/booking').replace(queryParameters: {
      'scheduled_date': scheduledDate,
      'service_provider_id': serviceProviderId.toString()
    });

    // Make the GET request
    final response = await http.get(uri);

    // Check if the request was successful
    if (response.statusCode == 200) {
      // Parse the JSON response and map it to a list of Booking objects
      print(response.body);
      return bookingFromJson(response.body);
    } else {
      // If the request fails, throw an exception with the error message
      throw Exception('Failed to load bookings: ${response.body}');
    }
  }

  Future<List<Booking>> fetchPastBooking() async {
    final Uri uri = Uri.parse('$BASE_URL/past_booking?userId=$userId');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      print(response.body);
      return bookingFromJson(response.body);
    } else {
      throw Exception('Failed to load bookings: ${response.body}');
    }
  }

  Future<List<Booking>> bookingPending(int userId) async {
    final Uri uri = Uri.parse('$BASE_URL/booking_pending?userId=$userId');
    print("Booking Pending API Call: $uri");
    print("booking userId: $userId");
    try {
      final response = await http.get(uri);
      print("API Response Status Code: ${response.statusCode}");
      print("API Response Body: ${response.body}");
      if (response.statusCode == 200) {
        return bookingFromJson(response.body);
      } else {
        return [];
      }
    } catch (e) {
      print("Error: $e");
      return [];
    }
  }

  Future<void> cancelBooking(int bookingId) async {
    final response = await http.put(
      Uri.parse('$BASE_URL/cancel_booking/$bookingId/status'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to cancel booking: ${response.body}');
    }
  }

  Future<void> startBooking(int id) async {
    final url = Uri.parse('$BASE_URL/start_booking/$id');

    // Create the request payload
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    // Handle the response
    if (response.statusCode == 200) {
      // Booking updated successfully
      print('Booking updated successfully');
    } else if (response.statusCode == 404) {
      throw Exception('Booking not found');
    } else {
      throw Exception('Failed to update booking');
    }
  }

  Future<void> endBooking(int id) async {
    final url = Uri.parse('$BASE_URL/end_booking/$id');

    // Create the request payload
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    // Handle the response
    if (response.statusCode == 200) {
      // Booking updated successfully
      print('Booking updated successfully');
    } else if (response.statusCode == 404) {
      throw Exception('Booking not found');
    } else {
      throw Exception('Failed to update booking');
    }
  }

  Future<void> updateBookingFinished(int id) async {
    final url = Uri.parse('$BASE_URL/update_booking_finished/$id');

    // Create the request payload
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    // Handle the response
    if (response.statusCode == 200) {
      // Booking updated successfully
      print('Booking updated successfully');
    } else if (response.statusCode == 404) {
      throw Exception('Booking not found');
    } else {
      throw Exception('Failed to update booking');
    }
  }

  Future<bool> addServiceProviderImage(
      int serviceProviderId, String imageUrl) async {
    final url = Uri.parse('$BASE_URL/add_service_provider_image');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'service_provider_id': serviceProviderId,
          'image_url': imageUrl,
        }),
      );

      if (response.statusCode == 200) {
        print("Response: ${response.body}");
        return true;
      } else {
        print("Error: ${response.body}");
        return false;
      }
    } catch (error) {
      print("Exception: $error");
      return false;
    }
  }

  Future<bool> uploadServiceProviderBanner(
      int serviceProviderId, String imageUrl) async {
    final url = Uri.parse('$BASE_URL/service_provider_banner');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'service_provider_id': serviceProviderId,
          'image_url': imageUrl,
        }),
      );

      if (response.statusCode == 200) {
        print("Response: ${response.body}");
        return true;
      } else {
        print("Error: ${response.body}");
        return false;
      }
    } catch (error) {
      print("Exception: $error");
      return false;
    }
  }

  Future<bool> updateUserPhoto(String photo) async {
    final url = Uri.parse('$BASE_URL/update_user_photo');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'id': userId,
          'photo': photo,
        }),
      );

      if (response.statusCode == 200) {
        print("Response: ${response.body}");
        return true;
      } else {
        print("Error: ${response.body}");
        return false;
      }
    } catch (error) {
      print("Exception: $error");
      return false;
    }
  }

  Future<Map<String, dynamic>> addPanel({
    required String name,
    required String responsiblePerson,
    required double price,
    required int serviceProviderId,
    required String serviceList,
    required String lunchStart,
    required String lunchEnd,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$BASE_URL/add_panels'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'name': name,
          'responsible_person': responsiblePerson,
          'price': price,
          'service_provider_id': serviceProviderId,
          'service_list': serviceList,
          'lunch_start': lunchStart,
          'lunch_end': lunchEnd,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to add panel');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }

  Future<List<SalonTiming>> getSalonTimings(String salonId) async {
    final response =
        await http.get(Uri.parse('$BASE_URL/get_salon_timings/$salonId'));

    if (response.statusCode == 200) {
      // Decode the response body to List and map to SalonTiming objects
      List<dynamic> jsonResponse = json.decode(response.body);
      print("response salonTiming: ${response.body}");
      return List<SalonTiming>.from(
          jsonResponse.map((json) => SalonTiming.fromJson(json)));
    } else {
      return [];
    }
  }

  Future<Map<String, dynamic>> userLoginPhoneNumber(String phoneNumber) async {
    try {
      final response = await http.post(
        Uri.parse('$BASE_URL/phone_number_login'),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          'phone_number': phoneNumber,
        }),
      );
      if (response.statusCode == 200) {
        // Parse and return the response body as JSON
        return jsonDecode(response.body);
      } else {
        // Parse error message from JSON response
        var errorData = jsonDecode(response.body);
        throw Exception('Login failed: ${errorData['message']}');
      }
    } catch (error) {
      print("Error occurred: $error");
      return {
        'error': true,
        'message': 'Error occurred: $error',
      };
    }
  }

  Future<List<ServicesProvider>> searchSalons(String query) async {
    final response = await http.get(
        Uri.parse('$BASE_URL/search_salon_service_providers?query=$query'));

    if (response.statusCode == 200) {
      print("search response: ${response.body}");
      print("search response json : ${json.decode(response.body)}");
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load salons: ${response.statusCode}');
    }
  }

  Future<bool> updateLocation(int id, String location) async {
    final url = Uri.parse('$BASE_URL/update-location');

    final Map<String, dynamic> body = {
      'id': id,
      'location': location,
    };

    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        print("location response: ${jsonEncode(response.body)}");
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<void> fetchSalonProviders(String category, String rating,
      String service, double distance, String priceRange) async {
    final url = '$BASE_URL/filter_salon_service_providers';

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'category': category,
        'rating': rating,
        'service': service,
        'distance': distance,
        'priceRange': priceRange,
      }),
    );

    if (response.statusCode == 200) {
      print('Salon service provider added successfully');
    } else {
      print('Failed to add salon service provider');
    }
  }

  Future<Map<String, dynamic>> userLoginEmail(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$BASE_URL/gmail_login'),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          'email': email,
        }),
      );
      if (response.statusCode == 200) {
        // Parse and return the response body as JSON
        return jsonDecode(response.body);
      } else {
        // Parse error message from JSON response
        var errorData = jsonDecode(response.body);
        throw Exception('Login failed: ${errorData['message']}');
      }
    } catch (error) {
      print("Error occurred: $error");
      return {
        'error': true,
        'message': 'Error occurred: $error',
      };
    }
  }

  Future<Map<String, dynamic>> emailLoginPartner(String email) async {
    final response = await http.post(
      Uri.parse('$BASE_URL/gmail_loginpartner'),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        'email': email,
      }),
    );
    if (response.statusCode == 200) {
      print("loginPartner: ${jsonEncode(response.body)}");
      return jsonDecode(response.body);
    } else {
      return {
        'error': true,
        'message': 'Error: ${response.body}',
      };
    }
  }

  //
  // Future<List<ServicesProvider>> sendFavoriteSalons(List<String> favoriteSalons) async {
  //   try {
  //     final response = await http.post(
  //       Uri.parse('$BASE_URL/sendFavoriteSalons'),
  //       headers: {
  //         'Content-Type': 'application/json',
  //       },
  //       body: json.encode({'favoriteSalons': favoriteSalons}),
  //     );
  //
  //     if (response.statusCode == 200) {
  //       final List<dynamic> data = json.decode(response.body);
  //       return data
  //           .map((item) => ServicesProvider.fromJson(item)) // Convert JSON to ServicesProvider objects
  //           .toList();
  //     } else {
  //       throw Exception('Failed to send favorite salons');
  //     }
  //   } catch (e) {
  //     throw Exception('Error sending favorite salons: $e');
  //   }
  // }

  Future<List<ServicesProvider>> getSalonByService(String serviceName) async {
    final String apiUrl =
        '$BASE_URL/api/salon_by_service?serviceName=$serviceName&userId=$userId';
    try {
      final response = await http.get(Uri.parse(apiUrl));
      print("serviceName: $serviceName");
      print("userId: $userId");
      if (response.statusCode == 200) {
        final List<dynamic> responseBody =
            json.decode(response.body)['service_providers'];
        return responseBody
            .map((data) => ServicesProvider.fromJson(data))
            .toList();
      } else {
        print("salonByService: ${jsonEncode(response.body)}");
        throw Exception(
            'Failed to load service providers. Status Code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching salon by service: $error');
      rethrow;
    }
  }

  Future<List<Subcategories>> increaseSearchCount(String categoryName) async {
    final String url = '$BASE_URL/increase-search-count';
    final Map<String, dynamic> requestBody = {
      'name': categoryName, // Pass the service name here
    };
    print("Category name: $categoryName");

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        // Parse the response into a list of Subcategories
        List<dynamic> responseBody = jsonDecode(response.body);
        List<Subcategories> subcategories =
            responseBody.map((json) => Subcategories.fromJson(json)).toList();
        return subcategories;
      } else if (response.statusCode == 404) {
        print('Subcategory not found: ${response.body}');
        return [];
      } else {
        print('Failed to update search count: ${response.body}');
        return [];
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  Future<List> getNotifications() async {
    final String url = '$BASE_URL/getNotifications?userId=$userId';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List responseBody = jsonDecode(response.body);
      print("notification response: ${jsonDecode(response.body)}");
      return responseBody;
    } else {
      return [];
    }
  }

  Future<bool> uploadPanCardImage(int id, String panCardImage) async {
    final url = Uri.parse('$BASE_URL/upload_pancard_image');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'id': id,
          'pancard_image': panCardImage,
        }),
      );

      if (response.statusCode == 200) {
        print("Response: ${response.body}");
        return true;
      } else {
        print("Error: ${response.body}");
        return false;
      }
    } catch (error) {
      print("Exception: $error");
      return false;
    }
  }

  Future<bool> uploadDocumentsImage(int id, String documentImage) async {
    final url = Uri.parse('$BASE_URL/upload_document_image');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'id': id,
          'document_image': documentImage,
        }),
      );

      if (response.statusCode == 200) {
        print("Response: ${response.body}");
        return true;
      } else {
        print("Error: ${response.body}");
        return false;
      }
    } catch (error) {
      print("Exception: $error");
      return false;
    }
  }

  Future<ServicesProvider> getServiceProviderInfo(int serviceProviderId) async {
    final url =
        Uri.parse('$BASE_URL/get_service_provider_info/$serviceProviderId');
    final response = await http.get(url);
    // Debugging Logs
    print('Status code: ${response.statusCode}');
    print('Response body: ${response.body}');
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      // Pass the JSON response to ServicesProvider.fromJson
      return ServicesProvider.fromJson(jsonResponse['data']);
    } else {
      throw Exception(
          'Failed to load service provider: ${response.statusCode}');
    }
  }

  Future<List<SalonTiming>> getServiceProviderTimings(String salonId) async {
    final response =
        await http.get(Uri.parse('$BASE_URL/get_salon_timings/$salonId'));

    if (response.statusCode == 200) {
      final dynamic jsonResponse = json.decode(response.body);

      // Check if the response is a list (direct list response)
      if (jsonResponse is List) {
        return jsonResponse.map((item) => SalonTiming.fromJson(item)).toList();
      }

      // Check if the response is a map and contains 'data' as a list
      if (jsonResponse is Map<String, dynamic> &&
          jsonResponse.containsKey('data') &&
          jsonResponse['data'] is List) {
        return (jsonResponse['data'] as List)
            .map((item) => SalonTiming.fromJson(item))
            .toList();
      }

      throw Exception("Unexpected JSON format");
    } else {
      throw Exception('Failed to load salon timings');
    }
  }

  Future<ServicesProvider?> fetchBankDetails(int serviceProviderId) async {
    final url = Uri.parse(
        '$BASE_URL/get_service_provider_bank_details/$serviceProviderId');
    final response = await http.get(url);

    // Debugging Logs
    print('Status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      try {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        // Directly parsing the JSON response since it is not wrapped in "data"
        return ServicesProvider.fromJson(jsonResponse);
      } catch (e) {
        print('Error parsing JSON: $e');
        return null;
      }
    } else {
      throw Exception('Failed to load bank details: ${response.statusCode}');
    }
  }

  Future<bool> updatePanel(
      {required int panelId,
      required String name,
      required String responsiblePerson,
      required double price,
      required String serviceList,
      required String lunchStart,
      required String lunchEnd,
      required int serviceProviderId}) async {
    final url = Uri.parse('$BASE_URL/update_panel/$panelId');

    try {
      final response = await http.put(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": name,
          "responsible_person": responsiblePerson,
          "price": price,
          "service_list": serviceList,
          "lunch_start": lunchStart,
          "lunch_end": lunchEnd,
          "service_provider_id": serviceProviderId
        }),
      );

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Error updating panel: $e");
      return false;
    }
  }

  Future<List<Booking>> getPanelBookings(int panelId) async {
    final Uri url = Uri.parse("$BASE_URL/get_panel_bookings/$panelId");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        //print("response data: $jsonData");
        return jsonData.map((data) => Booking.fromJson(data)).toList();
      } else {
        throw Exception("Failed to load bookings: ${response.body}");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  Future<List<Customer>> getCustomers(int id) async {
    final url = Uri.parse(
        '$BASE_URL/get_customers?serviceProviderId=$id'); // Use query parameter

    final response = await http.get(url);

    print('Status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((service) => Customer.fromJson(service)).toList();
    } else {
      throw Exception('Failed to load customers: ${response.statusCode}');
    }
  }

  addBooking({
    int? userId,
    required List<Map<String, dynamic>> bookings,
    bool addUser = false,
    String? customerName,
  }) async {
    return await http.post(
      Uri.parse('$BASE_URL/add_bookings'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'userId': userId,
        'bookings': bookings,
        'addUser': addUser,
        'username': customerName,
      }),
    );
  }

  Future<Map<String, dynamic>> updateSalonTiming({
    required int salonId,
    required List<String> days,
    required String startTime,
    required String endTime,
    String? lunchStart,
    String? lunchEnd,
  }) async {
    final url = Uri.parse('$BASE_URL/updateSalonTiming'); // API URL

    try {
      // Prepare request body
      final body = {
        'salon_id': salonId,
        'days': days,
        'start_time': startTime,
        'end_time': endTime,
        'lunch_start': lunchStart,
        'lunch_end': lunchEnd,
      };

      // Make PUT request
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      // Handle response
      if (response.statusCode == 200) {
        return jsonDecode(response.body); // Success: return response data
      } else {
        return {
          'error': true,
          'message': jsonDecode(response.body)['error'],
        }; // Error: return error message
      }
    } catch (error) {
      return {
        'error': true,
        'message': 'Error occurred: $error',
      };
    }
  }

  Future<List<ServiceProviderImage>> getServiceProviderImages(
      int serviceProviderId) async {
    final response = await http.get(
      Uri.parse('$BASE_URL/get_salon_provider_images/$serviceProviderId'),
    );

    if (response.statusCode == 200) {
      return serviceProviderImageFromJson(response.body);
    } else {
      Util.getSnackBar("Failed to load service provider images");
      return [];
    }
  }

  Future<List<ServiceProviderBanner>> getServiceProviderBanner(
      int serviceProviderId) async {
    final response = await http.get(
      Uri.parse('$BASE_URL/salon_provider_banner/$serviceProviderId'),
    );

    if (response.statusCode == 200) {
      return serviceProviderBannerFromJson(response.body);
    } else {
      Util.getSnackBar("Failed to load service provider images");
      return [];
    }
  }

  Future<List<ServiceModel>> getServices(int serviceProviderId) async {
    final Uri url = Uri.parse("$BASE_URL/services/$serviceProviderId");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final dynamic jsonResponse = json.decode(response.body);
        if (jsonResponse is List) {
          return jsonResponse
              .map((service) => ServiceModel.fromJson(service))
              .toList();
        } else if (jsonResponse is Map<String, dynamic> &&
            jsonResponse.containsKey("services")) {
          final List<dynamic> servicesList = jsonResponse["services"];
          return servicesList
              .map((service) => ServiceModel.fromJson(service))
              .toList();
        } else {
          Util.getSnackBar("Unexpected API response format.");
        }
      } else {
        Util.getSnackBar("Failed to load services");
      }
    } catch (e) {
      Util.getSnackBar("Error: $e");
    }
    return [];
  }

  Future<bool> updateService({
    required int serviceId,
    required String name,
    required String category,
    required double price,
    required String promoImage,
    required double rating,
    required String categoryType,
    required int serviceProviderId,
  }) async {
    final String apiUrl =
        "http://your-server-ip:port/services/servicespartner/$serviceId";

    final Map<String, dynamic> requestBody = {
      "name": name,
      "category": category,
      "price": price,
      "promo_image": promoImage,
      "rating": rating,
      "category_type": categoryType,
      "service_provider_id": serviceProviderId,
    };
    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );
      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 404) {
        print("Service not found");
      } else {
        print("Failed to update service: ${response.body}");
      }
    } catch (e) {
      print("Error: $e");
    }

    return false;
  }

  Future<List<Booking>> getSalonTransactions({
    required int serviceProviderId,
    required String startDate,
    required String endDate,
  }) async {
    final Uri url = Uri.parse(
        "$BASE_URL/get_salon_transactions?service_provider_id=$serviceProviderId&start_date=$startDate&end_date=$endDate");
    try {
      final response = await http.get(url, headers: {
        "Content-Type": "application/json",
      });
      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      if (response.statusCode == 200) {
        final dynamic jsonResponse = json.decode(response.body);
        if (jsonResponse is List) {
          return jsonResponse.map((data) => Booking.fromJson(data)).toList();
        } else if (jsonResponse is Map<String, dynamic> &&
            jsonResponse.containsKey("data")) {
          final List<dynamic> data = jsonResponse["data"];
          return data.map((data) => Booking.fromJson(data)).toList();
        } else {
          throw Exception("Unexpected API response format");
        }
      } else {
        throw Exception("Failed to load transactions: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching transactions: $e");
      throw Exception("Error fetching transactions: $e");
    }
  }

  Future<Map<String, dynamic>?> getRevenueAnalysis(
      int serviceProviderId, String filter) async {
    try {
      final url = Uri.parse(
          "$BASE_URL/get_revenue_analysis?service_provider_id=$serviceProviderId&filter=$filter");
      final response = await http.get(url);
      if (response.statusCode == 200) {
        print("analysis: ${jsonDecode(response.body)}");
        return jsonDecode(response.body);
      } else {
        print("Error: ${response.statusCode} - ${response.body}");
        return null;
      }
    } catch (e) {
      print("Exception: $e");
      return null;
    }
  }

  Future<bool> deletePanel(int panelId) async {
    final url = Uri.parse("$BASE_URL/delete_panel");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"panel_id": panelId}),
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data["status"] == 1) {
        print("call delete api: ${jsonDecode(response.body)}");
        return true; // Panel deleted successfully
      } else {
        throw Exception(data["message"] ?? "Failed to delete panel");
      }
    } catch (e) {
      throw Exception("Error: ${e.toString()}");
    }
  }

  Future<List<AdminNotification>> adminGetNotification(
      int serviceProviderId) async {
    final String url =
        '$BASE_URL/get_notifications?service_provider_id=$serviceProviderId';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse
            .map((json) => AdminNotification.fromJson(json))
            .toList();
      } else {
        print("Failed to fetch notifications: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Error fetching notifications: $e");
      return [];
    }
  }

  Future<RevenueAnalysis?> getRevenuesAnalysis(
      int serviceProviderId, String filter) async {
    try {
      final url = Uri.parse(
          "$BASE_URL/get_revenue_analysis?service_provider_id=$serviceProviderId&filter=$filter");
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        return RevenueAnalysis.fromJson(jsonResponse);
      } else {
        print("Error: ${response.statusCode} - ${response.body}");
        return null;
      }
    } catch (e) {
      print("Exception occurred: $e");
      return null;
    }
  }

  Future<bool> deletePanImage(int serviceProviderId) async {
    final url = Uri.parse("$BASE_URL/delete_service_provider_pancard_img");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"service_provider_id": serviceProviderId}),
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        print("call pan image delete api: ${jsonDecode(response.body)}");
        return true; // Panel deleted successfully
      } else {
        throw Exception(data["message"] ?? "Failed to delete panel");
      }
    } catch (e) {
      throw Exception("Error: ${e.toString()}");
    }
  }

  Future<bool> deleteDocumentImage(int serviceProviderId) async {
    final url = Uri.parse("$BASE_URL/delete_service_provider_document_img");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"service_provider_id": serviceProviderId}),
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        print("call pan image delete api: ${jsonDecode(response.body)}");
        return true; // Panel deleted successfully
      } else {
        throw Exception(data["message"] ?? "Failed to delete document image");
      }
    } catch (e) {
      throw Exception("Error: ${e.toString()}");
    }
  }

  Future<bool> deleteServiceProviderImageImage(int salonImageId) async {
    final url = Uri.parse("$BASE_URL/delete_service_provider_image");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"id": salonImageId}),
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        print("call pan image delete api: ${jsonDecode(response.body)}");
        return true;
      } else {
        Util.getSnackBar(data["message"] ?? "Failed to delete panel");
        return false;
      }
    } catch (e) {
      Util.getSnackBar("Error: ${e.toString()}");
      return false;
    }
  }

  Future<bool> deleteSalonBanner(int salonBannerId) async {
    final url = Uri.parse("$BASE_URL/delete_service_provider_banner");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"id": salonBannerId}),
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data["status"] == 1) {
        return true;
      } else {
        Util.getSnackBar(data["message"] ?? "Failed to delete panel");
        return false;
      }
    } catch (e) {
      Util.getSnackBar("Error: ${e.toString()}");
      return false;
    }
  }

  Future<Map<String, dynamic>?> createOrder(int bookingId) async {
    final url = Uri.parse("$BASE_URL/create-order");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"booking_id": bookingId}),
      );
      return jsonDecode(response.body);
    } catch (e) {
      Util.getSnackBar("Error: ${e.toString()}");
    }
    return null;
  }

  Future<bool> confirmPayment(
    int bookingId,
    String? orderId,
    String? paymentId,
    String? signature,
    Map<dynamic, dynamic>? data,
  ) async {
    final url = Uri.parse("$BASE_URL/confirm-payment");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "booking_id": bookingId,
          "order_id": orderId,
          "payment_id": paymentId,
          "signature": signature,
          "data": jsonEncode(data),
        }),
      );
      return (jsonDecode(response.body)['status'] == 1);
    } catch (e) {
      Util.getSnackBar("Error: ${e.toString()}");
    }
    return false;
  }
}
