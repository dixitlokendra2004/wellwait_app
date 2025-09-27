import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';

import '../../common_widgets/custom_button.dart';
import '../../email_login/email_login_page.dart';
import '../../phone_number_login/phone_number_login_page.dart';
import '../../utils/app_strings.dart';
import '../../utils/app_text_style.dart';
import '../../utils/colors.dart';
import '../../widget/custom_textfield.dart';
import '../admin_register/admin_register_page.dart';
import 'admin_email_login_viewmodel.dart';

class AdminEmailLoginPage extends StatefulWidget {
  AdminEmailLoginPage({super.key});
  @override
  State<AdminEmailLoginPage> createState() => _AdminEmailLoginPageState();
}
class _AdminEmailLoginPageState extends State<AdminEmailLoginPage> {
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminEmailLoginViewModel>().tryAutoLogin();
    });
  }
  @override
  Widget build(BuildContext context) {
    final _viewModel = context.watch<AdminEmailLoginViewModel>();
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                       // Get.to(() => EmailLoginPage());
                        Get.to(() => PhoneNumberLoginPage());
                      },
                      child: const Text(
                        'Skip',
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                  ],
                ),
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
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                  ),
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
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            CustomTextField(
                              controller: _viewModel.emailAddressController,
                              hintText: AppString.enterYourEmail,
                              title: AppString.enterYourEmail,
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
                            const SizedBox(height: 15),
                            CustomTextField(
                              controller: _viewModel.passwordController,
                              hintText: AppString.enterYourPassword,
                              title: AppString.enterYourPassword,
                              titleColor: fabricColor,
                              borderRadius: 25,
                              borderColor: fabricColor,
                              borderWidth: 1,
                              textFieldColor: const Color(0xFFE0F7F8),
                              obscureText: _viewModel.obscurePassword,
                              showPasswordToggle: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your Password';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: CustomButton(
                          text: AppString.login,
                          color: primaryColor,
                          textColor: Colors.white,
                          isBordered: false,
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _viewModel.loginAdminPartner(context);
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 6),
                      Align(
                        alignment: Alignment.topRight,
                        child: TextButton(
                          onPressed: () {
                           // Get.to(() => const AdminRegisterPage());
                          },
                          child: Text(
                            AppString.signUp,
                            style: AppTextStyle.getTextStyle13FontWeight,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 0.5,
                            width: MediaQuery.of(context).size.width * 0.40,
                            color: Colors.black,
                          ),
                          Text(AppString.or, style: const TextStyle(color: hintTextColor)),
                          Container(
                            height: 0.5,
                            width: MediaQuery.of(context).size.width * 0.40,
                            color: Colors.black,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      CustomButton(
                        text: AppString.continueWithEmail,
                        icon: Icons.email_outlined,
                        isBordered: true,
                        onPressed: () { },
                        color: Colors.white,
                      ),
                      const SizedBox(height: 10),
                      CustomButton(
                        isBordered: true,
                        iconWidget: SvgPicture.asset('assets/google.svg'),
                        text: AppString.loginWithGoogle,
                        onPressed: () { },
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (_viewModel.showProgressbar)
            Center(
              child: Container(
                height: 40,
                width: 40,
                color: Colors.transparent,
                child: const CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}

