import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:wellwait_app/models/admin_notification.dart';
import '../../utils/app_text_style.dart';
import '../../utils/colors.dart';
import '../admin_phone_number_login/admin_auth_viewmodel.dart';
import '../widget/app_bar.dart';
import 'admin_notification_viewmodel.dart';
import 'notification_screen.dart';

class AdminNotificationPage extends StatefulWidget {
  const AdminNotificationPage({super.key});

  @override
  State<AdminNotificationPage> createState() => _AdminNotificationPageState();
}

class _AdminNotificationPageState extends State<AdminNotificationPage> {
  late AdminAuthViewModel _authViewModel;
  late AdminNotificationViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel.fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    _viewModel = context.watch<AdminNotificationViewModel>();
    _authViewModel = context.watch<AdminAuthViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xffECECEC),
      appBar: CustomAppBar(showHomeButton: false),
      body: Center(
        child: Column(
          children: [
            Text(
              _authViewModel.serviceProvider.salonName.toString(),
              style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w600),
            ),
            Text(
              "Notification",
              style: TextStyle(fontSize: 22, color: AppColors.primaryColor, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: _viewModel.isLoading
                    ? const Center(child: CircularProgressIndicator(),)
                    : _viewModel.notifications.isEmpty
                    ? Center(child: Text('Empty',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w400)),)
                    : ListView.separated(
                  itemCount: _viewModel.notifications.length,
                  itemBuilder: (context, index) {
                    final notification = _viewModel.notifications[index];
                    return GestureDetector(
                      onTap: () {
                        Get.to(() => NotificationDetailPage(notification: notification),);
                      },
                      child: getNotification(notification,index + 1),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return Divider(color: Colors.grey[300]);
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget getNotification(AdminNotification data,int count) {
    DateTime dateTime = DateTime.parse(data.createdDate.toString()).add(const Duration(hours: 5, minutes: 30));
    String formattedDate = DateFormat('dd MMM yyyy hh:mm a').format(dateTime);
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("#${count}",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 16)),
          SizedBox(width: 10),
          Expanded(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.title.toString(),
                    style: AppTextStyle.getTextStyle14FontWeightw400.copyWith(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  Text(
                    data.body.toString(),
                    style: AppTextStyle.getTextStyle14FontWeightw400.copyWith(fontSize: 12, color: Colors.black54, fontWeight: FontWeight.w400),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      formattedDate,
                      style: AppTextStyle.getTextStyle10FontWeightw600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
