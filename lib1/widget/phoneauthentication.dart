import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wellwait_app/widget/snack_bar_widget.dart';

class PhoneAuthenticationOtp {

  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;

  Future<void> sendOtp(String phoneNumber, Function(String) onCodeSent) async {
    if (phoneNumber.isEmpty) {
      throw Exception('Phone number is empty');
    }
    await auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,  // Pass the properly formatted phone number
      verificationCompleted: (credential) {},
      verificationFailed: (e) {
        CustomSnackBar.showSnackBar('Phone verification failed: $e');
      },
      codeSent: (verificationId, resendToken) {
        onCodeSent(verificationId);  // Call the callback with verificationId
      },
      codeAutoRetrievalTimeout: (verificationId) {},
    );
  }

  veriftOtpCode({
    required String verifyId,
    required String otp,
  })async {
    try {
      final PhoneAuthCredential authCredential = PhoneAuthProvider.credential(
          verificationId: verifyId, smsCode: otp
      );
      final UserCredential userCredential = await auth.signInWithCredential(authCredential);
      if(userCredential.user != null) {
        storePhoneNumber(userCredential.user!.phoneNumber!);
        return "Success";
      } else {
        return "Error OTP";
      }
    } catch(e) {
      return e.toString();
    }
  }

  storePhoneNumber(String phoneNo) async  {
    try {
      await fireStore.collection('user').doc(phoneNo).set({
        'phoneNumber': phoneNo,
      });
    } catch(e) {
      e.toString();
    }
  }
}