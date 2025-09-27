import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import 'package:wellwait_app/models/service_provider_model.dart';
import '../Screens/Filter/filter_screen.dart';
import '../Screens/notification/notification_screen.dart';
import '../Screens/search_screen/search_page.dart';
import '../Screens/search_screen/search_viewmodel.dart';
import '../booking_pending/booking_pending_page.dart';
import '../edit_profile/edit_profile.dart';
import '../edit_profile/edit_profile_viewmodel.dart';
import '../favorite_service/favorite_service_page.dart';
import '../models/categories.dart';
import '../past_booking/past_booking_page.dart';
import '../phone_number_login/phone_number_login_page.dart';
import '../schedule/schedule_viewmodel.dart';
import '../service_detail/service_detail_page.dart';
import '../service_provider_details/service_provider_detail_page.dart';
import '../settings/settings_page.dart';
import '../utils/app_strings.dart';
import '../utils/app_text_style.dart';
import '../utils/colors.dart';
import '../utils/common_card.dart';
import '../utils/common_method.dart';
import '../utils/common_variables.dart';
import '../utils/constants.dart';
import '../utils/sp_helper.dart';
import 'home_screen_viewmodel.dart';

class HomeScreenPage extends StatefulWidget {
  const HomeScreenPage({super.key});

  @override
  State<HomeScreenPage> createState() => _HomeScreenPageState();
}

class _HomeScreenPageState extends State<HomeScreenPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      print(userId);
      // fetchLocation();
      _viewModel.updateFcmToken();
      _viewModel.fetchData();
      _viewModel.fetchServiceData();
      _viewModel.fetchFavorite();
      _viewModel.fetchSalonServiceProvidersData();
      _searchViewModel.fetchSearchCount();
      //print("home userProfileImage: ${userProfileImage}");
    });
  }

  late HomeScreenViewModel _viewModel;
  late EditProfileViewModel _editProfileViewModel;
  late ScheduleViewModel _scheduleViewModel;
  late SearchViewModel _searchViewModel;

  @override
  Widget build(BuildContext context) {
    _viewModel = context.watch<HomeScreenViewModel>();
    _editProfileViewModel = context.watch<EditProfileViewModel>();
    _scheduleViewModel = Provider.of<ScheduleViewModel>(context, listen: false);
    _searchViewModel = Provider.of<SearchViewModel>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello, ${userName.toString()}',
              style: AppTextStyle.getTextStyle12FontWeightw700,
            ),
            Text(
              'Find the service you want, and treat yourself',
              style: AppTextStyle.getTextStyle12FontWeightw400,
            ),
          ],
        ),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(
                    getProfileImage(userProfileImage)), // Use NetworkImage here
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer(); // Open the drawer
              },
            );
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: IconButton(
              icon: Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: fabricColor,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: SvgPicture.asset(
                    'assets/icons/BellBing.svg',
                    width: 24,
                    height: 24,
                    color: Colors.white,
                  ),
                ),
              ),
              onPressed: () {
                Get.to(() => NotificationScreen());
              },
            ),
          ),
        ],
      ),
      drawer: _buildDrawer(context),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            topScreenItems(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                AppString.whatDoYouWant,
                style: AppTextStyle.getTextStyle20FontWeightw600,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: _buildCategoryButton(AppString.women),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: _buildCategoryButton(AppString.men),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: _buildCategoryButton(AppString.kids),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: _buildServiceList(
                    _viewModel.subcategory[_viewModel.selectedServiceFor]!),
              ),
            ),
            const SizedBox(height: 14),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppString.topRatedSalon,
                    style: AppTextStyle.getTextStyle20FontWeightBold,
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      AppString.viewAll,
                      style: AppTextStyle.getTextStyle15FontWeight,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              height: 320,
              child: _viewModel.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _viewModel.serviceProvider.length,
                      itemBuilder: (context, index) {
                        final salonServiceProvider =
                            _viewModel.serviceProvider[index];
                        final List<String> promoImages =
                            (salonServiceProvider.imageUrl ?? '')
                                .split(',')
                                .map((s) => s.trim())
                                .toList();
                        final String salonServiceImage =
                            (promoImages.isNotEmpty &&
                                    promoImages[0].isNotEmpty)
                                ? '$BASE_URL/uploads/${promoImages[0]}'
                                : dummyimage;
                        salonName =
                            salonServiceProvider.salonName ?? 'Unknown Type';
                        final String salonServiceAddress =
                            salonServiceProvider.address ?? 'Unknown Location';
                        bool isFavorite = _viewModel.favoriteService.any(
                            (service) =>
                                service.serviceProviderId ==
                                salonServiceProvider.id);
                        return Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: InkWell(
                            onTap: () async {
                              serviceProviderId = salonServiceProvider.id!;
                              await _viewModel
                                  .increaseViewCount(serviceProviderId);
                              mobileNumber = salonServiceProvider.mobileNumber!;
                              Get.to(() => ServiceProviderDetailPage(
                                    userName: salonName,
                                    address: salonServiceAddress,
                                    imagePath: salonServiceImage,
                                    viewCount: salonServiceProvider.viewCount!,
                                    averageRating: salonServiceProvider
                                        .averageRating!
                                        .toDouble(),
                                    totalRatings:
                                        salonServiceProvider.totalRatings!,
                                    mobileNumber:
                                        salonServiceProvider.mobileNumber ?? "",
                                  ));
                            },
                            child: SizedBox(
                              width: 200,
                              height: 300,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Stack(
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        height: 180,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(14),
                                        ),
                                        child: CachedNetworkImage(
                                          imageUrl: salonServiceImage,
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          placeholder: (context, url) =>
                                              const Center(
                                                  child:
                                                      CircularProgressIndicator()),
                                          errorWidget: (context, url, error) {
                                            return const Icon(Icons.error);
                                          },
                                        ),
                                      ),
                                      Positioned(
                                        top: 8.0,
                                        right: 8.0,
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              if (isFavorite) {
                                                _viewModel.removeFavorite(
                                                    salonServiceProvider.id);
                                              } else {
                                                _viewModel.addFavorite(
                                                    salonServiceProvider.id);
                                              }
                                            });
                                          },
                                          child: Container(
                                            height: 40,
                                            width: 40,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: isFavorite
                                                  ? Colors.transparent
                                                  : fabricColor,
                                            ),
                                            child: Icon(
                                              isFavorite
                                                  ? Icons.favorite
                                                  : Icons.favorite_border,
                                              color: isFavorite
                                                  ? fabricColor
                                                  : Colors.white,
                                              size: 30,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8.0),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        displayServiceNames(
                                            salonServiceProvider),
                                        style: AppTextStyle
                                            .getTextStyle12FontWeight,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: false,
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        salonName,
                                        style: AppTextStyle
                                            .getTextStyle17FontWeightw600,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        salonServiceAddress,
                                        style: AppTextStyle
                                            .getTextStyle17FontWeightw400,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: false,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                        size: 16.0,
                                      ),
                                      const SizedBox(width: 4.0),
                                      Text(
                                        '${formatAverageRating(salonServiceProvider.averageRating!.toDouble())} (${salonServiceProvider.totalRatings}) Rating',
                                        style: AppTextStyle
                                            .getTextStyle15FontWeightw500,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 16),
            Container(
              margin: const EdgeInsets.only(left: 15, right: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text(
                  //   AppString.mostSearchInterest,
                  //   style: AppTextStyle.getTextStyle20FontWeightw600B,
                  // ),
                  // const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppString.mostSearchInterest,
                        style: AppTextStyle.getTextStyle20FontWeightw600B,
                      ),
                      const SizedBox(height: 10),
                      itemsContainer(),
                      SizedBox(height: 20),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Container(
              margin: const EdgeInsets.only(left: 15, right: 15),
              width: double.infinity,
              child: Row(
                children: [
                  Expanded(
                    child: CupertinoSlidingSegmentedControl<int>(
                      thumbColor: fabricColor,
                      backgroundColor: const Color(0xffE6F4F4),
                      children: {
                        0: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Center(
                                child: Text(
                              AppString.all,
                              style: TextStyle(
                                color: _viewModel.selectedSegment == 0
                                    ? Colors.white
                                    : Colors.grey,
                                fontWeight: FontWeight.w600,
                              ),
                            )),
                          ),
                        ),
                        1: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Center(
                                  child: Text(AppString.nearBy,
                                      style: TextStyle(
                                        color: _viewModel.selectedSegment == 1
                                            ? Colors.white
                                            : Colors.grey,
                                        fontWeight: FontWeight.w600,
                                      )))),
                        ),
                      },
                      groupValue: _viewModel.selectedSegment,
                      onValueChanged: (int? value) {
                        setState(() {
                          _viewModel.selectedSegment = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 15),
                  Container(
                    height: 42,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: const Color(0xffE6F4F4),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(
                        child: Icon(
                          Icons.menu,
                          size: 20,
                          color: Colors.teal,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (_viewModel.selectedSegment == 0)
              _viewModel.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(
                              _viewModel.serviceProvider.length, (index) {
                            final salonServiceProvider =
                                _viewModel.serviceProvider[index];
                            bool isFavorited = _viewModel.favoriteService.any(
                                (service) =>
                                    service.serviceProviderId ==
                                    salonServiceProvider.id);
                            final List<String> promoImages =
                                (salonServiceProvider.imageUrl ?? '')
                                    .split(',')
                                    .map((s) => s.trim())
                                    .toList();
                            final String salonServiceProviderImage =
                                (promoImages.isNotEmpty &&
                                        promoImages[0].isNotEmpty)
                                    ? '$BASE_URL/uploads/${promoImages[0]}'
                                    : dummyimage;
                            return CardPage(
                              id: salonServiceProvider.id!,
                              imagePath: salonServiceProviderImage,
                              title:
                                  displayServiceNames(salonServiceProvider) ??
                                      'Unknown Service',
                              salonName: salonServiceProvider.salonName ??
                                  'Unknown Salon',
                              address: salonServiceProvider.address ??
                                  'Unknown Address',
                              averageRating: salonServiceProvider.averageRating!
                                  .toDouble(),
                              totalRating: salonServiceProvider.totalRatings!,
                              icon: IconButton(
                                icon: Icon(
                                  isFavorited
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color:
                                      isFavorited ? fabricColor : Colors.black,
                                ),
                                onPressed: () {
                                  if (isFavorited) {
                                    _viewModel.removeFavorite(
                                        salonServiceProvider.id);
                                  } else {
                                    _viewModel
                                        .addFavorite(salonServiceProvider.id);
                                  }
                                },
                              ),
                              onPressed: () async {
                                serviceProviderId = salonServiceProvider.id!;
                                _viewModel.increaseViewCount(serviceProviderId);
                                Get.to(() => ServiceProviderDetailPage(
                                      userName:
                                          salonServiceProvider.salonName ??
                                              'Unknown Salon',
                                      address: salonServiceProvider.address ??
                                          'Unknown Address',
                                      imagePath: salonServiceProviderImage,
                                      viewCount:
                                          salonServiceProvider.viewCount!,
                                      averageRating: salonServiceProvider
                                          .averageRating!
                                          .toDouble(),
                                      totalRatings:
                                          salonServiceProvider.totalRatings,
                                      mobileNumber:
                                          salonServiceProvider.mobileNumber ??
                                              "",
                                    ));
                              },
                            );

                            //   bottomCard(
                            //   salonServiceProvider.id!,
                            //   salonServiceProviderImage,
                            //   displayServiceNames(salonServiceProvider) ?? 'Unknown Service',
                            //   salonServiceProvider.salonName ?? 'Unknown Salon',
                            //   // service.rating?.toString() ?? 'No Rating',
                            //   salonServiceProvider.address ?? 'Unknown Address',
                            //   // service.id!,
                            //   // service.viewCount!,
                            //   salonServiceProvider.averageRating!.toDouble(),
                            //   salonServiceProvider.totalRatings!,
                            //   _viewModel,
                            //   context,
                            //       () async {
                            //         serviceProviderId = salonServiceProvider.id!;
                            //         await _viewModel.increaseViewCount(serviceProviderId);
                            //         Get.to(() => ServiceProviderDetailPage(
                            //           userName: salonServiceProvider.salonName ?? 'Unknown Salon',
                            //           address: salonServiceProvider.address ?? 'Unknown Address',
                            //           imagePath: salonServiceProviderImage ,
                            //           viewCount: salonServiceProvider.viewCount!,
                            //           averageRating: salonServiceProvider.averageRating!.toDouble(),
                            //           totalRatings: salonServiceProvider.totalRatings,
                            //         ));
                            //   },
                            // );
                          }),
                        ),
                      ),
                    )
          ],
        ),
      ),
    );
  }

  String displayServiceNames(ServicesProvider salonServiceProvider) {
    // final serviceNamesList = (salonServiceProvider.serviceNames ?? '')
    //     .split(',')
    //     .map((s) => s.trim())
    //     .toList();
    final serviceNamesList =
        salonServiceProvider.services.map((item) => item.name ?? "").toList();
    if (serviceNamesList.isEmpty ||
        (serviceNamesList.length == 1 && serviceNamesList[0].isEmpty)) {
      return ' ';
    }
    if (serviceNamesList.length <= 2) {
      return serviceNamesList.join(', ');
    }
    return '${serviceNamesList.take(2).join(', ')} +${serviceNamesList.length - 2}';
  }

  topScreenItems() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              width: double.infinity,
              height: 45.97,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 16.0),
                    child: Icon(Icons.search, color: Color(0xFF009688)),
                  ),
                  Expanded(
                    child: GestureDetector(
                        onTap: () async {
                          await _viewModel.increaseViewCount(serviceProviderId);
                          Get.to(() => SearchPage());
                        },
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              "search",
                              style: AppTextStyle.getTextStyle14FontWeightw,
                            ),
                          ),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: GestureDetector(
                      onTap: () {
                        Get.to(() => FilterScreen());
                      },
                      child: SvgPicture.asset(
                        'assets/icons/filter.svg',
                        width: 17.5,
                        height: 11.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Container(
            width: double.infinity, // Width set to 361
            height: 159, // Height set to 159
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Stack(
              children: [
                // Background image
                Positioned.fill(
                  child: SvgPicture.asset(
                    'assets/icons/Shop.svg', // Original image path
                    //fit: BoxFit.cover, // Fit image to cover the container
                  ),
                ),
                Positioned(
                  left: 16,
                  top: 16,
                  child: Text(
                    AppString.lookMoreBeautiful,
                    style: AppTextStyle.getTextStyle18FontWeightw600,
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.asset(
                    'assets/container.png',
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryButton(String serviceFor) {
    bool isSelected = _viewModel.selectedServiceFor == serviceFor;
    return SizedBox(
      width: 100,
      height: 35,
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _viewModel.updateCategory(serviceFor); // Update selected category
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Colors.teal : Colors.white,
          foregroundColor: isSelected ? Colors.white : Colors.teal,
          side: const BorderSide(color: Colors.teal),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          padding: const EdgeInsets.symmetric(horizontal: 20),
        ),
        child: Text(
          serviceFor,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _buildServiceList(List<Subcategories> services) {
    if (_viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return Wrap(
      spacing: 30.0,
      runSpacing: 30.0,
      children: services.map((service) {
        subCategoryId = service.id;
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () async {
                Get.to(() => ServiceDetailPage(
                    serviceName: service.name ?? 'Unknown Service'));
              },
              child: Container(
                height: 60,
                width: 60,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xffE6F4F4),
                ),
                child: Center(
                  child: SvgPicture.string(
                    service.icon!,
                    placeholderBuilder: (BuildContext context) => Container(
                      padding: const EdgeInsets.all(20.0),
                      child: const CircularProgressIndicator(),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4), // Space between icon and text
            Text(
              service.name ?? '',
              style: AppTextStyle.getTextStyle12FontWeightw600,
            ), // Display the service name
          ],
        );
      }).toList(),
    );
  }

  // itemsContainer() {
  //   // SvgPicture.string(
  //   //   service.icon!,
  //   //   placeholderBuilder: (BuildContext context) => Container(
  //   //     padding: const EdgeInsets.all(20.0),
  //   //     child: const CircularProgressIndicator(),
  //   //   ),
  //   // ),
  //   return Container(
  //     height: 50,
  //     width: 140,
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(15),
  //       color: const Color(0xffEDF6F6),
  //     ),
  //     child: ListView.builder(
  //       scrollDirection: Axis.horizontal,
  //       itemCount: _searchViewModel.searchCount.length,
  //       itemBuilder: (context, index) {
  //         final subcategory = _searchViewModel.searchCount[index];
  //         return Padding(
  //           padding: const EdgeInsets.all(8.0),
  //           child: Center(
  //             child: Row(
  //               children: [
  //                 SvgPicture.asset(subcategory.icon.toString()),
  //                 const SizedBox(width: 15),
  //                 Text(
  //                   subcategory.name.toString() ?? 'Unknown',
  //                   style: AppTextStyle.getTextStyle14FontWeightw300,
  //                 ),
  //               ],
  //             ),
  //           ),
  //         );
  //
  //         //   ListTile(
  //         //   title: Text(subcategory.name ?? 'Unknown'), // Assuming `name` is a field in `Subcategories`
  //         //   trailing: Text(
  //         //     '${subcategory.searchCount}', // Assuming `searchCount` is a field in `Subcategories`
  //         //     style: const TextStyle(fontWeight: FontWeight.bold),
  //         //   ),
  //         // );
  //       },
  //     ),
  //
  //
  //
  //
  //     // Padding(
  //     //   padding: const EdgeInsets.all(8.0),
  //     //   child: Center(
  //     //     child: Row(
  //     //       children: [
  //     //         SvgPicture.asset(imagePath),
  //     //         const SizedBox(width: 15),
  //     //         Text(
  //     //           text,
  //     //           style: AppTextStyle.getTextStyle14FontWeightw300,
  //     //         ),
  //     //       ],
  //     //     ),
  //     //   ),
  //     // ),
  //   );
  // }

  Widget beautyfulWidget(String text, String icon, Color bgColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                SvgPicture.string(
                  icon,
                  height: 35,
                  width: 35,
                ),
                const SizedBox(width: 8),
                Text(
                  text,
                  style: AppTextStyle.getTextStyle14FontWeightw300,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget itemsContainer() {
    var filteredSubcategories = _searchViewModel.searchCount
        .where((subcategory) =>
            subcategory.searchCount != null && subcategory.searchCount! > 1)
        .toList();

    var uniqueSubcategories = {
      for (var subcategory in filteredSubcategories)
        subcategory.name: subcategory
    }.values.toList();
    uniqueSubcategories
        .sort((a, b) => b.searchCount!.compareTo(a.searchCount!));
    filteredSubcategories = uniqueSubcategories.take(5).toList();

    if (filteredSubcategories.isEmpty) {
      return const SizedBox.shrink();
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (var subcategory in filteredSubcategories)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: beautyfulWidget(
                subcategory.name.toString() ?? 'Unknown',
                subcategory.icon.toString(),
                const Color(0xffEDF6F6), // Background color for each container
              ),
            ),
        ],
      ),
    );
  }

  // Widget bottomCard(
  //     int id,
  //     String imagePath,
  //     String title,
  //     String salonName,
  //     String address,
  //     double averageRating,
  //     int totalRating,
  //     HomeScreenViewModel viewModel,
  //     BuildContext context,
  //     VoidCallback onPressed,
  //     ) {
  //   // Check if the service is already favorited
  //   bool isFavorited = favoriteList.contains(id);
  //
  //   return Card(
  //     color: Colors.white,
  //     margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
  //     child: Row(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Container(
  //           width: 150,
  //           height: 145,
  //           margin: const EdgeInsets.all(8),
  //           child: CachedNetworkImage(
  //             imageUrl: imagePath,
  //             imageBuilder: (context, imageProvider) => Container(
  //               decoration: BoxDecoration(
  //                 borderRadius: BorderRadius.circular(8),
  //                 image: DecorationImage(
  //                   image: imageProvider,
  //                   fit: BoxFit.cover,
  //                   colorFilter: const ColorFilter.mode(Colors.transparent, BlendMode.colorBurn),
  //                 ),
  //               ),
  //             ),
  //             placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
  //             errorWidget: (context, url, error) => const Icon(Icons.error),
  //           ),
  //         ),
  //         Expanded(
  //           child: Column(
  //             children: [
  //               Padding(
  //                 padding: const EdgeInsets.all(8.0),
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Text(
  //                       title.isNotEmpty ? title : 'No Name',
  //                       style: AppTextStyle.getTextStyle12FontWeightw300,
  //                       maxLines: 1,
  //                       overflow: TextOverflow.ellipsis,
  //                       softWrap: false,
  //                     ),
  //                     const SizedBox(height: 6),
  //                     Text(
  //                       salonName.isNotEmpty ? salonName : 'No Title',
  //                       style: AppTextStyle.getTextStyle18FontWeightBold,
  //                     ),
  //                     Text(
  //                       address.isNotEmpty ? address : 'No Address',
  //                       style: const TextStyle(
  //                         fontSize: 12,
  //
  //                         fontWeight: FontWeight.w400,
  //                         color: Colors.grey,
  //                       ),
  //                       maxLines: 1,
  //                       overflow: TextOverflow.ellipsis,
  //                       softWrap: false,
  //                     ),
  //                     const SizedBox(height: 6),
  //                     Row(
  //                       children: [
  //                         const Icon(Icons.star, color: Colors.amber, size: 16.0),
  //                         const SizedBox(width: 4),
  //                         Text(
  //                           '${formatAverageRating(averageRating)} (${totalRating}) Rating',
  //                           style: AppTextStyle.getTextStyle14FontWeight,
  //                         ),
  //                       ],
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //               const SizedBox(height: 10),
  //               Padding(
  //                 padding: const EdgeInsets.symmetric(horizontal: 8.0),
  //                 child: Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     Container(
  //                       height: 40,
  //                       margin: const EdgeInsets.only(bottom: 10),
  //                       decoration: BoxDecoration(
  //                         borderRadius: BorderRadius.circular(12),
  //                         color: const Color(0xffE6F4F4),
  //                       ),
  //                       child: IconButton(
  //                         icon: Icon(
  //                           isFavorited ? Icons.favorite : Icons.favorite_border,
  //                           color: isFavorited ? fabricColor : Colors.black,
  //                         ),
  //                         onPressed: () {
  //                           // // Toggle favorite status
  //                           // final isFavorited = viewModel.favoriteService.any((service) => service.salonName == salonName);
  //
  //                           if (isFavorited) {
  //                             // Remove from favorites
  //                            // viewModel.favoriteService.removeWhere((service) => service.salonName == salonName);
  //                             _viewModel.favoriteService.removeWhere(
  //                                     (service) => service.salonName == salonName);
  //                           } else {
  //                             // Add to favorites
  //                             _viewModel.addFavorite(id);
  //                             // _viewModel.favoriteService.add(
  //                             //   Favorite(
  //                             //     serviceProviderId: serviceProviderId,
  //                             //     salonName: salonName,
  //                             //     address: address,
  //                             //     photo: imagePath,
  //                             //     averageRating: averageRating.toString(),
  //                             //   ),
  //                             // );
  //                           }
  //                           _viewModel.refreshUI(); // Notify changes to update UI
  //                         },
  //
  //                       ),
  //                     ),
  //                     const SizedBox(width: 25),
  //                     Expanded(
  //                       child: Container(
  //                         margin: const EdgeInsets.only(bottom: 6),
  //                         child: CustomButtonWidget(
  //                           text: AppString.book,
  //                           textColor: Colors.white,
  //                           onPressed: () async {
  //                             // Call the passed onPressed function
  //                             onPressed(); // Execute the onPressed callback
  //                           },
  //                           buttonColor: fabricColor,
  //                           borderRadius: 5,
  //                           buttonHeight: 40,
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Future<void> fetchLocation() async {
    try {
      Position position = await getCurrentLocation();
      setState(() {
        location = '${position.latitude},${position.longitude}';
      });
      _viewModel.latitude = position.latitude;
      _viewModel.longitude = position.longitude;
      await _viewModel.updateUserLocation(userId!, location);
      print("location: ${location}");
    } catch (e) {
      setState(() {
        location = 'Error: $e';
      });
    }
  }

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    // Check for permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied.');
    }

    // Get current position
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  DrawerHeader(
                    decoration: const BoxDecoration(
                      color: Color(0xffEDF6F6),
                    ),
                    child: Center(
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage:
                                NetworkImage(getProfileImage(userProfileImage)),
                          ),
                          const SizedBox(width: 20),
                          Text(
                            userName.toString(),
                            style: AppTextStyle.getTextStyle12FontWeightw700,
                          ),
                        ],
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.pending, color: fabricColor),
                    title: Text(
                      AppString.pending,
                      style: AppTextStyle.getTextStyle16FontWeightw400,
                    ),
                    onTap: () {
                      Get.to(() => BookingPendingPage());
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.favorite, color: fabricColor),
                    title: Text(
                      AppString.favorite,
                      style: AppTextStyle.getTextStyle16FontWeightw400,
                    ),
                    onTap: () {
                      Get.to(() => FavoriteServicesPage());
                    },
                  ),
                  // ListTile(
                  //   leading: const Icon(Icons.notification_important, color: fabricColor),
                  //   title: Text(AppString.notification, style: AppTextStyle.getTextStyle16FontWeightw400,),
                  //   onTap: () {
                  //     Get.to(() => NotificationScreen());
                  //
                  //     // Navigator.push(
                  //     //   context,
                  //     //   MaterialPageRoute(builder: (context) => NotificationScreen()),
                  //     // );
                  //   },
                  // ),
                  ListTile(
                    leading: const Icon(Icons.credit_card, color: fabricColor),
                    title: Text(
                      AppString.pastBooking,
                      style: AppTextStyle.getTextStyle16FontWeightw400,
                    ),
                    onTap: () {
                      Get.to(() => PastBookingPage());
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.edit, color: fabricColor),
                    title: Text(
                      AppString.editProfile,
                      style: AppTextStyle.getTextStyle16FontWeightw400,
                    ),
                    onTap: () {
                      Get.to(() => EditProfilePage());
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.settings, color: fabricColor),
                    title: Text(
                      AppString.setting,
                      style: AppTextStyle.getTextStyle16FontWeightw400,
                    ),
                    onTap: () {
                      Get.to(() => SettingsPage());
                    },
                  ),
                  // ListTile(
                  //   leading: const Icon(Icons.adb, color: fabricColor),
                  //   title: Text(AppString.rewards, style: AppTextStyle.getTextStyle16FontWeightw400,),
                  //   onTap: () {
                  //     Navigator.pop(context); // Close the drawer
                  //   },
                  // ),
                  ListTile(
                    leading: const Icon(Icons.help, color: fabricColor),
                    title: Text(
                      AppString.helpAndFAQs,
                      style: AppTextStyle.getTextStyle16FontWeightw400,
                    ),
                    onTap: () {
                      Get.back();
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.privacy_tip, color: fabricColor),
                    title: Text(
                      AppString.privacyPolicy,
                      style: AppTextStyle.getTextStyle16FontWeightw400,
                    ),
                    onTap: () {
                      Get.back();
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20), // Optional space before the button
            GestureDetector(
              onTap: () {
                final SharedPreferenceService _sharedPreferenceService =
                    SharedPreferenceService();
                _sharedPreferenceService.clearCredentials();
                //Get.to(() => EmailLoginPage());
                Get.offAll(() => PhoneNumberLoginPage());
              },
              child: Container(
                height: 40,
                width: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: fabricColor,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Row(
                      children: [
                        const Icon(
                          Icons.logout,
                          color: Colors.white,
                          size: 25,
                        ),
                        const SizedBox(width: 15),
                        Text(
                          AppString.logout,
                          style: AppTextStyle.getTextStyle14FontWeightw600,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
