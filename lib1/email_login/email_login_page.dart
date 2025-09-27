import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import '../../common_widgets/custom_button.dart';
import '../../utils/colors.dart';
import '../Screens/registration/registration_screen.dart';
import '../admin/admin_email_login/admin_email_login_page.dart';
import '../utils/app_strings.dart';
import '../utils/app_text_style.dart';
import '../widget/bottom_bar_widget.dart';
import '../widget/custom_textfield.dart';
import '../widget/snack_bar_widget.dart';
import 'email_login_viewmodel.dart';

class EmailLoginPage extends StatefulWidget {
  EmailLoginPage({super.key});
  @override
  State<EmailLoginPage> createState() => _EmailLoginPageState();
}
class _EmailLoginPageState extends State<EmailLoginPage> {
  late EmailLoginViewModel _viewModel;
  final formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    _viewModel = context.watch<EmailLoginViewModel>();
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
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
                  height: MediaQuery.of(context).size.height * 0.70,
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                  ),
                  child: Form(
                    key: formKey,
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
                          iconSize: 20,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your Password';
                            }
                            return null;
                          },
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
                              if (formKey.currentState!.validate()) {
                                //_viewModel.loginUser(context);
                                login();
                              }
                            },
                          ),
                        ),
                        //const SizedBox(height: 6),
                        // Padding(
                        //   padding: const EdgeInsets.only(left: 10),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //     children: [
                        //       GestureDetector(
                        //         onTap: () {
                        //           Get.to(() => AdminEmailLoginPage());
                        //         },
                        //         child: Text(
                        //           AppString.loginWithPartner,
                        //           style: AppTextStyle.getTextStyle13FontWeightw300B,
                        //         ),
                        //       ),
                        //       TextButton(
                        //         onPressed: () {
                        //           Get.to(() => RegistrationScreen());
                        //         },
                        //         child: Text(
                        //           AppString.signUp,
                        //           style: AppTextStyle.getTextStyle13FontWeight,
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     Container(
                        //       height: 0.5,
                        //       width: MediaQuery.of(context).size.width * 0.40,
                        //       color: Colors.black,
                        //     ),
                        //     Text(
                        //       AppString.or,
                        //       style: const TextStyle(color: hintTextColor),
                        //     ),
                        //     Container(
                        //       height: 0.5,
                        //       width: MediaQuery.of(context).size.width * 0.40,
                        //       color: Colors.black,
                        //     ),
                        //   ],
                        // ),
                        // const SizedBox(height: 10),
                        // CustomButton(
                        //   text: AppString.continueWithEmail,
                        //   icon: Icons.email_outlined,
                        //   isBordered: true,
                        //   onPressed: () {
                        //     // Handle Email login logic
                        //   },
                        //   color: Colors.white,
                        // ),
                        // const SizedBox(height: 10),
                        // CustomButton(
                        //   isBordered: true,
                        //   iconWidget: SvgPicture.asset('assets/google.svg'),
                        //   text: AppString.loginWithGoogle,
                        //   onPressed: () {
                        //     // Handle Google login logic
                        //   },
                        //   color: Colors.white,
                        // ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible: _viewModel.showProgressbar,
            child: Center(
              child: Container(
                height: 40,
                width: 40,
                color: Colors.transparent,
                child: const CircularProgressIndicator(),
              ),
            ),
          ),
        ],
      ),
    );
  }


  void login() async {
    setState(() {_viewModel.showProgressbar = true;});
    try {
      await _auth.signInWithEmailAndPassword(
        email: _viewModel.emailAddressController.text.trim(),
        password: _viewModel.passwordController.text.trim(),
      );
      CustomSnackBar.showSnackBar("Login successful!");
      Get.to(() => BottomBar());
      // Navigate to the home screen or another page
    } on FirebaseAuthException catch (e) {
      String message = e.message ?? 'An error occurred';
      CustomSnackBar.showSnackBar(message);
    } finally {
      setState(() {_viewModel.showProgressbar = false;});
    }
  }
}
