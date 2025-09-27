import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import '../../common_widgets/custom_button.dart';
import '../../utils/app_strings.dart';
import '../../utils/app_text_style.dart';
import '../../utils/colors.dart';
import '../../widget/custom_textfield.dart';
import '../admin_email_login/admin_email_login_page.dart';
import 'admin_login_viewmodel.dart';

class AdminLoginPage extends StatelessWidget {
  late AdminLoginViewModel _viewModel;

  AdminLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    _viewModel = context.watch<AdminLoginViewModel>();
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          LayoutBuilder(builder: (context, constraints) {
            return SingleChildScrollView( // Enable scrolling
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ), // Adjusts bottom padding dynamically
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 30),
                      Center(
                        child: SvgPicture.asset(
                          'assets/login.svg',
                          height: MediaQuery.of(context).size.height * 0.30,
                        ),
                      ),
                      const SizedBox(height: 30),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.70,
                        padding: const EdgeInsets.all(20),
                        decoration: const BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25),
                          ),
                        ),
                        child: Form(
                          key: _viewModel.formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppString.loginYourAccount,
                                style: AppTextStyle.getTextStyle18FontWeightw600PrimaryColor,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                AppString.makeSure,
                                style: AppTextStyle.getTextStyle14FontWeightHintTextColor,
                              ),
                              const SizedBox(height: 15),
                              CustomTextField(
                                controller: _viewModel.mobileNumberController,
                                hintText: "Enter Mobile number / Salon ID",
                                title: AppString.enterPhoneNumberOrSalonId,
                                titleColor: fabricColor,
                                borderRadius: 25,
                                borderColor: fabricColor,
                                borderWidth: 1,
                                textFieldColor: const Color(0xFFE0F7F8),
                                maxLength: 10,
                                validator: (value) {
                                  // Check if the input is empty
                                  if (value == null || value.isEmpty) {
                                    return AppString.pleaseEnterMobileNumberAndSalonId;
                                  }

                                  // Phone number validation (example: 10 digits)
                                  final phoneRegExp = RegExp(r'^\d{10}$'); // Adjust based on your needs
                                  if (phoneRegExp.hasMatch(value)) {
                                    return null; // Valid phone number
                                  }

                                  // Salon ID validation (you can customize this based on salon ID pattern)
                                  // Here assuming any alphanumeric string with length > 3 is valid
                                  final salonIdRegExp = RegExp(r'^[a-zA-Z0-9]{4,}$');
                                  if (salonIdRegExp.hasMatch(value)) {
                                    return null; // Valid salon ID
                                  }

                                  // If it doesn't match either validation
                                  return AppString.pleaseEnterValidMobileNumberAndSalonId;
                                },
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                width: double.infinity,
                                child: CustomButton(
                                  text: AppString.sendOTP,
                                  color: primaryColor,
                                  textColor: Colors.white,
                                  isBordered: false,
                                  onPressed: () {
                                    if (_viewModel.formKey.currentState!
                                        .validate()) {
                                     // Get.to(() => AdminOtpVerification());

                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //       builder: (context) =>
                                      //           AdminOtpVerification()),
                                      // );
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 0.5,
                                    width: MediaQuery.of(context).size.width *
                                        0.40,
                                    color: Colors.black,
                                  ),
                                  Text(
                                    AppString.or,
                                    style: const TextStyle(color: hintTextColor),
                                  ),
                                  Container(
                                    height: 0.5,
                                    width: MediaQuery.of(context).size.width *
                                        0.40,
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              CustomButton(
                                text: AppString.continueWithEmail,
                                icon: Icons.email_outlined,
                                isBordered: true,
                                onPressed: () {
                                  Get.to(() => AdminEmailLoginPage());

                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //       builder: (context) =>
                                  //           AdminEmailLoginPage()),
                                  // );
                                },
                                color: Colors.white,
                              ),
                              const SizedBox(height: 10),
                              CustomButton(
                                isBordered: true,
                                iconWidget:
                                SvgPicture.asset('assets/google.svg'),
                                text: AppString.loginWithGoogle,
                                onPressed: () {
                                  // Handle Google login logic
                                },
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
          Visibility(
            visible: _viewModel.showProgressbar,
            child: Center(
                child: Container(
                  height: 40,
                  width: 40,
                  color: Colors.transparent,
                  child: const CircularProgressIndicator(),
                )),
          ),
        ],
      ),
    );
  }
}
