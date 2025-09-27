import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import '../Screens/booking2/booking_screen2_viewmodel.dart';
import '../queue/queue_page.dart';
import '../queue/queue_viewmodel.dart';
import '../utils/app_strings.dart';
import '../utils/app_text_style.dart';
import '../utils/colors.dart';
import '../utils/common_variables.dart';
import '../widget/custom_button.dart';
import 'booked_screen_viewmodel.dart';

class BookedScreenPage extends StatelessWidget {
  final int selectedServicesCount;
  BookedScreenPage({super.key,required this.selectedServicesCount});

  late BookedScreenViewModel _viewModel;
  late QueueViewModel _queueViewModel;
  @override
  Widget build(BuildContext context) {
    _viewModel = context.watch<BookedScreenViewModel>();
    _queueViewModel = Provider.of<QueueViewModel>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back_ios_new,color: Colors.black,),
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Top Center Image
            Padding(
              padding: const EdgeInsets.only(top: 80),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/booked_image.svg',
                      height: 270,
                      width: 270,
                    ),
                    Text(
                      AppString.bookedSuccessfully,
                      style: AppTextStyle.getTextStyle30FontWeightw600FabricColor,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            // Button at the Bottom
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 40),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: AppTextStyle.getTextStyle15FontWeightw300,
                        children: [
                          TextSpan(
                            text: AppString.yourBookingID,
                          ),
                          TextSpan(
                            text: '# $selectedServicesCount',
                            style: AppTextStyle.getTextStyle18FontWeightw600FabricColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 20, right: 20),
                    width: double.infinity,
                    child: CustomButtonWidget(
                      text: AppString.continueText,
                      onPressed: () {
                        panelId;
                        print(panelId);
                        // final bookingStatus = _viewModel.bookings[_viewModel.selectedIndex];
                        // //_viewModel.cancelBooking(_bookingScreen2ViewModel.bookingId!,bookingStatus.status!);
                        // print(_bookingScreen2ViewModel.bookingId!);
                        Get.to(() => QueuePage(serviceProvideId: serviceProviderId,phoneNumber: mobileNumber,));

                      },
                      buttonColor: fabricColor,
                      borderRadius: 10,
                      buttonHeight: 40,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
