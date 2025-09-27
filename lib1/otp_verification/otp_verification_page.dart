import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:wellwait_app/utils/app_text_style.dart';
import 'package:wellwait_app/utils/colors.dart';

import '../common_widgets/custom_button.dart';
import '../phone_number_login/phone_number_login_viewmodel.dart';
import '../widget/snack_bar_widget.dart';
import 'otp_verification_viewmodel.dart';

class OTPVerificationPage extends StatefulWidget {
  String verificationId;
  String phoneNumber;
  OTPVerificationPage(
      {super.key, required this.verificationId, required this.phoneNumber});

  @override
  _OTPVerificationPageState createState() => _OTPVerificationPageState();
}

class _OTPVerificationPageState extends State<OTPVerificationPage> {
  Timer? _timer;
  int _remainingTime = 30;
  bool _canResendOtp = false;
  late OtpVerificationViewModel _viewModel;
  late PhoneNumberLoginViewModel _phoneNumberLoginViewModel;
  TextEditingController _otpController = TextEditingController();
  String _otpCode = "";

  @override
  void initState() {
    super.initState();
    _startOtpTimer();
  }

  void _startOtpTimer() {
    setState(() {
      _canResendOtp = false;
      _remainingTime = 30;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        timer.cancel();
        setState(() {
          _canResendOtp = true;
        });
      }
    });
  }

  @override
  void dispose() {
    // _otpController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _viewModel = context.watch<OtpVerificationViewModel>();
    _phoneNumberLoginViewModel = context.watch<PhoneNumberLoginViewModel>();

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                const SizedBox(height: 20),
                Container(
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/verification.svg',
                      height: MediaQuery.of(context).size.height * 0.35,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: secondaryColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(14),
                        topRight: Radius.circular(14),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if (_otpController.text.isEmpty) {
                                    CustomSnackBar.showSnackBar(
                                        "Please enter OTP before going back.");
                                  } else {
                                    Get.back();
                                  }
                                },
                                child: const Icon(Icons.arrow_back),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'Verify Your Account',
                                style: AppTextStyle
                                    .getTextStyle16FontWeightw700PrimaryColor,
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          _buildInfoContainer(),
                          SizedBox(height: 20),
                          PinCodeTextField(
                            appContext: context,
                            length: 6,
                            obscureText: false,
                            animationType: AnimationType.fade,
                            pinTheme: PinTheme(
                              shape: PinCodeFieldShape.box,
                              borderRadius: BorderRadius.circular(12),
                              fieldHeight: 50,
                              fieldWidth: 45,
                              activeFillColor: Colors.white,
                              selectedColor: Colors.teal,
                              activeColor: Colors.teal,
                              inactiveColor: Colors.teal,
                            ),
                            textStyle: TextStyle(fontSize: 14,fontWeight: FontWeight.w500),
                            cursorColor: Colors.black,
                            backgroundColor: Colors.transparent,
                            enableActiveFill: false,
                            controller: _otpController,
                            keyboardType: TextInputType.number,
                            onChanged: (value) {},
                          ),
                          const SizedBox(height: 30),
                          CustomButton(
                            text: "Verify",
                            onPressed: _verifyOtp,
                            isBordered: false,
                            textColor: Colors.white,
                            color: primaryColor,
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: TextButton(
                              onPressed: _canResendOtp ? _resendOtp : null,
                              child: Text(
                                _canResendOtp
                                    ? "Resend OTP"
                                    : "Resend in $_remainingTime seconds",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: _canResendOtp
                                      ? Colors.black
                                      : Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (_viewModel.isLoading)
              const Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }

  void _verifyOtp() async {
    String otp = _otpController.text.trim();
    if (otp.length != 6) {
      CustomSnackBar.showSnackBar("Please enter a valid 6-digit OTP.");
      return;
    }
    try {
      _viewModel.isLoading = true;
      final credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: otp,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      _phoneNumberLoginViewModel.loginUser(widget.phoneNumber);
    } catch (e) {
      CustomSnackBar.showSnackBar("Invalid OTP. Please try again.");
    } finally {
      _viewModel.isLoading = false;
    }
  }

  void _resendOtp() async {
    try {
      await _phoneNumberLoginViewModel.auth.verifyPhoneNumber(
        phoneNumber: widget.phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _viewModel.auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          Get.snackbar('Error', 'Failed to send OTP.',
              backgroundColor: Colors.red, colorText: Colors.white);
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            widget.verificationId = verificationId;
            _startOtpTimer();
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to resend OTP.',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  Widget _buildInfoContainer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F1F1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.error, color: Colors.black45),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              'We have sent you a 6-digit verification code to your email. Please kindly check.',
              style: AppTextStyle.getTextStyle14FontWeightHintTextColor,
            ),
          ),
        ],
      ),
    );
  }

}
