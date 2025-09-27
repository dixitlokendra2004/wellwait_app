import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import 'package:wellwait_app/schedule/schedule_viewmodel.dart';
import '../models/booking.dart';
import '../queue/queue_page.dart';
import '../queue/queue_viewmodel.dart';
import '../utils/app_strings.dart';
import '../utils/app_text_style.dart';
import '../utils/colors.dart';
import '../utils/common_method.dart';
import '../utils/constants.dart';
import '../widget/custom_button.dart';
import '../widget/snack_bar_widget.dart';

class ScheduleScreenPage extends StatefulWidget {
  const ScheduleScreenPage({super.key});
  @override
  State<ScheduleScreenPage> createState() => _ScheduleScreenPageState();
}
class _ScheduleScreenPageState extends State<ScheduleScreenPage> {
  late ScheduleViewModel _viewModel;
  late QueueViewModel _queueViewModel;
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _viewModel.fetchData();
    });
  }
  @override
  Widget build(BuildContext context) {
    _viewModel = context.watch<ScheduleViewModel>();
    _queueViewModel = Provider.of<QueueViewModel>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Text(
              AppString.newText,
              style: AppTextStyle.getTextStyle18FontWeightBold,
            ),
          ),
        ),
      ),
      body: _viewModel.isLoading
          ? const Center(child: CircularProgressIndicator(),)
          : (_viewModel.todayBooking.isEmpty && _viewModel.pastBookings.isEmpty)
          ? const Center(
        child: Text(
          "No bookings available",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            
            color: fabricColor,
          ),
        ),
      )
          : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_viewModel.todayBooking.isNotEmpty)
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _viewModel.todayBooking.length,
                itemBuilder: (context, index) {
                  var todayBooking = _viewModel.todayBooking[index];
                  return mainCard(todayBooking);
                },
              ),
            if (_viewModel.pastBookings.isNotEmpty)
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _viewModel.pastBookings.length,
                itemBuilder: (context, index) {
                  final beforeBooking = _viewModel.pastBookings[index];
                  final List<String> promoImages = (beforeBooking.imageUrl ?? '').split(',').map((s) => s.trim()).toList();
                  final String salonServiceImage = (promoImages.isNotEmpty && promoImages[0].isNotEmpty)
                      ? '$BASE_URL/uploads/${promoImages[0]}' : dummyimage;
                  String displayServiceNames() {
                    final serviceNamesList = (beforeBooking.serviceName ?? '').split(',').map((s) => s.trim()).toList();
                    if (serviceNamesList.isEmpty || (serviceNamesList.length == 1 && serviceNamesList[0].isEmpty)) {
                      return 'Unknown Service';
                    }
                    if (serviceNamesList.length <= 2) {return serviceNamesList.join(', ');}
                    return '${serviceNamesList.take(2).join(', ')} +${serviceNamesList.length - 2}';
                  }
                  return Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: Card(
                      color: Colors.white,
                      elevation: 5,
                      shadowColor: Colors.black.withOpacity(0.9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Container(
                              width: 150,
                              height: 180,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: Colors.white,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: CachedNetworkImage(
                                  imageUrl: salonServiceImage,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) =>
                                  const Center(child: CircularProgressIndicator()),
                                  errorWidget: (context, url, error) => const Icon(Icons.error),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                 Row(
                                   children: [
                                     RichText(
                                       text: TextSpan(
                                         text: displayServiceNames(),
                                         style: AppTextStyle.getTextStyle15FontWeightw600,
                                       ),
                                     ),
                                     const SizedBox(width: 6),
                                     Text(
                                       beforeBooking.status == 3 ? "Successfully" : "Pending",
                                       style: const TextStyle(color: Colors.grey,fontSize: 12),
                                     ),
                                   ],
                                 ),
                                  const SizedBox(height: 2),
                                  Text(
                                    beforeBooking.status == 3 ? "Service Done" : "Service pending",
                                    style: AppTextStyle.getTextStyle13FontWeightG,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    beforeBooking.salonName ?? '',
                                    style: AppTextStyle.getTextStyle18FontWeightBold,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    beforeBooking.address ?? '',
                                    style: AppTextStyle.getTextStyle14FontWeightw600Grey,
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Icon(Icons.star, color: Colors.yellowAccent),
                                      const SizedBox(width: 8),
                                      Text(
                                        '${formatAverageRating(beforeBooking.averageRating!.toDouble())} (${beforeBooking.totalRating}) Rating',
                                        style: AppTextStyle.getTextStyle14FontWeightw500Indigo,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      Container(
                                        height: 40,
                                        width: 40,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.grey[200],
                                        ),
                                        child: const Center(
                                          child: Icon(Icons.navigation_sharp, color: Colors.black),
                                        ),
                                      ),
                                      const SizedBox(width: 20),
                                      Expanded(
                                        child: CustomButtonWidget(
                                          text: AppString.rateUs,
                                          textColor: Colors.grey,
                                          onPressed: () {},
                                          buttonHeight: 40,
                                          buttonColor: Colors.white,
                                          borderRadius: 5,
                                          borderColor: Colors.grey,
                                          borderWidth: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  // String displayServiceNames(beforeBooking) {
  //   final serviceNamesList = (beforeBooking.serviceNames ?? '').split(',').map((s) => s.trim()).toList();
  //   if (serviceNamesList.isEmpty || (serviceNamesList.length == 1 && serviceNamesList[0].isEmpty)) {
  //     return 'Unknown Service';
  //   }
  //   if (serviceNamesList.length <= 2) { return serviceNamesList.join(', ');}
  //   return '${serviceNamesList.take(2).join(', ')} +${serviceNamesList.length - 2}';
  // }

  mainCard(Booking todayBooking) {
    final List<String> promoImages = (todayBooking.imageUrl ?? '').split(',').map((s) => s.trim()).toList();
    final String salonServiceImage = (promoImages.isNotEmpty && promoImages[0].isNotEmpty) ? '$BASE_URL/uploads/${promoImages[0]}' : dummyimage;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: () async {
          int bookingServiceProviderId = todayBooking.serviceProviderId!;
          await _viewModel.fetchSalonServiceProvidersById(bookingServiceProviderId);
          final selectServiceProvider = _viewModel.serviceProvider[_viewModel.selectedIndex];
          String? phoneNumber = selectServiceProvider.mobileNumber;
          print("Schedule Mobile Number: $phoneNumber");
          Get.to(() => QueuePage(serviceProvideId: bookingServiceProviderId, phoneNumber: phoneNumber,));
        },
        child: Card(
          color: Colors.white,
          elevation: 5,
          shadowColor: Colors.black.withOpacity(0.9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          margin: const EdgeInsets.only(left: 15, right: 15),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: Colors.white,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: CachedNetworkImage(
                      imageUrl: salonServiceImage,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                     todayBooking.salonName.toString(),
                      style: AppTextStyle.getTextStyle20FontWeightBold,
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.yellowAccent),
                        const SizedBox(width: 8),
                        Text(
                          '${formatAverageRating(todayBooking.averageRating!.toDouble())} (${todayBooking.totalRating}) Rating',
                          style: AppTextStyle.getTextStyle13FontWeightw500,
                        ),
                      ],
                    ),
                  ],
                ),
                Text(
                  todayBooking.address.toString(),
                  style: AppTextStyle.getTextStyle13FontWeightw500,
                ),
                const SizedBox(height: 10),
                RichText(
                  text: TextSpan(
                    text: AppString.service,
                    style: AppTextStyle.getTextStyle15FontWeightw600,
                    children: <TextSpan>[
                      TextSpan(
                        text: todayBooking.serviceName,
                        style: AppTextStyle.getTextStyleFontWeightw600B,
                      ),
                      TextSpan(
                        text: AppString.booked,
                        style: AppTextStyle.getTextStyle13FontWeightw300,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Panel - ${todayBooking.panelId}",
                  style: AppTextStyle.getTextStyle14FontWeightw300Teal,
                ),
                const SizedBox(height: 22),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: fabricColor,
                      ),
                      child: const Center(
                        child: Icon(Icons.navigation_sharp, color: Colors.white),
                      ),
                    ),
                    todayBooking.status == 3 ?
                    CustomButtonWidget(
                      text: 'Completed',
                      textColor: Colors.grey,
                     onPressed: () {
                       CustomSnackBar.showSnackBar('Your Booking is Completed');
                     },
                      buttonHeight: 45,
                      buttonColor: Colors.white,
                      borderRadius: 5,
                      borderColor: Colors.grey,
                      borderWidth: 1,
                    )
                    : CustomButtonWidget(
                      text: AppString.cancel,
                      textColor: Colors.grey,
                      onPressed: () {
                        // final todayBooking = _viewModel.bookingsPending[_viewModel.selectedIndex];
                        // todayBooking.finished == 1 ? CustomSnackBar.showSnackBar("User ID not found. Please log in again.")
                        // : _showDialog(context,todayBooking.serviceName.toString());
                        // _showDialog(context,todayBooking.serviceName.toString());
                        var id = todayBooking.id;
                        _showCancelDialog(context, id!);
                      },
                      buttonHeight: 45,
                      buttonColor: Colors.white,
                      borderRadius: 5,
                      borderColor: Colors.grey,
                      borderWidth: 1,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showCancelDialog(BuildContext context, int bookingId) {
    showDialog(
      context: context,
      barrierDismissible: false, // User must select an option to dismiss the dialog
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Cancel Booking',
                  style: AppTextStyle.getTextStyle18FontWeightBold,
                ),
                const SizedBox(height: 12),
                const Text('Are you sure you want to cancel the booking?',style: TextStyle(fontSize: 16)),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('No',style: TextStyle(color: fabricColor)),
                    ),
                    TextButton(
                      onPressed: () {
                        _viewModel.cancelBooking(bookingId);
                        CustomSnackBar.showSnackBar("Canceled booking");
                        Navigator.pop(context);
                       // _viewModel.refreshUI();
                      },
                      child: const Text('Yes',style: TextStyle(color: fabricColor)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

}


// Widget mainCard() {
//   final todayBooking = _viewModel.todayBooking;
//
//   if (todayBooking == null) {
//     return Card(
//       color: Colors.white,
//       elevation: 5,
//       shadowColor: Colors.black.withOpacity(0.9),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(14),
//       ),
//       margin: const EdgeInsets.only(left: 15, right: 15),
//       child: Padding(
//         padding: const EdgeInsets.all(14),
//         child: Center(
//           child: Text(
//             "No bookings for today",
//             style: AppTextStyle.getTextStyle20FontWeightBold,
//           ),
//         ),
//       ),
//     );
//   }
//
//   final List<String> promoImages = (todayBooking.imageUrl ?? '')
//       .split(',')
//       .map((s) => s.trim())
//       .toList();
//
//   final String salonServiceImage = (promoImages.isNotEmpty && promoImages[0].isNotEmpty)
//       ? '$BASE_URL/uploads/${promoImages[0]}'
//       : dummyimage;
//
//   return Card(
//     color: Colors.white,
//     elevation: 5,
//     shadowColor: Colors.black.withOpacity(0.9),
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.circular(14),
//     ),
//     margin: const EdgeInsets.only(left: 15, right: 15),
//     child: Padding(
//       padding: const EdgeInsets.all(14),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             height: 200,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(14),
//               color: Colors.white,
//               image: DecorationImage(
//                 image: NetworkImage(salonServiceImage),
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           const SizedBox(height: 15),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 todayBooking.salonName ?? '',
//                 style: AppTextStyle.getTextStyle20FontWeightBold,
//               ),
//               Row(
//                 children: [
//                   const Icon(Icons.star, color: Colors.yellowAccent),
//                   const SizedBox(width: 8),
//                   Text(
//                     todayBooking.rating ?? 'No rating',
//                     style: AppTextStyle.getTextStyle13FontWeightw500,
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           const SizedBox(height: 5),
//           Text(
//             todayBooking.address ?? 'No address available',
//             style: AppTextStyle.getTextStyle13FontWeightw500,
//           ),
//           const SizedBox(height: 15),
//           RichText(
//             text: TextSpan(
//               text: "Service: ",
//               style: AppTextStyle.getTextStyle15FontWeightw600,
//               children: <TextSpan>[
//                 TextSpan(
//                   text: todayBooking.serviceName ?? 'Unknown Service',
//                   style: AppTextStyle.getTextStyleFontWeightw600B,
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 22),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Container(
//                 height: 50,
//                 width: 50,
//                 decoration: const BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: fabricColor,
//                 ),
//                 child: const Center(
//                   child: Icon(Icons.navigation_sharp, color: Colors.white),
//                 ),
//               ),
//               CustomButtonWidget(
//                 text: AppString.cancel,
//                 textColor: Colors.grey,
//                 onPressed: () {},
//                 buttonHeight: 45,
//                 buttonColor: Colors.white,
//                 borderRadius: 5,
//                 borderColor: Colors.grey,
//                 borderWidth: 1,
//               ),
//             ],
//           ),
//         ],
//       ),
//     ),
//   );
// }