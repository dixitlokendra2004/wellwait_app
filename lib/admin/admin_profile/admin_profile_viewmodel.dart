import 'dart:convert';
import 'dart:typed_data'; // For Uint8List
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:wellwait_app/admin/utils/admin_%20common_variable.dart';
import '../../services/services.dart';
import '../../utils/constants.dart'; // Ensure BASE_URL is defined here

class AdminProfileViewModel extends ChangeNotifier {
  String adminImage = "";
  List<Uint8List> selectedAdminImages = [];
  final ApiService servicesAPI = ApiService();
  bool isLoading = false;


  Future<void> pickServiceProviderImage() async {
    try {
      final XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final Uint8List imageBytes = await pickedFile.readAsBytes();
        selectedAdminImages.add(imageBytes);
        notifyListeners();
        adminImage = await uploadImageToServer(imageBytes);
       // await uploadAdminImage(adminServiceProviderId,adminImage);
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  Future<String> uploadImageToServer(Uint8List imageBytes) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse('$BASE_URL/upload_image'));
      request.files.add(http.MultipartFile.fromBytes(
        'image', // Field name expected by the server
        imageBytes,
        filename: "upload_image.png",
      ));

      var response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(responseBody);
        adminImage = jsonResponse['filePath'].split('/').last;
        print('Image uploaded successfully: $adminImage');
        return adminImage;
      } else {
        print("Image upload failed: ${responseBody}");
        throw Exception('Image upload failed');
      }
    } catch (e) {
      print('Error uploading image: $e');
      throw e;
    }
  }

  void removeImage() {
    adminImage = "";
    selectedAdminImages.clear();
    notifyListeners();
  }

  // Future<bool> uploadAdminImage(int serviceProviderId, String imageUrl) async {
  //   isLoading = true;
  //   notifyListeners();
  //   final success = await servicesAPI.uploadAdminImage(serviceProviderId, imageUrl);
  //   if (success) {
  //     isLoading = false;
  //     notifyListeners();
  //   }
  //   return success;
  // }

  void refreshUI() {
    notifyListeners();
  }
}
