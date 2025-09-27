import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import 'package:wellwait_app/admin/admin_otp_verification/admin_otp_verification_page.dart';
import 'package:wellwait_app/phone_number_login/phone_number_login_page.dart';
import '../../common_widgets/custom_button.dart';
import '../../utils/app_strings.dart';
import '../../utils/app_text_style.dart';
import '../../utils/colors.dart';
import '../../widget/snack_bar_widget.dart';
import '../admin_register/admin_register_page.dart';
import 'admin_auth_viewmodel.dart';

class AdminPhoneNumberPage extends StatefulWidget {
  const AdminPhoneNumberPage({Key? key}) : super(key: key);

  @override
  State<AdminPhoneNumberPage> createState() => _AdminPhoneNumberPageState();
}

class _AdminPhoneNumberPageState extends State<AdminPhoneNumberPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isLoading = false;
  String selectedCountryCode = '+91';
  String verificationId = '';
  final FocusNode phoneFocusNode = FocusNode();
  late AdminAuthViewModel _viewModel;
  late FirebaseAuth auth;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  @override
  void initState() {
    super.initState();
    auth = FirebaseAuth.instance;
    phoneFocusNode.addListener(() {
      setState(() {});
    });
    // context.read<AdminPhoneNumberViewModel>().tryAutoLogin();
  }

  // @override
  // void dispose() {
  //   _viewModel.phoneNumberController.dispose();
  //   phoneFocusNode.dispose();
  //   super.dispose();
  // }
  @override
  Widget build(BuildContext context) {
    _viewModel = context.watch<AdminAuthViewModel>();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.only(top: 15),
                    child: IconButton(
                      // onPressed: () => Get.back(),
                      onPressed: () {
                        //Get.to(() => PhoneNumberLoginPage());
                        Get.offAll(() => PhoneNumberLoginPage());
                      },
                      icon: Icon(Icons.arrow_back_ios_new_rounded),
                    ),
                  ),
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.end,
                //   children: [
                //     TextButton(
                //       onPressed: () {
                //         // Get.to(() => EmailLoginPage());
                //         Get.to(() => const PhoneNumberLoginPage());
                //         _viewModel.phoneNumberController.text = '';
                //       },
                //       child: const Text(
                //         'Skip',
                //         style: TextStyle(
                //           color: primaryColor,
                //           fontSize: 16,
                //           fontWeight: FontWeight.w500,
                //         ),
                //       ),
                //     ),
                //     const SizedBox(width: 6),
                //   ],
                // ),
                const SizedBox(height: 30),
                Center(
                  child: SvgPicture.asset(
                    'assets/login.svg',
                    height: MediaQuery.of(context).size.height * 0.30,
                  ),
                ),
                const SizedBox(height: 30),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: secondaryColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppString.adminLoginYourAccount,
                              style: AppTextStyle.getTextStyle16FontWeightw700PrimaryColor,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Make sure that you already have an account',
                              maxLines: 2,
                              style: AppTextStyle
                                  .getTextStyle14FontWeightHintTextColor,
                            ),
                            const SizedBox(height: 20),
                            Text("Phone number",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w700,color: fabricColor),),
                            SizedBox(height: 8),
                            IntlPhoneField(
                              controller: _viewModel.phoneNumberController,
                              focusNode: phoneFocusNode,
                              initialCountryCode: 'IN',
                              onChanged: (phone) {
                                selectedCountryCode = phone.countryCode;
                              },
                              decoration: InputDecoration(
                                hintText: 'Enter Your Number',
                                hintStyle: TextStyle(
                                  color: Color(0xff9EA1AE),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(color: Colors.teal),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(color: Colors.teal),
                                ),
                                counterText: "",
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly, // Allows only digits
                                LengthLimitingTextInputFormatter(15),   // Max length: 15 digits
                              ],
                            ),
                            const SizedBox(height: 15),
                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (formKey.currentState?.validate() ?? false) {
                                    FocusScope.of(context).unfocus();
                                    if(_viewModel.phoneNumberController.text.isEmpty) {
                                      CustomSnackBar.showSnackBar("Please enter a phone number");
                                    } else {
                                      sendOtp();
                                    }
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.teal,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                child: const Text('Send OTP',
                                    style: TextStyle(fontWeight: FontWeight.w700,fontSize: 14)),
                              ),
                            ),
                            // const SizedBox(height: 8),
                            // Align(
                            //   alignment: Alignment.topRight,
                            //   child: TextButton(
                            //     onPressed: () {
                            //       Get.to(() => const AdminRegisterPage());
                            //     },
                            //     child: Text(
                            //       AppString.signUp,
                            //       style: AppTextStyle.getTextStyle13FontWeight,
                            //     ),
                            //   ),
                            // ),
                            const SizedBox(height: 18),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 0.5,
                                  width:
                                      MediaQuery.of(context).size.width * 0.40,
                                  color: Colors.black,
                                ),
                                Text(
                                  AppString.or,
                                  style: const TextStyle(color: hintTextColor),
                                ),
                                Container(
                                  height: 0.5,
                                  width:
                                      MediaQuery.of(context).size.width * 0.40,
                                  color: Colors.black,
                                ),
                              ],
                            ),
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
                            const SizedBox(height: 10),
                            CustomButton(
                              isBordered: true,
                              iconWidget: SvgPicture.asset('assets/google.svg'),
                              text: AppString.loginWithGoogle,
                              onPressed: () async {
                                await signInWithGoogle();
                              },
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (isLoading)
            Center(
              child: Container(
                color: Colors.transparent,
                child: const CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  sendOtp() async {
    if (!formKey.currentState!.validate()) return;
    final phoneNumber =
        '$selectedCountryCode${_viewModel.phoneNumberController.text.trim()}';
    // Show loading spinner
    setState(() {
      isLoading = true;
    });
    try {
      // Start phone number verification
      await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential);
          setState(() {
            isLoading = false;
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          CustomSnackBar.showSnackBar('Verification failed: ${e.message}');
          setState(() {
            isLoading = false;
          });
        },
        codeSent: (String verId, int? resendToken) {
          setState(() {
            verificationId = verId;
            isLoading = false;
          });
          // Navigate to OTP verification page
          Get.to(() => AdminOTPVerificationPage(
                verificationId: verificationId,
                phoneNumber: phoneNumber,
              ));
          setState(() {
            isLoading = false;
          });
        },
        codeAutoRetrievalTimeout: (String verId) {
          verificationId = verId;
        },
      );
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      CustomSnackBar.showSnackBar('Error: $e'); // Show error snackbar
    }
  }

  signInWithGoogle() async {
    // Show loading spinner for Google login
    setState(() {
      _viewModel.isGoogleLoginInProgress = true;
    });

    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        setState(() {
          _viewModel.isGoogleLoginInProgress = false;
        });
        return null;
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      UserCredential userCredential =
          await auth.signInWithCredential(credential);
      final firebaseUser = userCredential.user;
      await _viewModel.loginAdminEmailPartner(firebaseUser?.email ?? '');
      setState(() {
        _viewModel.isGoogleLoginInProgress = false;
      });
      return firebaseUser;
    } catch (e) {
      setState(() {
        _viewModel.isGoogleLoginInProgress = false;
      });
      print("Error signing in with Google: $e");
      return null;
    }
  }
}

class CustomPhoneInput extends StatelessWidget {
  final TextEditingController controller;
  final Function(Country) onCountryChanged;

  const CustomPhoneInput({
    Key? key,
    required this.controller,
    required this.onCountryChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntlPhoneField(
      controller: controller,
      enabled: true,
      decoration: InputDecoration(
        hintText: AppString.enterYourNumber,
        hintStyle: const TextStyle(color: hintTextColor, ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.teal),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.teal),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.teal, width: 1),
        ),
        filled: true,
        fillColor: primaryColor,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      ),
      initialCountryCode: 'IN',
      validator: null,
      onChanged: (phone) {
        controller.text = phone.number;
      },
      onCountryChanged: onCountryChanged,
      style: const TextStyle(color: Colors.black),
    );
  }
}
