import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import 'package:wellwait_app/admin/service_provider_timing/service_provider_timing_viewmodel.dart';
import 'package:wellwait_app/admin/utils/admin_ common_variable.dart';
import '../../utils/app_text_style.dart';
import '../../utils/colors.dart';
import '../admin_email_login/admin_email_login_viewmodel.dart';

class ServiceProviderTimingPage extends StatefulWidget {
  const ServiceProviderTimingPage({super.key});

  @override
  State<ServiceProviderTimingPage> createState() => _ServiceProviderTimingPageState();
}

class _ServiceProviderTimingPageState extends State<ServiceProviderTimingPage> {
  late ServiceProviderTimingViewModels _viewModel;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      //await _viewModel.fetchSalonTimings(_homePageViewModel.serviceProviderId.toString());
      await _viewModel.fetchSalonTimings(adminServiceProviderId.toString());
    });
  }
  //late AdminEmailLoginViewModel _homePageViewModel;
  @override
  Widget build(BuildContext context) {
    _viewModel = context.watch<ServiceProviderTimingViewModels>();
    //_homePageViewModel = Provider.of<AdminEmailLoginViewModel>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
              "Salon Timing",
              style: AppTextStyle.getTextStyle18FontWeightBold
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back_ios_new,color: Colors.black,),
        ),
      ),
      body: _viewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : _viewModel.salonTiming.isEmpty
        ? Center(child: Text("Salon time is not found",style: AppTextStyle.getTextStyle14FontWeightw300,),)
          : ListView.builder(
        itemCount: _viewModel.salonTiming.length,
        itemBuilder: (context, index) {
          final timing = _viewModel.salonTiming[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  timing.day.toString(),
                  style: const TextStyle(
                    
                    fontWeight: FontWeight.w500,
                    fontSize: 22,
                    color: fabricColor,
                  ),
                ),
                const SizedBox(height: 12),
                cardWidget("Start Time: ",timing.startTime.toString(),Colors.white),
                cardWidget("End Time: ",timing.endTime.toString(),const Color(0xfff6f6f6)),
                cardWidget("Lunch Start: ",timing.lunchStart.toString(),Colors.white),
                cardWidget("Lunch End: ",timing.lunchEnd.toString(),const Color(0xfff6f6f6)),
              ],
            ),
          );
        },
      ),
    );
  }

  cardWidget(String title , String text,Color bgColor) {
    return Container(
      padding: const EdgeInsets.all(3),
      color: bgColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              
              color: Colors.black54,
            ),
          ),
          Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              
            ),
          ),
        ],
      ),
    );
  }

}