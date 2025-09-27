import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import '../home_screen/home_screen_viewmodel.dart';
import '../service_provider_details/service_provider_detail_page.dart';
import '../utils/app_strings.dart';
import '../utils/app_text_style.dart';
import '../utils/colors.dart';
import '../utils/common_method.dart';
import '../utils/common_variables.dart';
import '../utils/constants.dart';
import '../widget/custom_button.dart';
import 'filter_salon_provider_viewmodel.dart';

class FilterSalonProviderPage extends StatefulWidget {
  const FilterSalonProviderPage({super.key});
  @override
  State<FilterSalonProviderPage> createState() => _FilterSalonProviderPageState();
}
class _FilterSalonProviderPageState extends State<FilterSalonProviderPage> {
  late FilterSalonProviderViewModel _viewModel;
 // late FilterViewModel _filterViewModel;
  late HomeScreenViewModel _homeScreenViewModel;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _viewModel.fetchSalonServiceProvidersData();

    });
  }
  @override
  Widget build(BuildContext context) {
    _viewModel = context.watch<FilterSalonProviderViewModel>();
    //_filterViewModel = context.watch<FilterViewModel>();
    _homeScreenViewModel = context.watch<HomeScreenViewModel>();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
            //Get.back();
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
            size: 22,
          ),
        ),
        title: Center(
          child: Text(
            "Filter",
            style: AppTextStyle.getTextStyle16FontWeightw600,
          ),
        ),
        actions: [Container(height: 10,width: 10,color: Colors.transparent,),],
        centerTitle: true,
      ),
      body: _viewModel.isLoading
        ? const Center(child: CircularProgressIndicator())
      : _viewModel.filterServiceProvider.isEmpty
        ? const Text('Data Not Found')
      : SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
                _viewModel.filterServiceProvider.length, (index) {
              final salonServiceProvider = _viewModel.filterServiceProvider[index];
              final List<String> promoImages = (salonServiceProvider.imageUrl ?? '').split(',').map((s) => s.trim()).toList();
              final String salonServiceProviderImage = (promoImages.isNotEmpty && promoImages[0].isNotEmpty) ? '$BASE_URL/uploads/${promoImages[0]}' : dummyimage;
              return bottomCard(
                salonServiceProvider.id!,
                salonServiceProviderImage,
                displayServiceNames(salonServiceProvider) ?? 'Unknown Service',
                salonServiceProvider.salonName ?? 'Unknown Salon',
                salonServiceProvider.address ?? 'Unknown Address',
                salonServiceProvider.averageRating!.toDouble(),
                salonServiceProvider.totalRatings!,
                _viewModel,
                context,
                    () async {
                  serviceProviderId = salonServiceProvider.id!;
                  await _homeScreenViewModel.increaseViewCount(serviceProviderId);
                  Get.to(() => ServiceProviderDetailPage(
                    userName: salonServiceProvider.salonName ?? 'Unknown Salon',
                    address: salonServiceProvider.address ?? 'Unknown Address',
                    imagePath: salonServiceProviderImage ,
                    viewCount: salonServiceProvider.viewCount!,
                    averageRating: salonServiceProvider.averageRating!.toDouble(),
                    totalRatings: salonServiceProvider.totalRatings,
                    mobileNumber: salonServiceProvider.mobileNumber ?? "",
                  ));
                },
              );
            }),
          ),
        ),
      ),
    );
  }

  String displayServiceNames(salonServiceProvider) {
    final serviceNamesList = (salonServiceProvider.serviceNames ?? '').split(',').map((s) => s.trim()).toList();
    if (serviceNamesList.isEmpty || (serviceNamesList.length == 1 && serviceNamesList[0].isEmpty)) {
      return 'Unknown Service';
    }
    if (serviceNamesList.length <= 2) { return serviceNamesList.join(', ');}
    return '${serviceNamesList.take(2).join(', ')} +${serviceNamesList.length - 2}';
  }

  Widget bottomCard(
      int id,
      String imagePath,
      String title,
      String salonName,
      String address,
      double averageRating,
      int totalRating,
      viewModel,
      BuildContext context,
      VoidCallback onPressed,
      ) {
    // Check if the service is already favorited
    bool isFavorited = _homeScreenViewModel.favoriteService.any(
            (service) =>
        service.serviceProviderId == id);


    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 150,
            height: 145,
            margin: const EdgeInsets.all(8),
            child: CachedNetworkImage(
              imageUrl: imagePath,
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
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title.isNotEmpty ? title : 'No Name',
                        style: AppTextStyle.getTextStyle12FontWeightw300,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        salonName.isNotEmpty ? salonName : 'No Title',
                        style: AppTextStyle.getTextStyle18FontWeightBold,
                      ),
                      Text(
                        address.isNotEmpty ? address : 'No Address',
                        style: const TextStyle(
                          fontSize: 12,
                          
                          fontWeight: FontWeight.w400,
                          color: Colors.grey,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16.0),
                          const SizedBox(width: 4),
                          Text(
                            '${formatAverageRating(averageRating)} (${totalRating}) Rating',
                            style: AppTextStyle.getTextStyle14FontWeight,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 40,
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: const Color(0xffE6F4F4),
                        ),
                        child: IconButton(
                          icon: Icon(
                            isFavorited ? Icons.favorite : Icons.favorite_border,
                            color: isFavorited ? fabricColor : Colors.black,
                          ),
                          onPressed: () {
                            // // Toggle favorite status
                            // final isFavorited = viewModel.favoriteService.any((service) => service.salonName == salonName);

                            if (isFavorited) {
                              _homeScreenViewModel.removeFavorite(id);
                            } else {
                              _homeScreenViewModel.addFavorite(id);
                            }
                             _viewModel.refreshUI(); // Notify changes to update UI
                          },

                        ),
                      ),
                      const SizedBox(width: 25),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 6),
                          child: CustomButtonWidget(
                            text: AppString.book,
                            textColor: Colors.white,
                            onPressed: () async {
                              // Call the passed onPressed function
                              onPressed(); // Execute the onPressed callback
                            },
                            buttonColor: fabricColor,
                            borderRadius: 5,
                            buttonHeight: 40,
                          ),
                        ),
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
}
