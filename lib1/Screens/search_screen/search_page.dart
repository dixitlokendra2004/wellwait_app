import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import 'package:wellwait_app/Screens/search_screen/search_viewmodel.dart';
import '../../admin/utils/admin_ common_variable.dart';
import '../../home_screen/home_screen_viewmodel.dart';
import '../../service_provider_details/service_provider_detail_page.dart';
import '../../service_provider_details/sp_detail_viewmodel.dart';
import '../../utils/app_strings.dart';
import '../../utils/app_text_style.dart';
import '../../utils/colors.dart';
import '../../utils/common_card.dart';
import '../../utils/common_method.dart';
import '../../utils/common_variables.dart';
import '../../utils/constants.dart';
import '../../widget/custom_button.dart';
import '../../widget/custom_textfield.dart';
import '../Filter/filter_screen.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  List<String> _recentSearches = [];
  Map<String, int> _searchFrequency = {};
  late HomeScreenViewModel _homeScreenViewModel;
  late SPDetailViewModel _spDetailViewModel;
  late SearchViewModel _viewModel;
  //List<String> popularSearches = [];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      //popularSearches = _searchFrequency.entries.where((entry) => entry.value > 1).map((entry) => entry.key).toList();
      await _viewModel.fetchSalonServiceProvidersData();
      await _spDetailViewModel.fetchSalonTimings(serviceProviderId.toString());
      await _spDetailViewModel.fetchPanels(serviceProviderId);
      await _spDetailViewModel.fetchBookingCount();
      //_homeScreenViewModel.fetchData();
      //_viewModel.fetchSearchCount();
    });
  }

  @override
  Widget build(BuildContext context) {
    _viewModel = context.watch<SearchViewModel>();
    _homeScreenViewModel = context.watch<HomeScreenViewModel>();
    _spDetailViewModel = context.watch<SPDetailViewModel>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
            _viewModel.searchController.text = '';
          },
          icon: const Icon(Icons.arrow_back_ios_new, color: fabricColor),
        ),
        title: const Center(
          child: Text(
            'Search',
            style: TextStyle(
              fontSize: 16,
              
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: () {
                Get.to(() => const FilterScreen());
              },
              child: SvgPicture.asset(
                'assets/icons/filter.svg',
                width: 18,
                height: 18,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                controller: _viewModel.searchController,
                hintText: 'Search salon or service..',
                hintTextColor: const Color(0xffADB3BC),
                textFieldColor: const Color(0xffD5ECEC),
                borderRadius: 25,
                prefixIcon: Icons.search,
                borderColor: Colors.transparent,
                iconColor: fabricColor,
                onChanged: (query) {
                  _viewModel.searchSalon(query);
                },
                onSubmitted: (query) {
                  _viewModel.fetchIncreaseSearchCount(query);
                },
              ),

              // const SizedBox(height: 20),
              // const Text(
              //   'Most Popular Search',
              //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              // ),
              // if (_viewModel.searchCount.isNotEmpty)
              //   Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: (() {
              //       // Filter out items where searchCount is null or less than or equal to 1
              //       var filteredSubcategories = _viewModel.searchCount
              //           .where((subcategory) => subcategory.searchCount != null && subcategory.searchCount! > 0)
              //           .toList();
              //
              //       // Check if filteredSubcategories is empty after filtering
              //       if (filteredSubcategories.isEmpty) {
              //         return [
              //           const Center(child: Text('No popular searches with search count greater than 1.')),
              //         ];
              //       }
              //
              //       // Sort the filtered list in descending order based on searchCount
              //       filteredSubcategories.sort((a, b) => b.searchCount!.compareTo(a.searchCount!));
              //
              //       // Map over the sorted list to create the ListTile widgets
              //       return filteredSubcategories.map((subcategory) {
              //         return ListTile(
              //           title: Text(subcategory.name.toString()),
              //           subtitle: Text('Search Count: ${subcategory.searchCount}'),
              //         );
              //       }).toList();
              //     })(), // Use an anonymous function to handle sorting and mapping
              //   ),
              // // If no searchCount is available, show a fallback message or empty state
              // if (_viewModel.searchCount.isEmpty)
              //   Center(child: Text('No popular searches yet.')),





              //Optionally display the most popular searches
              // if (_viewModel.mostPopularSearches.isNotEmpty)
              //   Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: _viewModel.mostPopularSearches.map((search) {
              //       return Text(search);
              //     }).toList(),
              //   ),
              const SizedBox(height: 20),
              Text('Suggestions For You', style: AppTextStyle.getTextStyle20FontWeightw600),
              const SizedBox(height: 15),
              _viewModel.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _viewModel.filteredSalons.length,
                itemBuilder: (context, index) {
                  final searchSalon = _viewModel.filteredSalons[index];
                  bool isFavorited = _homeScreenViewModel.favoriteService.any(
                          (service) =>
                      service.serviceProviderId == searchSalon.id);
                  final promoImages = (searchSalon.imageUrl ?? '').split(',').map((s) => s.trim()).toList();
                  final salonServiceProviderImage = (promoImages.isNotEmpty && promoImages[0].isNotEmpty)
                      ? '$BASE_URL/uploads/${promoImages[0]}' : dummyimage;
                  String displayServiceNames() {
                    final serviceNamesList = searchSalon.services.map((item) => item.name ?? "").toList();
                    if (serviceNamesList.isEmpty || (serviceNamesList.length == 1 && serviceNamesList[0].isEmpty)) {
                      return 'Unknown Service';
                    }if (serviceNamesList.length <= 2) {
                      return serviceNamesList.join(', ');
                    }return '${serviceNamesList.take(2).join(', ')} +${serviceNamesList.length - 2}';
                  }
                  return CardPage(
                    id: searchSalon.id!,
                    imagePath: salonServiceProviderImage,
                    title: displayServiceNames(),
                    salonName: searchSalon.salonName ?? 'Unknown Salon',
                    address: searchSalon.address ?? 'Unknown Address',
                    averageRating: searchSalon.averageRating?.toDouble() ?? 0.0,
                    totalRating: searchSalon.totalRatings ?? 0,
                    icon: IconButton(
                      icon: Icon(
                        isFavorited ? Icons.favorite : Icons.favorite_border,
                        color: isFavorited ? fabricColor : Colors.black,
                      ),
                      onPressed: () {
                        if (isFavorited) {
                          _homeScreenViewModel.removeFavorite(searchSalon.id);
                        } else {
                          _homeScreenViewModel.addFavorite(searchSalon.id);
                        }
                        _viewModel.refreshUI();
                      },
                    ),
                    onPressed: () async {
                      serviceProviderId = searchSalon.id!;
                      await _homeScreenViewModel.increaseViewCount(serviceProviderId);
                      Get.to(() => ServiceProviderDetailPage(
                        userName: searchSalon.salonName ?? 'Unknown Salon',
                        address: searchSalon.address ?? 'Unknown Address',
                        imagePath: salonServiceProviderImage,
                        viewCount: searchSalon.viewCount ?? 0,
                        averageRating: searchSalon.averageRating?.toDouble() ?? 0.0,
                        totalRatings: searchSalon.totalRatings ?? 0,
                        mobileNumber: searchSalon.mobileNumber ?? "",
                      ));
                    },
                  );
                  //   bottomCard(
                  //   searchSalon.id!,
                  //   salonServiceProviderImage,
                  //   displayServiceNames(),
                  //   searchSalon.salonName ?? 'Unknown Salon',
                  //   searchSalon.address ?? 'Unknown Address',
                  //   searchSalon.averageRating?.toDouble() ?? 0.0,
                  //   searchSalon.totalRatings ?? 0,
                  //   _viewModel,
                  //   context,
                  //       () async {
                  //     var salonId = searchSalon.id;
                  //     await _homeScreenViewModel.increaseViewCount(salonId!);
                  //     Get.to(() => ServiceProviderDetailPage(
                  //       userName: searchSalon.salonName ?? 'Unknown Salon',
                  //       address: searchSalon.address ?? 'Unknown Address',
                  //       imagePath: salonServiceProviderImage,
                  //       viewCount: searchSalon.viewCount ?? 0,
                  //       averageRating: searchSalon.averageRating?.toDouble() ?? 0.0,
                  //       totalRatings: searchSalon.totalRatings ?? 0,
                  //     ));
                  //   },
                  // );
                },
              ),
            ],
          ),
        ),

      ),
    );
  }

  // void _addSearch(String searchQuery) {
  //   if (searchQuery.isNotEmpty) {
  //     setState(() {
  //       // Add to recent searches if it's not already there
  //       if (!_recentSearches.contains(searchQuery)) {
  //         _recentSearches.insert(0, searchQuery);
  //       }
  //
  //       // Update the frequency of the search term
  //       if (_searchFrequency.containsKey(searchQuery)) {
  //         _searchFrequency[searchQuery] = _searchFrequency[searchQuery]! + 1;
  //       } else {
  //         _searchFrequency[searchQuery] = 1;
  //       }
  //
  //       // Limit to a maximum of 4 recent searches
  //       if (_recentSearches.length > 4) {
  //         _recentSearches.removeLast();
  //       }
  //
  //       _viewModel.searchController.clear();
  //     });
  //   }
  // }
  //
  // void _clearAll() {
  //   setState(() {
  //     _recentSearches.clear();
  //     _searchFrequency.clear();
  //   });
  // }
  //
  // void _removeSearch(String search) {
  //   setState(() {
  //     _recentSearches.remove(search);
  //     _searchFrequency.remove(search); // Remove from frequency map as well
  //   });
  // }
  //
  // void _useRecentSearch(String search) {
  //   setState(() {
  //     _viewModel.searchController.text = search;
  //     _addSearch(search);
  //   });
  // }

  // Widget bottomCard(
  //     int id,
  //     String imagePath,
  //     String title,
  //     String salonName,
  //     String address,
  //     double averageRating,
  //     int totalRating,
  //     SearchViewModel viewModel,
  //     BuildContext context,
  //     VoidCallback onPressed,
  //     ) {
  //   return Card(
  //     color: Colors.white,
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
  //                       title,
  //                       style: AppTextStyle.getTextStyle12FontWeightw300,
  //                       maxLines: 1,
  //                       overflow: TextOverflow.ellipsis,
  //                       softWrap: false,
  //                     ),
  //                     const SizedBox(height: 6),
  //                     Text(
  //                       salonName,
  //                       style: AppTextStyle.getTextStyle18FontWeightBold,
  //                     ),
  //                     Text(
  //                       address,
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
  //               Padding(
  //                 padding: const EdgeInsets.symmetric(horizontal: 8.0),
  //                 child: Expanded(
  //                   child: Container(
  //                     margin: const EdgeInsets.only(bottom: 6),
  //                     child: CustomButtonWidget(
  //                       text: AppString.book,
  //                       textColor: Colors.white,
  //                       onPressed: () async {
  //                         onPressed();
  //                       },
  //                       buttonColor: fabricColor,
  //                       borderRadius: 5,
  //                       buttonHeight: 40,
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}

