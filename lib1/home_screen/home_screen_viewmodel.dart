import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import '../models/categories.dart';
import '../models/favorite.dart';
import '../models/service_provider_model.dart';
import '../models/services.dart';
import '../services/services.dart';
import 'package:http/http.dart' as http;

import '../utils/common_variables.dart';
import '../utils/constants.dart';

class HomeScreenViewModel extends ChangeNotifier {
  String selectedServiceFor = 'Women';
  int? selectedSegment = 0;
  bool isLoading = false;
  String locationStatus = '';
  double latitude = 0.0;
  double longitude = 0.0;

  List<Subcategories> subcategories = [];
  List<ServiceModel> services = [];
  List<ServicesProvider> serviceProvider = [];
  final Map<String, List<Subcategories>> subcategory = {
    'Women': [],
    'Men': [],
    'Kids': [],
  };

  final ApiService apiService = ApiService();

  // Favorite services list

  List<Favorite> favoriteService = [];

  updateFcmToken() {
    apiService.updateFCMToken();
  }

  Future<void> fetchData() async {
    isLoading = true;
    notifyListeners();
    try {
      subcategories = await apiService.subcategories(); // Fetch subcategories
      // Group subcategories by category
      subcategory['Women'] =
          subcategories.where((sub) => sub.categoryId == 1).toList();
      subcategory['Men'] =
          subcategories.where((sub) => sub.categoryId == 2).toList();
      subcategory['Kids'] =
          subcategories.where((sub) => sub.categoryId == 3).toList();
    } catch (e) {
      print("Error fetching subcategories: $e");
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchServiceData() async {
    isLoading = true;
    notifyListeners();
    try {
      services = await apiService.services(); // Fetch services
    } catch (e) {
      print("Error fetching services: $e");
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchSalonServiceProvidersData() async {
    isLoading = true;
    notifyListeners();
    try {
      serviceProvider = await apiService.fetchSalonServiceProviders();
    } catch (e) {
      print("Error fetching salon service providers: $e");
    }
    isLoading = false;
    notifyListeners();
  }

  // Future<void> fetchServiceProviderImageData() async {
  //   isLoading = true;
  //   notifyListeners();
  //   try {
  //     serviceProviderImage = await apiService.fetchServiceProviderImages();
  //   } catch (e) {
  //     print("Error fetching salon service provider image: $e");
  //   }
  //   isLoading = false;
  //   notifyListeners();
  // }

  Future<void> increaseViewCount(int service_provider_id) async {
    try {
      await apiService.increaseViewCount(service_provider_id);
      print(
          'View count increased for service provider with id: $service_provider_id');
    } catch (e) {
      print("Error increasing view count: $e");
    }
  }

  Future<void> fetchFavorite() async {
    try {
      favoriteService = await apiService.getMyFavorite();
      print(favoriteService);
    } catch (e) {
      print("Error fetching subcategories: $e");
    }
    notifyListeners();
  }

  Future<void> addFavorite(serviceProviderId) async {
    try {
      var response = await apiService.addToFavorite(
          serviceProviderId: serviceProviderId); // Fetch subcategories
      print(response);
    } catch (e) {
      print("Error fetching subcategories: $e");
    }
    await fetchFavorite();
    notifyListeners();
  }

  Future<void> removeFavorite(serviceProviderId) async {
    try {
      var response = await apiService.removeFromFavorite(
          serviceProviderId: serviceProviderId);
      favoriteService.removeWhere(
          (service) => service.serviceProviderId == serviceProviderId);
    } catch (e) {
      print("Error fetching subcategories: $e");
    }
    notifyListeners();
  }

  // Method to handle UI refresh when category button is clicked
  void updateCategory(String serviceFor) {
    selectedServiceFor = serviceFor;
    notifyListeners();
  }

  Future<void> updateUserLocation(int id, String location) async {
    locationStatus = 'Updating location...';
    await apiService.updateLocation(id, location);
  }

  // Refresh UI
  void refreshUI() {
    notifyListeners();
  }
}
