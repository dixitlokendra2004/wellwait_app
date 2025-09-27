import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../services/services.dart';
import '../utils/common_variables.dart';
import '../utils/constants.dart';
import '../utils/sp_helper.dart';
import 'package:image/image.dart' as img;

class EditProfileViewModel extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController birthdayController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  String? selectedGender;
  DateTime? selectedDate;
  bool uploading = false;
  Uint8List? selectedImage;

  //String imageName = "";
  final ApiService servicesAPI = ApiService();

  Future<void> pickImage() async {
    final ImagePicker imagePicker = ImagePicker();
    try {
      final XFile? pickedFile =
          await imagePicker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final Uint8List image = await pickedFile.readAsBytes();
        selectedImage = image;
        notifyListeners();
        await uploadImage();
        await userUploadImage(userProfileImage);
        notifyListeners();
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  Future<void> uploadImage() async {
    if (selectedImage == null) {
      print("No image selected");
      return;
    }

    try {
      var uri = Uri.parse('$BASE_URL/upload_image');
      var request = http.MultipartRequest('POST', uri);

      // Add the selected image file
      request.files.add(http.MultipartFile.fromBytes(
        'image', // Field name in the backend
        selectedImage!,
        filename: 'uploaded_image.jpg', // Optional: set filename
      ));

      // Send the request
      var response = await request.send();
      var responseString = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final responseData = jsonDecode(responseString);
        print("uploadImage responseData = ${jsonEncode(responseData)}");
        // Extract file name from the response
        if (responseData.containsKey('filePath')) {
          final filePath = responseData['filePath'].toString();
          userProfileImage = filePath.split('/').last;
          notifyListeners();
        }
      } else {
        print("Failed to upload image: $responseString");
      }
    } catch (error) {
      print("Error occurred while uploading image: $error");
    }
    notifyListeners();
  }

  Future<bool> userUploadImage(String photo) async {
    final success = await servicesAPI.updateUserPhoto(photo);
    if (success) {
      notifyListeners(); // Update UI if needed
    }
    return success;
  }

  Future<void> updateUserProfile() async {
    final url = Uri.parse('$BASE_URL/update_user/$userId');
    String? formattedDate = selectedDate != null
        ? DateFormat('yyyy-MM-dd').format(selectedDate!)
        : '';
    int? genderValue =
        selectedGender == 'Male' ? 1 : (selectedGender == 'Female' ? 2 : null);
    final data = {
      'email': emailController.text,
      'username': nameController.text,
      'phone_number': phoneController.text,
      'birthday': formattedDate,
      'gender': genderValue,
      'photo': userProfileImage,
    };
    try {
      // Send the PUT request
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(data), // Encode data as JSON
      );
      if (response.statusCode == 200) {
        print('User profile updated successfully');
        notifyListeners();
      } else {
        // Handle server error (e.g., 400, 500)
        print('Failed to update profile. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error updating profile: $error');
    } finally {
      notifyListeners();
    }
  }

  Future<void> updateProfile() async {
    final SharedPreferenceService _sharedPreferenceService =
        SharedPreferenceService();
    userName = nameController.text;
    userEmail = emailController.text;
    userPhoneNumber = phoneController.text;
    userBirthday = selectedDate;
    userGender =
        selectedGender == "Male" ? 1 : (selectedGender == "Female" ? 2 : null);
    await _sharedPreferenceService.saveUserInfo();
    print("updated value username: ${userName}");
    print("updated value userEmail: ${userEmail}");
    print("updated value userPhoneNumber: ${userPhoneNumber}");
    print("updated value userBirthday: ${userBirthday}");
    print("updated value userGender: ${userGender}");
    print("upload value image userProfileImage: ${userProfileImage}");
    notifyListeners();
  }

  void refreshUI() {
    notifyListeners();
  }
}
