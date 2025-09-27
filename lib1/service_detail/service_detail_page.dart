import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import 'package:wellwait_app/service_detail/service_detail_viewmodel.dart';

import '../home_screen/home_screen_viewmodel.dart';
import '../service_provider_details/service_provider_detail_page.dart';
import '../utils/app_text_style.dart';
import '../utils/colors.dart';
import '../utils/common_card.dart';
import '../utils/common_method.dart';
import '../utils/common_variables.dart';

class ServiceDetailPage extends StatefulWidget {
  final String serviceName;

  const ServiceDetailPage({Key? key, required this.serviceName})
      : super(key: key);
  @override
  State<ServiceDetailPage> createState() => _ServiceDetailPageState();
}
class _ServiceDetailPageState extends State<ServiceDetailPage> {
  late ServiceDetailViewModel _viewModel;
  late HomeScreenViewModel _homePageViewModel;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _viewModel.fetchSalonByServices(widget.serviceName);
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    _viewModel = context.watch<ServiceDetailViewModel>();
    _homePageViewModel = context.watch<HomeScreenViewModel>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            widget.serviceName,
            style: AppTextStyle.getTextStyle16FontWeightw600,
          ),
        ),
        actions: [Container(height: 10, width: 10, color: Colors.transparent)],
      ),
      body: _viewModel.isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _viewModel.salonByService.isEmpty
              ? Center(
                  child: Text("Salon not found"),
                )
              : ListView.builder(
                  itemCount: _viewModel.salonByService.length,
                  itemBuilder: (context, index) {
                    final salonByService = _viewModel.salonByService[index];
                    bool isFavorited = _homePageViewModel.favoriteService.any(
                        (service) =>
                            service.serviceProviderId == salonByService.id);
                    return CardPage(
                      id: salonByService.id!,
                      imagePath: getProfileImage(salonByService.imageUrl),
                      title: displayServiceNames(salonByService) ??
                          'Unknown Service',
                      salonName:
                      salonByService.salonName ?? 'Unknown Salon',
                      address: salonByService.address ?? 'Unknown Address',
                      averageRating:
                      salonByService.averageRating!.toDouble(),
                      totalRating: salonByService.totalRatings!,
                      icon: IconButton(
                        icon: Icon(
                          isFavorited
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: isFavorited ? fabricColor : Colors.black,
                        ),
                        onPressed: () {
                          if (isFavorited) {
                            _homePageViewModel
                                .removeFavorite(salonByService.id);
                          } else {
                            _homePageViewModel
                                .addFavorite(salonByService.id);
                          }
                          _viewModel
                              .refreshUI(); // Notify changes to update UI
                        },
                      ),
                      onPressed: () async {
                        serviceProviderId = salonByService.id!;
                        await _homePageViewModel
                            .increaseViewCount(serviceProviderId);
                        Get.to(() => ServiceProviderDetailPage(
                          userName: salonByService.salonName ??
                              'Unknown Salon',
                          address: salonByService.address ??
                              'Unknown Address',
                          imagePath:
                          getProfileImage(salonByService.imageUrl),
                          viewCount: salonByService.viewCount!,
                          averageRating:
                          salonByService.averageRating!.toDouble(),
                          totalRatings: salonByService.totalRatings,
                          mobileNumber: salonByService.mobileNumber ?? "",
                        ));
                      },
                    );
                  },
                ),
    );
  }

  String displayServiceNames(salonServiceProvider) {
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

  @override
  void dispose() {
    _viewModel.clearData();
    super.dispose();
  }
}
