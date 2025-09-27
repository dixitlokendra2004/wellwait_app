import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:wellwait_app/models/admin_notification.dart';
import '../../utils/app_text_style.dart';
import '../setting/admin_setting_page.dart';
import '../widget/app_bar.dart';

class NotificationDetailPage extends StatelessWidget {
  final AdminNotification notification;

  const NotificationDetailPage({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    DateTime dateTime = DateTime.parse(notification.createdDate.toString()).add(const Duration(hours: 5, minutes: 30));
    String formattedDate = DateFormat('dd MMM yyyy hh:mm a').format(dateTime);

    return Scaffold(
      backgroundColor: const Color(0xffECECEC),
      appBar: AppBar(
        backgroundColor: const Color(0xffECECEC),
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(Icons.arrow_back_ios_new)
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: GestureDetector(
              onTap: () {
                Get.to(() => AdminSettingScreen());
              },
              child: ClipOval(
                child: Image.asset(
                  "assets/icons/profile.png",
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.title.toString(),
                      style: AppTextStyle.getTextStyle16FontWeightw600.copyWith(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      notification.body.toString(),
                      style: AppTextStyle.getTextStyle14FontWeightw400.copyWith(fontSize: 14, color: Colors.black87),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        formattedDate,
                        style: AppTextStyle.getTextStyle10FontWeightw600.copyWith(color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
