import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../utils/app_strings.dart';
import '../utils/app_text_style.dart';
import '../utils/colors.dart';
import '../utils/common_method.dart';
import '../utils/common_variables.dart';
import '../widget/custom_button.dart';
import '../widget/snack_bar_widget.dart';
import 'edit_profile_viewmodel.dart';

class EditProfilePage extends StatefulWidget {
  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late EditProfileViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _viewModel.nameController.text = userName;
      _viewModel.phoneController.text = userPhoneNumber ?? '';
      _viewModel.emailController.text = userEmail;
      _viewModel.selectedGender =
          userGender == 1 ? 'Male' : (userGender == 2 ? 'Female' : null);
      _viewModel.selectedDate = userBirthday;
      // _viewModel.imageName = userProfileImage;
      // print('User profile image: ${userProfileImage}');
      print('gender : ${userGender}');
      print('Birthday : ${userBirthday}');
      print("Profile image: ${userProfileImage}");
      _viewModel.refreshUI();
    });
  }

  @override
  Widget build(BuildContext context) {
    _viewModel = context.watch<EditProfileViewModel>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Center(
          child: Text(
            AppString.editProfile,
            style: AppTextStyle.getTextStyle18FontWeightw300,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Get.back();
            _viewModel.updateProfile();
          },
        ),
        backgroundColor: AppColors.primaryColor,
        actions: [
          Container(
            color: Colors.transparent,
            height: 20,
            width: 30,
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 250,
            child: Stack(
              children: [
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Container(
                          height: 50,
                          width: 50,
                          margin: const EdgeInsets.only(bottom: 50, left: 25),
                          child: Image.asset("assets/star.png",
                              height: 50, width: 50),
                        ),
                      ),
                      Container(
                        height: 50,
                        width: 50,
                        margin: const EdgeInsets.only(bottom: 50, left: 25),
                        child: Image.asset("assets/star.png",
                            height: 50, width: 50),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  top: 120,
                  left: (MediaQuery.of(context).size.width - 120) /
                      2, // Center horizontally
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: const BoxDecoration(
                          shape: BoxShape
                              .circle, // Use circle shape for circular container
                        ),
                        child: CachedNetworkImage(
                          imageUrl: getProfileImage(userProfileImage),
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              // Keep the circular shape
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          placeholder: (context, url) =>
                              const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) {
                            return const Icon(Icons.error);
                          },
                        ),
                      ),
                      Positioned(
                        bottom: 8,
                        child: Container(
                          width: 110,
                          padding: const EdgeInsets.all(8.0),
                          decoration: const BoxDecoration(
                            color: Colors.black26,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(60),
                              bottomRight: Radius.circular(60),
                            ),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              _viewModel.pickImage();
                            },
                            child: const Icon(
                              Icons.photo_camera,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 15, right: 15),
              child: SingleChildScrollView(
                child: Form(
                  key: _viewModel.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      buildTextField(
                        readonly: false,
                        label: AppString.yourName,
                        hintText: 'Enter name',
                        controller: _viewModel.nameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppString.enterName;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      buildTextField(
                        readonly: isPhoneAuth,
                        label: AppString.phoneNumber,
                        hintText: 'Enter phone number',
                        maxLength: 10,
                        controller: _viewModel.phoneController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppString.enterPhone;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      buildTextField(
                        readonly: !isPhoneAuth,
                        label: AppString.email,
                        hintText: 'Email',
                        controller: _viewModel.emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppString.enterEmail;
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return AppString.enterValidEmail;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Birthday",
                        style: AppTextStyle.getTextStyle18FontWeightBold,
                      ),
                      TextField(
                        readOnly: true,
                        onTap: () => _selectDate(context),
                        decoration: InputDecoration(
                          hintText: _viewModel.selectedDate == null
                              ? "Select Date"
                              : DateFormat("dd-MM-yyyy")
                                  .format(_viewModel.selectedDate!),
                          border: const UnderlineInputBorder(),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                        ),
                        style: const TextStyle(color: Colors.black),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        AppString.gender,
                        style: AppTextStyle.getTextStyle18FontWeightBold,
                      ),
                      DropdownButton<String>(
                        value: _viewModel.selectedGender,
                        hint: const Text("Select Gender"),
                        isExpanded: true,
                        items: ["Male", "Female"].map((String gender) {
                          return DropdownMenuItem<String>(
                            value: gender,
                            child: Text(gender),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            _viewModel.selectedGender = value;
                          });
                        },
                      ),
                      const SizedBox(height: 30),
                      Container(
                        width: double.infinity,
                        child: CustomButtonWidget(
                          text: AppString.save,
                          onPressed: () {
                            if (_viewModel.formKey.currentState!.validate()) {
                              if (_viewModel.selectedDate == null) {
                                CustomSnackBar.showSnackBar(
                                    'Please fill in the date');
                              } else if (_viewModel.selectedGender == null ||
                                  _viewModel.selectedGender!.isEmpty) {
                                CustomSnackBar.showSnackBar(
                                    'Please select the gender');
                              } else {
                                _viewModel.updateProfile();
                                // Call updateUserProfile after validating all fields
                                _viewModel.updateUserProfile().then((_) {
                                  Get.back();
                                  CustomSnackBar.showSnackBar(
                                      'Profile updated successfully!');
                                }).catchError((_) {
                                  CustomSnackBar.showSnackBar(
                                      'Failed to update profile.');
                                });
                              }
                            } else {
                              CustomSnackBar.showSnackBar(
                                  'Please fill in all fields correctly.');
                            }
                          },
                          buttonHeight: 50,
                          buttonColor: fabricColor,
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTextField({
    required String label,
    required String hintText,
    required TextEditingController controller,
    required String? Function(String?) validator,
    required bool readonly,
    int? maxLength,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyle.getTextStyle16FontWeightw600,
        ),
        TextFormField(
          readOnly: readonly,
          controller: controller,
          maxLength: maxLength,
          validator: validator,
          decoration: InputDecoration(
            hintText: hintText,
            contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
            hintStyle: TextStyle(color: Colors.grey.shade400),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            counterText: '',
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime initialDate = (_viewModel.selectedDate != null &&
        _viewModel.selectedDate!.isAfter(DateTime(2000)) &&
        _viewModel.selectedDate!.isBefore(DateTime(2100)))
        ? _viewModel.selectedDate!
        : DateTime.now();
    DateTime firstDate = DateTime.now().subtract(Duration(days: 365 * 100));
    DateTime lastDate = DateTime.now().subtract(Duration(days: 365 * 3));

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate:
      (initialDate.isBefore(firstDate) || initialDate.isAfter(lastDate))
          ? lastDate
          : initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.green, // Header background color
            hintColor: Colors.green, // Selected date circle color
            colorScheme: ColorScheme.light(
              primary: Colors.teal,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            buttonTheme: ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primaryColor,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null && pickedDate != _viewModel.selectedDate) {
      setState(() {
        _viewModel.selectedDate = pickedDate;
      });
    }
  }

}
