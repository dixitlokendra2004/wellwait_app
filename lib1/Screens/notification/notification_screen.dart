import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../settings/settings_page.dart';
import '../../utils/app_text_style.dart';
import '../../utils/colors.dart';
import 'notification_viewmodel.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});
  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}
class _NotificationScreenState extends State<NotificationScreen> {
  late NotificationViewModel _viewModel;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _viewModel.fetchData();
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    _viewModel = context.watch<NotificationViewModel>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Notification',
          style: AppTextStyle.getTextStyle16FontWeightw700,
          textAlign: TextAlign.center, // Moved textAlign here
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Navigator.pop(context);
            Get.back();
          },
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: IconButton(
                onPressed: () {
                  Get.to(() => SettingsPage());
                },
                icon: const Icon(
                  Icons.settings,
                  color: fabricColor,
                  size: 30,
                )),
          )
        ],
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: ListView.separated(
          itemCount: _viewModel.notifications.length,
          itemBuilder: (context, index) {
            return _viewModel.notifications.isEmpty
                ? Center(child: Text('Empty',style: AppTextStyle.getTextStyle18FontWeightw600FabricColor),)
                : _viewModel.notifications.isEmpty
                ? Center(
              child: Text(
                'Empty',
                style: AppTextStyle.getTextStyle18FontWeightw600FabricColor,
              ),
            )
            : getNotification(_viewModel.notifications[index],index + 1);
              //getNotification(_viewModel.notifications[index]);
          },
          separatorBuilder: (BuildContext context, int index) {
            return Divider(color: Colors.grey[300]);
          },
        ),
      ),
    );
  }

  Widget getNotification(Map data,int count) {
    DateTime dateTime = DateTime.parse(data['created_date']).add(Duration(hours: 5, minutes: 30));
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
                    data['title'].toString(),
                    textAlign: TextAlign.left,
                    style: AppTextStyle.getTextStyle14FontWeightw400.copyWith(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  Text(
                    data['body'].toString(),
                    textAlign: TextAlign.left,
                    style: AppTextStyle.getTextStyle14FontWeightw400.copyWith(fontSize: 13),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      formattedDate,
                      textAlign: TextAlign.left,
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


