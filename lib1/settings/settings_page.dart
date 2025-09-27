import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import 'package:wellwait_app/settings/settings_viewmodel.dart';

import '../utils/app_strings.dart';
import '../utils/app_text_style.dart';
import '../utils/colors.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late SettingsViewModel _viewModel;

  @override
  Widget build(BuildContext context) {
    _viewModel = context.watch<SettingsViewModel>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.teal),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          AppString.settingsTitle,  // Use the AppString value
          style: AppTextStyle.getTextStyle20FontWeightBold,
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          settingsItems(AppString.editProfile, false, null, null, 15, FontWeight.w600),
          const SizedBox(height: 10),
          settingsItems(AppString.manageNotification, false, null, null, 15, FontWeight.w600),
          const SizedBox(height: 8),
          settingsItems(AppString.bookingActivity, true, _viewModel.bookingActivityNotification, (value) {
            setState(() {
              _viewModel.bookingActivityNotification = value;
            });
          }),
          settingsItems(AppString.message, true, _viewModel.messageNotification, (value) {
            setState(() {
              _viewModel.messageNotification = value;
            });
          }),
          settingsItems(AppString.emailNotification, true, _viewModel.emailNotification, (value) {
            setState(() {
              _viewModel.emailNotification = value;
            });
          }),
          const SizedBox(height: 10),
          settingsItems(AppString.deleteAccount, false, null, null, 15, FontWeight.w600),
        ],
      ),
    );
  }

  Widget settingsItems(
      String text,
      bool showSwitch, [
        bool? switchValue,
        Function(bool)? onSwitchChanged,
        double? fontSize,
        FontWeight? fontWeight,
      ]) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: TextStyle(
              fontSize: fontSize ?? 14,
              fontWeight: fontWeight ?? FontWeight.w500,
              color: Colors.black,
              
            ),
          ),
          if (showSwitch)
            Row(
              children: [
                Transform.scale(
                  scale: 0.7,
                  child: Switch(
                    value: switchValue ?? false,
                    onChanged: onSwitchChanged,
                    activeColor: Colors.grey[400],
                    inactiveThumbColor: Colors.white,
                    inactiveTrackColor: fabricColor,
                  ),
                ),
              ],
            )
          else
            const Icon(Icons.arrow_forward_ios, color: Colors.black),
        ],
      ),
    );
  }
}
