import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../Screens/booking2/booking_screen2.dart';
import '../models/salon_timing.dart';
import '../otp_verification/otp_verification_page.dart';
import '../home_screen/home_screen_viewmodel.dart';
import '../utils/app_text_style.dart';
import '../utils/colors.dart';
import '../utils/common_method.dart';
import '../utils/common_variables.dart';
import '../utils/constants.dart';
import '../widget/custom_button.dart';
import '../widget/snack_bar_widget.dart';
import 'full_screen_image.dart';
import 'sp_detail_viewmodel.dart';

class ServiceProviderDetailPage extends StatefulWidget {
  final String userName;
  final String address;
  final String imagePath;
  final int? viewCount;
  final double? averageRating;
  final int? totalRatings;
  final String mobileNumber;

  const ServiceProviderDetailPage({
    Key? key,
    required this.userName,
    required this.address,
    required this.imagePath,
    this.viewCount,
    this.averageRating,
    this.totalRatings,
    required this.mobileNumber,
  }) : super(key: key);

  @override
  State<ServiceProviderDetailPage> createState() =>
      _ServiceProviderDetailPageState();
}

class _ServiceProviderDetailPageState extends State<ServiceProviderDetailPage> {
  late SPDetailViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _viewModel.fetchSalonTimings(serviceProviderId.toString());
      await _viewModel.fetchPanels(serviceProviderId);
      await _viewModel.fetchBookingCount();
      //await _viewModel.fetchSalonTimings(serviceProviderId.toString());
    });
  }

  late HomeScreenViewModel _homePageViewModel;
  bool showAllImages = false;

  @override
  Widget build(BuildContext context) {
    _viewModel = context.watch<SPDetailViewModel>();
    _homePageViewModel =
        Provider.of<HomeScreenViewModel>(context, listen: false);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            topImage(context),
            Container(
              margin: const EdgeInsets.only(
                  left: 15, right: 15, top: 10, bottom: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.userName,
                    style: AppTextStyle.getTextStyle22FontWeightw700,
                  ),
                  Text(
                    widget.address,
                    style: AppTextStyle.getTextStyle14FontWeightw700,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.access_time_outlined,
                            color: fabricColor,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            "[Open Today]",
                            style:
                                AppTextStyle.getTextStyle12FontWeightw300Black,
                          ),
                        ],
                      ),
                      // const SizedBox(width: 22),
                      // Row(
                      //   children: [
                      //     const Icon(
                      //       Icons.add_moderator,
                      //       size: 20,
                      //       color: fabricColor,
                      //     ),
                      //     const SizedBox(width: 10),
                      //     Text(
                      //       "58%",
                      //       style: AppTextStyle.getTextStyle14FontWeightw600FabricColor,
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.yellow,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            "${formatAverageRating(widget.averageRating!.toDouble())} (${widget.totalRatings})",
                            style: AppTextStyle.getTextStyle14FontWeightw500B,
                          ),
                        ],
                      ),
                      const SizedBox(width: 40),
                      Row(
                        children: [
                          const Icon(
                            Icons.remove_red_eye,
                            size: 20,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "${widget.viewCount} views",
                            style:
                                AppTextStyle.getTextStyle12FontWeightw300Black,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Divider(
                    color: Colors.grey[300],
                  ),
                  Text(
                    "Opening Hours",
                    style: AppTextStyle.getTextStyle18FontWeightBold,
                  ),
                  const SizedBox(height: 20),
                  _viewModel.salonTiming.length > 0
                      ? timeRow(_viewModel.salonTiming[0])
                      : SizedBox(),
                  const SizedBox(height: 20),
                  Container(
                    child: Column(
                      children: _viewModel.panels.map((panel) {
                        //int panelIndex = _viewModel.panels.indexOf(panel);
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: ExpansionTile(
                            collapsedBackgroundColor: Colors.blue.shade50,
                            enableFeedback: false,
                            title: Text(
                              "Panel ${panel.id} - ${panel.name ?? "Unnamed Panel"}",
                              style: AppTextStyle.getTextStyle16FontWeightw600,
                            ),
                            trailing: Text(
                              "Queue - ${panel.queueCount ?? 0}",
                              style: AppTextStyle.getTextStyle14FontWeightw300B,
                            ),
                            children: List.generate(
                              _homePageViewModel.services.length,
                              (serviceIndex) {
                                final service = _homePageViewModel.services[serviceIndex];
                                final List<String> promoImages = (service.promoImage ?? '').split(',').map((s) => s.trim()).toList();
                                final String salonServiceProviderImage = (promoImages.isNotEmpty && promoImages[0].isNotEmpty)
                                    ? '$BASE_URL/uploads/${promoImages[0]}' : dummyimage;
                                if (service.serviceProviderId == panel.serviceProviderId) {
                                  return CardWidget(
                                    title: service.name ?? "Unnamed Service",
                                    subtitle: "${service.price ?? 0}",
                                    imagePath: salonServiceProviderImage ?? '',
                                    serivceId: service.id!,
                                    isSelected: _viewModel.selectedServices.any(
                                        (item) => item['id'] == service.id.toString() && item['panelId'] == panel.id.toString()),
                                    onServiceAdded: (title, subtitle, imagePath, serviceId, panelId) {
                                      _viewModel.onServiceAdded(
                                        title, subtitle, imagePath, serviceId, panelId,
                                      );
                                    },
                                    onServiceRemoved: (int serviceId, int panelId) =>
                                            _viewModel.onServiceRemoved(serviceId,panelId,),
                                    panelId: panel.id!,
                                  );
                                }
                                return SizedBox.shrink();
                              },
                            ).where((widget) => widget is CardWidget).toList(), // Remove empty widgets
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    child: CustomButtonWidget(
                      text: '${_viewModel.selectedServices.length} service(s) added',
                      onPressed: () async {
                        final panel = _viewModel.panels[_viewModel.panelsIndex];
                        int panelIndex = _viewModel.panels.indexOf(panel);
                        DateTime now = DateTime.now();
                        String scheduledDate =
                            DateFormat('yyyy-MM-dd').format(now);
                        panelId = panel.id!;
                        try {
                          Get.to(() => BookingScreen2Top(
                                selectedServices: _viewModel.selectedServices,
                                salonName: widget.userName,
                                address: widget.address,
                                imagePath: widget.imagePath,
                                scheduledDate: scheduledDate,
                                averageRating: widget.averageRating,
                                totalRatings: widget.totalRatings,
                                panelId: panelId,
                                mobileNumber: widget.mobileNumber,
                              ));
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content:
                                    Text('Failed to fetch booking count: $e')),
                          );
                        }
                        print("panel: $panelId");
                      },
                      buttonColor: fabricColor,
                      borderRadius: 5,
                      buttonHeight: 50,
                    ),
                  ),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Gallery",
                        style: AppTextStyle.getTextStyle17FontWeightw600B,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 120,
                    child: ListView.builder(
                      itemCount: _viewModel.panels.length,
                      itemBuilder: (context, index) {
                        final panel = _viewModel.panels[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 100,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: _homePageViewModel.services.length,
                                itemBuilder: (context, serviceIndex) {
                                  final service = _homePageViewModel.services[serviceIndex];
                                  final List<String> promoImages =
                                  (service.promoImage ?? '').split(',').map((s) => s.trim()).toList();
                                  final String salonServiceProviderImage =
                                  (promoImages.isNotEmpty && promoImages[0].isNotEmpty)
                                      ? '$BASE_URL/uploads/${promoImages[0]}' : dummyimage;
                                  if (service.serviceProviderId == panel.serviceProviderId) {
                                    return GestureDetector(
                                      onTap: () {_showFullScreenImage(context, salonServiceProviderImage);},
                                      child: Padding(
                                        padding: const EdgeInsets.only(right: 10, bottom: 8),
                                        child: imageCard(salonServiceProviderImage),
                                      ),
                                    );
                                  }
                                  return SizedBox.shrink();
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Reviews",
                        style: AppTextStyle.getTextStyle17FontWeightw600B,
                      ),
                      Text(
                        "View All",
                        style: AppTextStyle.getTextStyle15FontWeightw600Green,
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  revewCard(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  revewCard() {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipOval(
            child: Image.asset(
              "assets/icons/gallery3.png",
              fit: BoxFit.cover,
              width: 60,
              height: 60,
            ),
          ),
          const SizedBox(width: 40),
          Expanded(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(width: 15),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Annie",
                          style: AppTextStyle.getTextStyle15FontWeightw600,
                        ),
                        Text(
                          "2 days ago",
                          style: AppTextStyle.getTextStyle13FontWeightw600G,
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.star, size: 18),
                  const SizedBox(width: 15),
                  Text(
                    "The place was clean, great serivce, stall are\nfriendly. I will certainly recommend to my\nfriends and visit again! ;)",
                    style: AppTextStyle.getTextStyle12FontWeightw400B,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showFullScreenImage(BuildContext context, String imageUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenImagePage(imageUrl: imageUrl),
      ),
    );
  }


  Widget imageCard(String imagePath) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
      child: CachedNetworkImage(
        fit: BoxFit.cover,
        imageUrl: imagePath,
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
          ),
        ),
        placeholder: (context, url) => Center(child: CircularProgressIndicator()),
        errorWidget: (context, url, error) => Icon(Icons.error),
      ),
    );
  }

  Widget panelContainer(String title, String text) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppTextStyle.getTextStyle16FontWeightw600,
          ),
          Text(
            text,
            style: AppTextStyle.getTextStyle14FontWeightw300B,
          ),
        ],
      ),
    );
  }

  timeRow(SalonTiming salonTimings) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Today",
                style: AppTextStyle.getTextStyle15FontWeightw400G,
              ),
              Text(
                "${formatTime(salonTimings.startTime!)} - ${formatTime(salonTimings.endTime!)}",
                style: AppTextStyle.getTextStyle14FontWeightw500B,
              ),
            ],
          ),
        ),
        salonTimings.lunchStart != null && salonTimings.lunchEnd != null
            ? Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Lunch Time",
                      style: AppTextStyle.getTextStyle15FontWeightw400G,
                    ),
                    Text(
                      "${formatTime(salonTimings.lunchStart!)} - ${formatTime(salonTimings.lunchEnd!)}",
                      style: AppTextStyle.getTextStyle14FontWeightw500B,
                    ),
                  ],
                ),
              )
            : SizedBox(),
      ],
    );
  }

  topImage(BuildContext context) {
    return Stack(
      children: [
        CachedNetworkImage(
          height: 250,
          fit: BoxFit.cover,
          imageUrl: widget.imagePath,
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                  colorFilter: const ColorFilter.mode(
                      Colors.transparent, BlendMode.colorBurn)),
            ),
          ),
          placeholder: (context, url) =>
              const Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
        Positioned(
          left: 16,
          top: 100,
          child: Container(
            height: 60,
            width: 60,
            decoration: const BoxDecoration(
                color: Colors.white38, shape: BoxShape.circle),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.black,
                size: 30,
              ),
              onPressed: () {
                if (_viewModel.selectedServices.length > 0) {
                  CustomSnackBar.showSnackBar(
                      "All the selected services will be removed");
                  _viewModel.selectedServices.clear();
                }
                Get.back();
              },
            ),
          ),
        ),
        Positioned(
          right: 16,
          top: 100,
          child: Row(
            children: [
              Container(
                height: 60,
                width: 60,
                decoration: const BoxDecoration(
                    color: Colors.white38, shape: BoxShape.circle),
                child: IconButton(
                  icon: const Icon(
                    Icons.favorite_border,
                    color: Colors.red,
                    size: 30,
                  ),
                  onPressed: () {
                    // Handle favorite action
                  },
                ),
              ),
              const SizedBox(width: 12),
              Container(
                height: 60,
                width: 60,
                decoration: const BoxDecoration(
                    color: Colors.white38, shape: BoxShape.circle),
                child: IconButton(
                  icon: const Icon(
                    Icons.navigation_sharp,
                    color: fabricColor,
                    size: 35,
                  ),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String formatTime(String time) {
    String formattedTime = "";
    try {
      final DateTime parsedTime = DateFormat("HH:mm").parse(time);
      formattedTime = DateFormat("h:mm a").format(parsedTime);
    } catch (e) {}
    return formattedTime;
  }

  @override
  void dispose() {
    _viewModel.clearData();
    super.dispose();
  }
}

class CardWidget extends StatefulWidget {
  final String title;
  final String subtitle;
  final String imagePath;
  final int serivceId;
  final int panelId;
  final bool isSelected;
  final Function onServiceAdded;
  final Function onServiceRemoved; // Add this line

  const CardWidget({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.serivceId,
    required this.onServiceAdded,
    required this.isSelected,
    required this.onServiceRemoved,
    required this.panelId,
  }) : super(key: key);

  @override
  _CardWidgetState createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  void _toggleService() {
    if (widget.isSelected) {
      widget.onServiceRemoved(widget.serivceId, widget.panelId);
    } else {
      widget.onServiceAdded(widget.title, widget.subtitle, widget.imagePath,
          widget.serivceId, widget.panelId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: Colors.white,
      child: SizedBox(
        height: 100,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 70,
              height: double.infinity,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
              ),
              child: CachedNetworkImage(
                imageUrl: widget.imagePath,
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomLeft: Radius.circular(8),
                    ),
                    image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                        colorFilter: const ColorFilter.mode(
                            Colors.transparent, BlendMode.colorBurn)),
                  ),
                ),
                placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.title,
                    style: AppTextStyle.getTextStyle16FontWeightw600,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.subtitle,
                    style: AppTextStyle.getTextStyle15FontWeightw600FabricColor,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: GestureDetector(
                onTap: _toggleService,
                child: widget.isSelected
                    ? const Icon(
                        Icons.remove_circle_outline,
                        color: Colors.red,
                        size: 35,
                      )
                    : Container(
                        height: 40,
                        width: 40,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: fabricColor,
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.add,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
