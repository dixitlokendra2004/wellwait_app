

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';

import '../../common_widgets/custom_button.dart';
import '../../utils/colors.dart';
import '../../widget/custom_textfield.dart';
import '../admin_email_login/admin_email_login_page.dart';
import '../admin_phone_number_login/admin_phone_number_page.dart';
import 'admin_register_viewmodel.dart';

class UserRegisterPage extends StatefulWidget {
  bool isGoogleAuth;
  String? email;
  String? phoneNumber;

  UserRegisterPage({
    super.key,
    required this.isGoogleAuth,
    this.email,
    this.phoneNumber,
  });
  @override
  State<UserRegisterPage> createState() => _UserRegisterPageState();
}
class _UserRegisterPageState extends State<UserRegisterPage> {
  late AdminRegisterViewModel _viewModel;
  @override
  Widget build(BuildContext context) {
    _viewModel = context.watch<AdminRegisterViewModel>();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                const SizedBox(height: 15),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.only(top: 15),
                    child: IconButton(
                      onPressed: () => Get.back(),
                      icon: Icon(Icons.arrow_back_ios_new_rounded),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: SvgPicture.asset(
                    'assets/registration.svg',
                    height: MediaQuery.of(context).size.height * 0.25,
                  ),
                ),
                const SizedBox(height: 30),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.70,
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    decoration: const BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: SizedBox(
                        child: Form(
                          key: _viewModel.formKey1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 25),
                              const Text(
                                'Create Your Account',
                                style: TextStyle(
                                  color: primaryColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 5),
                              const Text(
                                'Make sure your account keep secure',
                                style: TextStyle(color: hintTextColor, fontSize: 14),
                              ),
                              const SizedBox(height: 18),
                              // CustomTextField(
                              //   controller: _viewModel.emailAddressController,
                              //   hintText: 'Enter your email',
                              //   title: "Email address",
                              //   titleColor: fabricColor,
                              //   borderRadius: 25,
                              //   borderColor: fabricColor,
                              //   borderWidth: 1,
                              //   textFieldColor: const Color(0xFFE0F7F8),
                              //   validator: (value) {
                              //     if (value == null || value.isEmpty) {
                              //       return 'Please enter your email';
                              //     }
                              //     if (!value.contains('@')) {
                              //       return 'Please enter a valid email';
                              //     }
                              //     return null;
                              //   },
                              // ),
                              // const SizedBox(height: 18),
                              // CustomTextField(
                              //   controller: _viewModel.passwordController,
                              //   hintText: 'Enter Password',
                              //   title: "Password",
                              //   titleColor: fabricColor,
                              //   borderRadius: 25,
                              //   borderColor: fabricColor,
                              //   borderWidth: 1,
                              //   textFieldColor: const Color(0xFFE0F7F8),
                              //   obscureText: _viewModel.obscurePassword,
                              //   showPasswordToggle: true,
                              //   iconSize: 20,
                              //   validator: (value) {
                              //     if (value == null || value.isEmpty) {
                              //       return 'Please enter your Password';
                              //     }
                              //     return null; // Valid input
                              //   },
                              // ),
                              CustomTextField(
                                controller: _viewModel.nameController,
                                hintText: 'Enter your username',
                                title: "Full name",
                                titleColor: fabricColor,
                                borderRadius: 25,
                                borderColor: fabricColor,
                                borderWidth: 1,
                                textFieldColor: const Color(0xFFE0F7F8),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your name';
                                  }
                                  return null; // Valid input
                                },
                              ),
                              const SizedBox(height: 18),
                              Visibility(
                                visible: !widget.isGoogleAuth,
                                child: CustomTextField(
                                  controller: _viewModel.emailAddressController,
                                  hintText: 'Enter your email',
                                  title: "Email address",
                                  titleColor: fabricColor,
                                  borderRadius: 25,
                                  borderColor: fabricColor,
                                  borderWidth: 1,
                                  textFieldColor: const Color(0xFFE0F7F8),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your email';
                                    }
                                    if (!value.contains('@')) {
                                      return 'Please enter a valid email';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(height: 18),
                              SizedBox(
                                width: double.infinity,
                                child: CustomButton(
                                  text: 'Create Account',
                                  color: primaryColor,
                                  textColor: Colors.white,
                                  isBordered: false,
                                  onPressed: () {
                                    // Handle OTP send logic
                                    if (_viewModel.formKey1.currentState!.validate()) {
                                      _viewModel.registerAdminPartner(
                                        widget.isGoogleAuth,
                                        widget.email,
                                        widget.phoneNumber
                                      );
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(height: 18),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
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
      ),
    );
  }
}
