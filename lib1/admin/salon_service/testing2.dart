import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../../utils/constants.dart'; // Add this package

class ImageUploadWeb extends StatefulWidget {
  @override
  _ImageUploadWebState createState() => _ImageUploadWebState();
}

class _ImageUploadWebState extends State<ImageUploadWeb> {
  Uint8List? _selectedImage;

  // Function to pick image
  Future<void> pickImage() async {
    final ImagePicker imagePicker = ImagePicker();
    try {
      final XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final Uint8List image = await pickedFile.readAsBytes();
        setState(() {
          _selectedImage = image;
        });
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  // Function to upload image
  Future<void> uploadImage() async {
    if (_selectedImage == null) {
      print("No image selected");
      return;
    }
    var uri = Uri.parse('$BASE_URL/upload_image');
    var request = http.MultipartRequest('POST', uri);

    // Add the selected image file
    request.files.add(http.MultipartFile.fromBytes(
      'image',  // Must match the field name in the Node.js backend
      _selectedImage!, // Convert File to bytes
      filename: 'uploaded_image.jpg',
    ));

    try {
      // Send the request
      var response = await request.send();
      var responseString = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        print("Image uploaded successfully: $responseString");
      } else {
        print("Failed to upload image: $responseString");
      }
    } catch (error) {
      print("Error occurred: $error");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload Image"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _selectedImage != null
                ? Image.memory(_selectedImage!)
                : Text("No image selected"),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: pickImage,
              child: Text("Pick Image"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: uploadImage,
              child: Text("Upload Image"),
            ),
          ],
        ),
      ),
    );
  }
}
