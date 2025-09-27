import 'dart:convert';
import 'dart:io';
import 'dart:typed_data'; // For Uint8List
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // For mobile image picker
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:wellwait_app/admin/utils/admin_%20common_variable.dart';
import '../../models/service_provider_model.dart';
import '../../services/services.dart'; // Custom service API
import '../../utils/constants.dart';
import '../../widget/snack_bar_widget.dart';

class SalonDocumentsViewModel extends ChangeNotifier {
  final TextEditingController panNumberController = TextEditingController();
  final TextEditingController gstinController = TextEditingController();
  final TextEditingController accountNumberController = TextEditingController();
  final TextEditingController bankCodeController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool showProgressbar = false;
  bool isChecked = false;
  final ApiService services = ApiService();
  String? panImageName;
  String? documentsImageName;
  String? gstinImageName;
  final ApiService servicesAPI = ApiService();
  ServicesProvider? serviceProviderDocument;
  bool isLoading = false;

  Future<void> updateData(BuildContext context) async {
    showProgressbar = true;
    notifyListeners();
    final int? originalId = adminServiceProviderId;
    final response = await services.updateServiceProviderDocuments(
      id: originalId!,
      panCard: panNumberController.text,
      gstIn: gstinController.text,
      bankAccountNumber: accountNumberController.text,
      bankIfscCode: bankCodeController.text,
    );
    if (response.containsKey('error') && response['error'] == true) {
      CustomSnackBar.showSnackBar("Failed!");
    } else {
      CustomSnackBar.showSnackBar("Complete!");
    }
    showProgressbar = false;
    notifyListeners();
  }

  Future<void> pickServiceProviderPanCardImage() async {
    final ImagePicker imagePicker = ImagePicker();
    try {
      final XFile? pickedFile =
          await imagePicker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final Uint8List image = await pickedFile.readAsBytes();
        notifyListeners();
        String imageName = await uploadImageServiceProviderBanner(image);
        if (imageName.isNotEmpty) {
          notifyListeners();
        }
        await uploadPanCardImages(adminServiceProviderId, imageName);
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  Future<String> uploadImageServiceProviderBanner(Uint8List imageBytes) async {
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
        String imageName = jsonResponse['filePath'].split('/').last;
        return imageName;
      } else {
        throw Exception('Image upload failed');
      }
    } catch (e) {
      print('Error uploading image: $e');
      throw e;
    }
  }

  Future<bool> uploadPanCardImages(int id, String panCardImage) async {
    final success = await servicesAPI.uploadPanCardImage(id, panCardImage);
    if (success) {
      fetchServiceProviderDocuments();
    }
    return success;
  }

  Future<void> pickServiceProviderDocumentsImage() async {
    final ImagePicker imagePicker = ImagePicker();
    try {
      final XFile? pickedFile =
          await imagePicker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final Uint8List image = await pickedFile.readAsBytes();
        notifyListeners();
        String imageName = await uploadImageServiceProviderDocuments(image);
        if (imageName.isNotEmpty) {
          documentsImageName = imageName;
          notifyListeners();
        }
        await uploadDocumentImages(adminServiceProviderId, imageName);
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  Future<String> uploadImageServiceProviderDocuments(
      Uint8List imageBytes) async {
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
        String imageName = jsonResponse['filePath'].split('/').last;
        return imageName;
      } else {
        throw Exception('Image upload failed');
      }
    } catch (e) {
      print('Error uploading image: $e');
      throw e;
    }
  }

  Future<bool> uploadDocumentImages(int id, String documentImage) async {
    final success = await servicesAPI.uploadDocumentsImage(id, documentImage);
    if (success) {
      notifyListeners();
    }
    return success;
  }

  Future<void> fetchServiceProviderDocuments() async {
    showProgressbar = true;
    notifyListeners();
    try {
      final ServicesProvider? response =
          await servicesAPI.fetchBankDetails(adminServiceProviderId);
      if (response != null) {
        serviceProviderDocument = response;

        final serviceProvider = serviceProviderDocument!;
        panNumberController.text = serviceProvider.panCard ?? "";
        gstinController.text = serviceProvider.gstIn ?? "";
        accountNumberController.text = serviceProvider.bankAccountNumber ?? "";
        bankCodeController.text = serviceProvider.bankIfscCode ?? "";
        panImageName = serviceProvider.panCardImage ?? "";
        documentsImageName = serviceProvider.documentImage ?? "";
        notifyListeners();
      } else {
        print("No service provider document found.");
        clearServiceProviderDocuments();
      }
    } catch (e) {
      print("Error fetching Info: $e");
      serviceProviderDocument = null;
    }
    showProgressbar = false;
    notifyListeners();
  }

  void clearServiceProviderDocuments() {
    panNumberController.clear();
    gstinController.clear();
    accountNumberController.clear();
    bankCodeController.clear();
    panImageName = "";
    documentsImageName = "";
    notifyListeners();
  }

  Future<void> deletePanImage() async {
    isLoading = true;
    notifyListeners();
    try {
      bool success = await servicesAPI.deletePanImage(adminServiceProviderId);
      if (success) {
        // selectedServiceProviderImage.clear();
        // CustomSnackBar.showSnackBar("PAN image remove successfully");
        fetchServiceProviderDocuments();
        notifyListeners();
      }
    } catch (e) {
      CustomSnackBar.showSnackBar("catch Error: ${e}");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteDocumentImage() async {
    isLoading = true;
    notifyListeners();
    try {
      bool success =
          await servicesAPI.deleteDocumentImage(adminServiceProviderId);
      if (success) {
        fetchServiceProviderDocuments();
      }
    } catch (e) {
      CustomSnackBar.showSnackBar("catch Error: ${e}");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void refreshUI() {
    notifyListeners();
  }
}
