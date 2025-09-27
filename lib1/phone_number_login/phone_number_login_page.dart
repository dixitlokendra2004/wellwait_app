import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import 'package:wellwait_app/phone_number_login/phone_number_login_viewmodel.dart';
import '../admin/admin_phone_number_login/admin_phone_number_page.dart';
import '../common_widgets/custom_button.dart';
import '../otp_verification/otp_verification_page.dart';
import '../utils/app_strings.dart';
import '../utils/app_text_style.dart';
import '../utils/colors.dart';
import '../widget/snack_bar_widget.dart';

class PhoneNumberLoginPage extends StatefulWidget {
  const PhoneNumberLoginPage({Key? key}) : super(key: key);
  @override
  State<PhoneNumberLoginPage> createState() => _PhoneNumberLoginPageState();
}
class _PhoneNumberLoginPageState extends State<PhoneNumberLoginPage> {
  final TextEditingController phoneController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isLoading = false;
  String selectedCountryCode = '+91';
  late FirebaseAuth auth;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  String verificationId = '';
  final FocusNode phoneFocusNode = FocusNode();
  late PhoneNumberLoginViewModel _viewModel;
  @override
  void initState() {
    super.initState();
    auth = FirebaseAuth.instance;
    phoneFocusNode.addListener(() {
      setState(() {});
    });
  }
  @override
  void dispose() {
    phoneController.dispose();
    phoneFocusNode.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    _viewModel = context.watch<PhoneNumberLoginViewModel>();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: Column(
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
                    child: Form(
                      key: formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppString.loginYourAccount,
                              style: AppTextStyle.getTextStyle16FontWeightw700PrimaryColor,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Make sure that you already have an account',
                              maxLines: 2,
                              style: AppTextStyle.getTextStyle14FontWeightHintTextColor,
                            ),
                            const SizedBox(height: 20),
                            Text(
                              "Phone number",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: fabricColor),
                            ),
                            const SizedBox(height: 8),
                            IntlPhoneField(
                              controller: phoneController,
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
                              validator: (value) {
                                if (value == null || value.completeNumber.isEmpty) {
                                  return 'Please enter a valid phone number';
                                }
                                if(value.number.length > 10) {
                                  return 'Enter a valid 10-digit phone number';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (formKey.currentState?.validate() ?? false) {
                                    FocusScope.of(context).unfocus();
                                    if(phoneController.text.isEmpty) {
                                      CustomSnackBar.showSnackBar("Please enter phone number");
                                    } else {
                                      _sendOtp();
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
                                child: const Text(
                                  'Send OTP',
                                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: GestureDetector(
                                onTap: () {
                                  Get.to(() => const AdminPhoneNumberPage());
                                },
                                child: Row(
                                  children: [
                                    Icon(Icons.person,
                                        color: AppColors.primaryColor, size: 20),
                                    SizedBox(width: 6),
                                    Text(
                                      AppString.loginWithPartner,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.primaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 18),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 0.5,
                                  width: MediaQuery.of(context).size.width * 0.40,
                                  color: Colors.black,
                                ),
                                Text(
                                  AppString.or,
                                  style: const TextStyle(color: hintTextColor),
                                ),
                                Container(
                                  height: 0.5,
                                  width: MediaQuery.of(context).size.width * 0.40,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            CustomButton(
                              isBordered: true,
                              iconWidget: SvgPicture.asset('assets/google.svg'),
                              text: AppString.loginWithGoogle,
                              onPressed: () async {
                                final user = await signInWithGoogle();
                                if (user != null) {
                                  print("Logged in as ${user.displayName}");
                                }
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


  Future<void> _sendOtp() async {
    if (!formKey.currentState!.validate()) return;
    final phoneNumber = '$selectedCountryCode${phoneController.text.trim()}';

    // Show progress bar
    setState(() {
      isLoading = true;
    });

    try {
      await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential);
          setState(() { isLoading = false; });
        },
        verificationFailed: (FirebaseAuthException e) {
          setState(() { isLoading = false; });
        },
        codeSent: (String verId, int? resendToken) {
          setState(() {
             verificationId = verId;
            isLoading = false;
          });
          Get.to(() => OTPVerificationPage(
            verificationId: verificationId,
            phoneNumber: phoneNumber,
          ));
        },
        codeAutoRetrievalTimeout: (String verId) {
          verificationId = verId;
          setState(() { isLoading = false; });
        },
      );
    } catch (e) {
      setState(() { isLoading = false; });
    }
  }


  Future<User?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      setState(() {_viewModel.showProgressBar = true;});
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      print("user: ${googleUser}");
      if (googleUser == null) {
        return null;
      }
      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      // Create a new credential
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      setState(() {_viewModel.showProgressBar = false;});

      // Sign in to Firebase with the Google credentials
      UserCredential userCredential =
      await auth.signInWithCredential(credential);
      final firebaseUser = userCredential.user;
      setState(() {_viewModel.showProgressBar = false;});

      // Check if the user email exists in the database
      final responseBody = await _viewModel.loginEmail(firebaseUser?.email ?? '');
      if (responseBody['email'] == null || responseBody['email'].isEmpty) {
        CustomSnackBar.showSnackBar("Email not found");
        return null; // Stop further execution if email not found in database
      }
      setState(() {_viewModel.showProgressBar = false;});

      return firebaseUser;
    } catch (e) {
      print("Error signing in with Google: $e");
      setState(() {_viewModel.showProgressBar = false;});
      return null;
    } finally {
      setState(() {_viewModel.showProgressBar = false;});
    }
  }


  Future<void> signOut() async {
    await googleSignIn.signOut();
    await auth.signOut();
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
        hintStyle: TextStyle(color: hintTextColor, ),
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
        fillColor: secondaryColor,
        contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
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
