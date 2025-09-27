import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:wellwait_app/admin/setting/setting_viewmodel.dart';
import 'package:wellwait_app/utils/colors.dart';
import '../../Screens/Profile/profile_screen.dart';
import '../../utils/app_strings.dart';
import '../../utils/app_text_style.dart';
import '../../utils/constants.dart';
import '../../utils/sp_helper.dart';
import '../../widget/custom_button.dart';
import '../admin_phone_number_login/admin_auth_viewmodel.dart';
import '../admin_phone_number_login/admin_phone_number_page.dart';
import '../registration/salon_detail_page.dart';
import '../registration/salon_documents_page.dart';
import '../registration/salon_information_page.dart';
import '../registration/salon_service_page.dart';
import '../widget/app_bar.dart';

class AdminSettingScreen extends StatefulWidget {
  const AdminSettingScreen({super.key});

  @override
  State<AdminSettingScreen> createState() => _AdminSettingScreenState();
}

class _AdminSettingScreenState extends State<AdminSettingScreen> {
  late AdminSettingsViewModel _viewModel;
  late AdminAuthViewModel _authViewModel;
  @override
  Widget build(BuildContext context) {
    _viewModel = context.watch<AdminSettingsViewModel>();
    _authViewModel = context.watch<AdminAuthViewModel>();
    return Scaffold(
      backgroundColor: const Color(0xffECECEC),
      appBar: CustomAppBar(showHomeButton: true),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Column(
                      children: [
                        Text(
                          _authViewModel.serviceProvider.salonName.toString(),
                          style: AppTextStyle.getTextStyle14FontWeightw600G,
                        ),
                        Text(
                          AppString.setting,
                          style: AppTextStyle.getTextStyle22FontWeightw800G,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    settingsDetails(AppString.businessDetails, AppString.businessDetailsTitle, 0),
                    const SizedBox(height: 10),
                    settingsDetails(AppString.operatingSchedule, AppString.operatingScheduleTitle, 1),
                    const SizedBox(height: 10),
                    settingsDetails(AppString.salonShowcase, AppString.salonShowcaseTitle, 2),
                    const SizedBox(height: 10),
                    settingsDetails(AppString.verificationBanking, AppString.verificationBankingTitle, 3),
                    // SizedBox(height: 10),
                    // settingsDetails("Edit profile", "Upload your profile picture", 4),
                  ],
                ),
              ),
            ),
            // Back Button Positioned at the Bottom
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: double.infinity,
                child: CustomButtonWidget(
                  text: AppString.logout,
                  textColor: Colors.white,
                  onPressed: () {
                    final SharedPreferenceService _sharedPreferenceService =
                    SharedPreferenceService();
                    _sharedPreferenceService.clearCredentials();
                    //Get.to(() => AdminEmailLoginPage());
                    Get.offAll(() => AdminPhoneNumberPage());
                  },
                  buttonColor: fabricColor,
                  borderRadius: 5,
                  buttonHeight: 40,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget settingsDetails(String title, String subTitle, int index) {
    return Card(
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                Text(subTitle, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Color(0xff737687))),
              ],
            ),
            GestureDetector(
              onTap: () {
                if (index == 0) {
                  Get.to(() => SalonDetailPage(salonDetailEdit: true));
                } else if (index == 1) {
                  Get.to(() => SalonInformationPage(salonInfoEdit: true));
                } else if (index == 2) {
                  Get.to(() => SalonServicePage(salonServiceEdit: true));
                } else if (index == 3) {
                  Get.to(() => SalonDocumentsPage(salonDocumentEdit: true));
                }
                // else if (index == 4) {
                //   Get.to(() => ProfilePage());
                // }
              },
              child: Container(
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  shape: BoxShape.circle,
                ),
                  child: SvgPicture.asset("assets/icons/edit.svg", height: 25)
              ),
            ),
          ],
        ),
      ),
    );
  }
}




