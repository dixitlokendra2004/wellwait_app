import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import '../email_login/email_login_viewmodel.dart';
import '../queue/queue_page.dart';
import '../utils/app_strings.dart';
import '../utils/app_text_style.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../widget/custom_button.dart';
import '../widget/snack_bar_widget.dart';
import 'booking_pending_viewmodel.dart';

class BookingPendingPage extends StatefulWidget {
  const BookingPendingPage({super.key});

  @override
  State<BookingPendingPage> createState() => _BookingPendingPageState();
}

class _BookingPendingPageState extends State<BookingPendingPage> {
  late BookingPendingViewModel _viewModel;
  late EmailLoginViewModel emailLoginViewModel;

  void initState() {
    super.initState();
    // Use addPostFrameCallback to avoid calling during build
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      print("api call");
      await _viewModel.fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    _viewModel = context.watch<BookingPendingViewModel>();
    emailLoginViewModel = context.watch<EmailLoginViewModel>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back_ios_new,color: Colors.black,),
        ),
        title: Center(
            child: Text(AppString.booking,
                style: AppTextStyle.getTextStyle18FontWeightBold)
        ),
        actions: [
          Container(
            width: 30,
            height: 30,
            color: Colors.transparent,
          ),
        ],
      ),
      body: _viewModel.isLoading
        ?  const Center(
        child: CircularProgressIndicator(),
      ) : _viewModel.bookings.isEmpty
        ? Center(child: Text("No booking available",style: AppTextStyle.getTextStyle18FontWeightw600FabricColor,))
      : ListView.builder(
        itemCount: _viewModel.bookings.length,
          itemBuilder: (context, index) {
            final booking = _viewModel.bookings[index];
            // if (booking.finished == 1 && booking.paymentComplete == 1) {
            //   return SizedBox.shrink();
            // }
            final List<String> promoImages = (booking.imageUrl ?? '').split(',').map((s) => s.trim()).toList();
            final String salonServiceImage = (promoImages.isNotEmpty && promoImages[0].isNotEmpty)
                ? '$BASE_URL/uploads/${promoImages[0]}' : dummyimage;
            return GestureDetector(
              onTap: () async {
                if(booking.finished == 1 && booking.paymentComplete == 0) {
                  print("no clicked");
                } else {
                  int bookingServiceProviderId = booking.serviceProviderId!;
                  await _viewModel.fetchSalonServiceProvidersById(bookingServiceProviderId);
                  final selectServiceProvider = _viewModel.serviceProvider[_viewModel.selectedIndex];
                  String? phoneNumber = selectServiceProvider.mobileNumber;
                  Get.to(() => QueuePage(serviceProvideId: bookingServiceProviderId,phoneNumber: phoneNumber,));
                }
              },
              child: Card(
                color: Colors.white,
                margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 100,
                          height: 80,
                          margin: const EdgeInsets.all(8),
                          child: CachedNetworkImage(
                            imageUrl: salonServiceImage,
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                  colorFilter: const ColorFilter.mode(Colors.transparent, BlendMode.colorBurn),
                                ),
                              ),
                            ),
                            placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) => const Icon(Icons.error),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 6),
                                    Text(
                                      booking.salonName.toString(),
                                      style: AppTextStyle.getTextStyle18FontWeightBold,
                                    ),
                                    const SizedBox(height: 3),
                                     Text(
                                      booking.address.toString(),
                                      style: AppTextStyle.getTextStyle13FontWeightw400G,
                                       maxLines: 1,
                                       overflow: TextOverflow.ellipsis,
                                       softWrap: false,
                                    ),
                                    const SizedBox(height: 3),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(right: 20),
                                          child: Text(
                                            booking.serviceName.toString(),
                                            style: const TextStyle(

                                                fontWeight: FontWeight.w400,
                                                fontSize: 14,
                                                color: Colors.black
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        RichText(
                                          textAlign: TextAlign.left,
                                          text: TextSpan(
                                            children: [
                                              const TextSpan(
                                                text: 'Price: ',
                                                style: TextStyle(
                                                  color: Colors.black54,

                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              TextSpan(
                                                text:  '${booking.price.toString()}',
                                                style: AppTextStyle.getTextStyle14FontWeight,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              // const SizedBox(height: 10),
                              // Padding(
                              //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              //   child: Row(
                              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //     children: [
                              //       Container(
                              //         height: 40,
                              //         margin: const EdgeInsets.only(bottom: 10),
                              //         decoration: BoxDecoration(
                              //           borderRadius: BorderRadius.circular(12),
                              //           color: const Color(0xffE6F4F4),
                              //         ),
                              //         child: IconButton(
                              //           icon: const Icon(Icons.navigation_sharp,color: Colors.grey,),
                              //           onPressed: () {
                              //             // Toggle favorite status
                              //             // Notify changes
                              //           },
                              //         ),
                              //       ),
                              //       const SizedBox(width: 25),
                              //       Expanded(
                              //         child: Container(
                              //           margin: const EdgeInsets.only(bottom: 6),
                              //           child: CustomButtonWidget(
                              //             text: AppString.payment,
                              //             textColor: Colors.grey,
                              //             onPressed: () async {
                              //               // Call the passed onPressed function
                              //               // onPressed(); // Execute the onPressed callback
                              //             },
                              //             buttonColor: Colors.white,
                              //             borderColor: Colors.grey,
                              //             borderRadius: 5,
                              //             buttonHeight: 40,
                              //           ),
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    (booking.finished == 1 && booking.paymentComplete == 0) ?
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8,left: 10,right: 10,top: 5),
                      child: Container(
                        width: double.infinity,
                        child: CustomButtonWidget(
                          text: "Pay",
                          onPressed: () {
                            _viewModel.makePayment(booking.id);
                          },
                          buttonHeight: 30,
                          buttonColor: fabricColor,
                        ),
                      ),
                    )
                        : Container(),
                  ],
                ),
              ),
            );
          }
      ),
    );
  }
}
