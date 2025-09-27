import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import 'package:wellwait_app/past_booking/past_booking_viewmodel.dart';
import '../utils/app_strings.dart';
import '../utils/app_text_style.dart';
import '../utils/constants.dart';

class PastBookingPage extends StatefulWidget {
  const PastBookingPage({super.key});

  @override
  State<PastBookingPage> createState() => _PastBookingPageState();
}

class _PastBookingPageState extends State<PastBookingPage> {
  late PastBookingVieModel _viewModel;

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      print("api call");
      _viewModel.fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    _viewModel = context.watch<PastBookingVieModel>();
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
            child: Text(AppString.pastBooking,
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
        ? Center(child: CircularProgressIndicator(),)
          : _viewModel.bookings.isEmpty
        ? Center(child: Text("No Past Booking Available",style: AppTextStyle.getTextStyle18FontWeightw600FabricColor),)
          : ListView.builder(
          itemCount: _viewModel.bookings.length,
          itemBuilder: (context, index) {
            final booking = _viewModel.bookings[index];
            final List<String> promoImages = (booking.imageUrl ?? '').split(',').map((s) => s.trim()).toList();
            final String salonServiceImage = (promoImages.isNotEmpty && promoImages[0].isNotEmpty)
                ? '$BASE_URL/uploads/${promoImages[0]}' : dummyimage;
            return Card(
              color: Colors.white,
              margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 100,
                    height: 90,
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
                              Text(
                                'Service Done',
                                style: AppTextStyle.getTextStyle12FontWeightw300,
                              ),
                              const SizedBox(height: 3),
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
                                            // height: 1.3, // Equivalent to 42.9px line height
                                            // letterSpacing: 0.04,
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
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
      ),
    );
  }
}
