import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:wellwait_app/admin/admin_phone_number_login/admin_auth_viewmodel.dart';
import 'package:wellwait_app/admin/utils/admin_%20common_variable.dart';
import '../../admin/admin_phone_number_login/admin_phone_number_page.dart';
import '../../email_login/email_login_page.dart';
import '../../email_login/email_login_viewmodel.dart';
import '../../phone_number_login/phone_number_login_page.dart';
import '../../phone_number_login/phone_number_login_viewmodel.dart';
import '../../utils/common_variables.dart';
import '../../utils/sp_helper.dart';
import '../../widget/bottom_bar_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  int _currentStage = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
    _startSequence();
  }

  autoLoginUser() async {
    final SharedPreferenceService _sharedPreferenceService = SharedPreferenceService();

    int? userId = await _sharedPreferenceService.getUserId();
    print("userId: $userId");

    if (userId != null && userId != 0) {
      userName = await _sharedPreferenceService.getUsername() ?? '';
      userPhoneNumber = await _sharedPreferenceService.getUserPhoneNumber() ?? '';
      userEmail = await _sharedPreferenceService.getUserEmail() ?? '';
      userGender = await _sharedPreferenceService.getUserGender();
      final birthdayString = await _sharedPreferenceService.getUserBirthday();
      userProfileImage = await _sharedPreferenceService.getUserProfileImage() ?? '';
      location = await _sharedPreferenceService.getUserLocation() ?? '';

      if (birthdayString != null && birthdayString.isNotEmpty) {
        try {
          userBirthday = DateTime.parse(birthdayString);
        } catch (e) {
          print("Error parsing birthday: $e");
          userBirthday = null;
        }
      }
      Get.off(() => BottomBar());
    } else if (adminServiceProviderId > 0) {
      Provider.of<AdminAuthViewModel>(context, listen: false).tryAutoLogin();
    } else {
      Get.off(() => PhoneNumberLoginPage());
    }
  }


  void _startSequence() async {
    await _showElement(1);
    await _hideElement();
    await _showElement(2);
    await _hideElement();
    await _showElement(3);
    await _hideElement();
    await _showElement(4);
    await autoLoginUser();
  }

  Future<void> _showElement(int stage) async {
    setState(() => _currentStage = stage);
    await _controller.forward();
    await Future.delayed(const Duration(milliseconds: 50));
  }

  Future<void> _hideElement() async {
    await _controller.reverse();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildStar({required String assetName, double size = 20.0}) {
    return SvgPicture.asset(
      'assets/icons/$assetName',
      width: size,
      height: size,
    );
  }

  Widget _buildWellWaitText() {
    return RichText(
      textAlign: TextAlign.left,
      text: const TextSpan(
        children: [
          TextSpan(
            text: 'Well',
            style: TextStyle(
              color: Colors.black,
              fontSize: 33.0,
              fontWeight: FontWeight.w700,
              height: 1.3,
              letterSpacing: 0.04,
            ),
          ),
          TextSpan(
            text: 'Wait',
            style: TextStyle(
              color: Colors.teal,
              fontSize: 33.0,
              fontWeight: FontWeight.w700,
              height: 1.3,
              letterSpacing: 0.04,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FadeTransition(
          opacity: _opacityAnimation,
          child: Builder(
            builder: (context) {
              if (_currentStage == 1) {
                return _buildStar(
                    assetName: 'smallstar.svg', size: 20.0);
              } else if (_currentStage == 2) {
                return _buildStar(
                    assetName: 'bigstar.svg', size: 40.0);
              } else if (_currentStage == 3) {
                return _buildStar(
                    assetName: 'smallstar.svg', size: 20.0);
              } else if (_currentStage == 4) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildStar(assetName: 'smallstar.svg', size: 20.0),
                    const SizedBox(width: 8.0),
                    _buildWellWaitText(),
                  ],
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ),
      ),
    );
  }
}
