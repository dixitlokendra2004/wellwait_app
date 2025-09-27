import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:wellwait_app/admin/admin_email_login/admin_email_login_viewmodel.dart';
import 'package:wellwait_app/admin/utils/admin_%20common_variable.dart';
import 'package:wellwait_app/models/service_provider_image.dart';
import '../../models/service_provider_banner.dart';
import '../../models/services.dart';
import '../../services/services.dart';
import '../../utils/constants.dart';
import '../../widget/snack_bar_widget.dart';
import 'package:image/image.dart' as img;

class SalonServiceViewModel extends ChangeNotifier {
  late AdminEmailLoginViewModel adminEmailLoginViewModel;
  String imageName = "";
  String imageUrl = "";
  String serviceProviderBannerName = "";
  final TextEditingController priceController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();
  final TextEditingController serviceNameController = TextEditingController();
  final ApiService servicesAPI = ApiService();
  final picker = ImagePicker();
  bool uploading = false;
  bool isLoading = false;
  List<ServiceProviderImage> salonProviderImages = [];
  List<ServiceProviderBanner> salonProviderBanners = [];
  List<ServiceModel> servicesList = [];

  Map<String, List<Map<String, String>>> services = {
    'Women': [],
    'Men': [],
    'Kids': [],
  };

  fetchData() async {
    isLoading = true;
    notifyListeners();
    // try {
      await fetchProviderImages();
      await fetchProviderBanner();
      await fetchServices();

      for (var service in servicesList) {
        if (service.name != null) {
          final serviceEntry = {"name": service.name!};
          if (service.category == "Women") {
            services['Women']!.add(serviceEntry);
          } else if (service.category == "Men") {
            services['Men']!.add(serviceEntry);
          } else if (service.category == "Kids") {
            services['Kids']!.add(serviceEntry);
          }
        }
      }
    // } catch (error) {
    //   print("Error fetching provider data: $error");
    // }
    isLoading = false;
    notifyListeners();
  }

  Future<void> pickServiceProviderImage() async {
    final ImagePicker imagePicker = ImagePicker();
    try {
      final XFile? pickedFile =
          await imagePicker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        isLoading = true;
        notifyListeners();
        final Uint8List image = await pickedFile.readAsBytes();
        imageUrl = await uploadImageToServer(image);
        await servicesAPI.addServiceProviderImage(
            adminServiceProviderId, imageUrl);
        await fetchProviderImages();
      }
    } catch (e) {
      print("Error picking image: $e");
    }
    isLoading = false;
    notifyListeners();
  }

  Future<String> uploadImageToServer(Uint8List imageBytes) async {
    try {
      var request =
          http.MultipartRequest('POST', Uri.parse('$BASE_URL/upload_image'));
      request.files.add(http.MultipartFile.fromBytes(
        'image',
        imageBytes,
        filename: "upload_image.png",
      ));

      var response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final jsonResponse = jsonDecode(responseBody);

        imageUrl = jsonResponse['filePath'].split('/').last;
        print('Image uploaded successfully with file name: $imageUrl');
        return imageUrl;
      } else {
        throw Exception('Image upload failed');
      }
    } catch (e) {
      print('Error uploading image: $e');
      throw e;
    }
  }

  Future<void> pickServiceProviderBanner() async {
    final ImagePicker imagePicker = ImagePicker();
    try {
      final XFile? pickedFile =
          await imagePicker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        isLoading = true;
        notifyListeners();
        final Uint8List imageBytes = await pickedFile.readAsBytes();
        Size imageSize = await _getImageSize(imageBytes);

        if (imageSize.width <= imageSize.height) {
          CustomSnackBar.showSnackBar("Please select a rectangular image");
          return;
        }
        serviceProviderBannerName =
            await uploadImageServiceProviderBanner(imageBytes);
        await uploadServiceProviderBanner(
            adminServiceProviderId, serviceProviderBannerName);
        await fetchProviderBanner();
      }
    } catch (e) {
      print("Error picking image: $e");
    }
    isLoading = false;
    notifyListeners();
  }

  Future<String> uploadImageServiceProviderBanner(Uint8List imageBytes) async {
    try {
      var request =
          http.MultipartRequest('POST', Uri.parse('$BASE_URL/upload_image'));
      request.files.add(http.MultipartFile.fromBytes(
        'image', // The field name expected by the server
        imageBytes,
        filename:
            "upload_image.png", // Placeholder filename (server will rename)
      ));

      // Send the request
      var response = await request.send();

      // Handle the response
      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final jsonResponse = jsonDecode(responseBody);
        // Extract the file name from the server response
        serviceProviderBannerName = jsonResponse['filePath'].split('/').last;
        print(
            'Image uploaded successfully with file name: $serviceProviderBannerName');
        return serviceProviderBannerName;
      } else {
        throw Exception('Image upload failed');
      }
    } catch (e) {
      print('Error uploading image: $e');
      throw e;
    }
  }

  Future<void> addServices(
    String category,
    String name,
    String price,
  ) async {
    // Convert the price to double
    final parsedPrice = double.tryParse(price) ?? 0.0;

    final response = await servicesAPI.addService(
      category: category,
      name: serviceNameController.text,
      price: parsedPrice,
      imageUrl: imageName,
      serviceProviderId: adminServiceProviderId,
    );
    if (response.containsKey('error') && response['error'] == true) {
      print('Error: ${response['message']}');
    } else {
      services[category]?.add({
        'name': name,
        'price': price,
        'imageUrl': imageName,
      });
      print('Service added successfully!');
    }

    notifyListeners();
  }

  Future<void> pickImage() async {
    final ImagePicker imagePicker = ImagePicker();
    try {
      final XFile? pickedFile =
          await imagePicker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final Uint8List image = await pickedFile.readAsBytes();
        notifyListeners();
        print("Image picked successfully. Uploading...");
        await uploadImage(image);
        notifyListeners();
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  Future<String> uploadImage(Uint8List imageBytes) async {
    try {
      var request =
          http.MultipartRequest('POST', Uri.parse('$BASE_URL/upload_image'));
      request.files.add(http.MultipartFile.fromBytes(
        'image',
        imageBytes,
        filename: "upload_image.png",
      ));

      // Send the request
      var response = await request.send();

      // Handle the response
      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final jsonResponse = jsonDecode(responseBody);
        // Extract the file name from the server response
        imageName = jsonResponse['filePath'].split('/').last;
        print('Image uploaded successfully with file name: $imageName');
        return imageName;
      } else {
        print('Failed to upload image. Status code: ${response.statusCode}');
        throw Exception('Image upload failed');
      }
    } catch (e) {
      print('Error uploading image: $e');
      throw e;
    }
  }

  Future<bool> addServiceProviderImage(
      int serviceProviderId, String imageUrl) async {
    final success =
        await servicesAPI.addServiceProviderImage(serviceProviderId, imageUrl);
    if (success) {
      notifyListeners();
    }
    return success;
  }

  Future<bool> uploadServiceProviderBanner(
      int serviceProviderId, String imageUrl) async {
    final success = await servicesAPI.uploadServiceProviderBanner(
        serviceProviderId, imageUrl);
    if (success) {
      notifyListeners();
    }
    return success;
  }

  Future<void> fetchProviderImages() async {
    salonProviderImages =
        await servicesAPI.getServiceProviderImages(adminServiceProviderId);
    notifyListeners();
  }

  Future<void> fetchProviderBanner() async {
    salonProviderBanners =
        await servicesAPI.getServiceProviderBanner(adminServiceProviderId);
    notifyListeners();
  }

  Future<Size> _getImageSize(Uint8List imageBytes) async {
    final Completer<Size> completer = Completer();
    final Image image = Image.memory(imageBytes);
    image.image.resolve(ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo info, bool _) {
        completer.complete(
            Size(info.image.width.toDouble(), info.image.height.toDouble()));
      }),
    );
    return completer.future;
  }

  Future<void> fetchServices() async {
    servicesList = await servicesAPI.getServices(adminServiceProviderId);
    notifyListeners();
  }

  Future<void> deleteServiceProviderImage(int? salonImageId) async {
    if (salonImageId == null) return;
    isLoading = true;
    notifyListeners();
    bool success =
        await servicesAPI.deleteServiceProviderImageImage(salonImageId);
    if (success) fetchProviderImages();
    isLoading = false;
    notifyListeners();
  }

  Future<void> deleteSalonBanner(int? salonBannerId) async {
    if (salonBannerId == null) return;
    isLoading = true;
    notifyListeners();
    bool success = await servicesAPI.deleteSalonBanner(salonBannerId);
    if (success) fetchProviderBanner();
    isLoading = false;
    notifyListeners();
  }

  void clearProviderData() {
    print("salonServiceEdit is false, clearing all fields...");
    salonProviderImages = [];
    salonProviderBanners = [];
    services = {
      'Women': [],
      'Men': [],
      'Kids': [],
    };
    notifyListeners();
  }

  void refreshUI() {
    notifyListeners();
  }
}
