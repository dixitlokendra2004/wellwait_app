import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import 'package:wellwait_app/admin/utils/admin_%20common_variable.dart';
import 'package:wellwait_app/utils/common_variables.dart';
import '../../filter_salon_provider/filter_salon_provider_page.dart';
import '../../home_screen/home_screen_viewmodel.dart';
import '../../utils/app_strings.dart';
import '../../utils/app_text_style.dart';
import 'filter_viewmodel.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  String selectedService = AppString.nails;
  int selectedRating = 4;
  String selectedServiceFor = AppString.all;
  RangeValues distanceRange = const RangeValues(0, 15);
  RangeValues priceRange = const RangeValues(500, 1500);
  late FilterViewModel _viewModel;
  //late HomeScreenViewModel _homeScreenViewModel;


  @override
  Widget build(BuildContext context) {
    _viewModel = context.watch<FilterViewModel>();
   // _homeScreenViewModel = context.watch<HomeScreenViewModel>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leadingWidth: 100,
        leading: TextButton(
          onPressed: () {
            Get.back();
          },
          child: Text(
            AppString.cancel,
            style: AppTextStyle.getTextStyle16FontWeightw600Grey.copyWith(color: Colors.red),
          ),
        ),
        title: Text(
          AppString.filter,
          style: AppTextStyle.getTextStyle18FontWeightw600B,
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              // Handle reset action
            },
            child: Text(
              AppString.reset,
              style: AppTextStyle.getTextStyle16FontWeightw600Grey,
            ),
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Service For Section
                Text(AppString.serviceFor, style: AppTextStyle.getTextStyle18FontWeightw600B,),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10.0,
                  runSpacing: 10.0,
                  children: [
                    _buildServiceForButton(AppString.all),
                    _buildServiceForButton(AppString.woman),
                    _buildServiceForButton(AppString.men),
                    _buildServiceForButton(AppString.kids),
                  ],
                ),
                const SizedBox(height: 20),
                Text(AppString.rating, style: AppTextStyle.getTextStyle18FontWeightw600B,),
                Row(
                  children: [
                    _buildRatingStar(1),
                    _buildRatingStar(2),
                    _buildRatingStar(3),
                    _buildRatingStar(4),
                    _buildRatingStar(5),
                    const SizedBox(width: 10),
                    Text('$selectedRating ${AppString.star}', style: AppTextStyle.getTextStyle16FontWeightw800),
                  ],
                ),
                Row(
                  children: [
                    Text(AppString.service, style: AppTextStyle.getTextStyle18FontWeightw600B,),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        // Handle see all action
                      },
                      child: Text(
                        AppString.seeAll,
                        style: AppTextStyle.getTextStyle15FontWeightw700Grey400,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    _buildServiceButton(AppString.nails),
                    const SizedBox(width: 10),
                    _buildServiceButton(AppString.haircut),
                    const SizedBox(width: 10),
                    _buildServiceButton(AppString.spa),
                  ],
                ),
                const SizedBox(height: 20),
                Text(AppString.distance, style: AppTextStyle.getTextStyle18FontWeightw600B,),
                RangeSlider(
                  values: distanceRange,
                  min: 0,
                  max: 15,
                  divisions: 15,
                  labels: RangeLabels(
                    '${distanceRange.start.toInt()} ${AppString.km}',
                    '${distanceRange.end.toInt()} ${AppString.km}',
                  ),
                  onChanged: (RangeValues values) {
                    setState(() {
                      distanceRange = values;
                    });
                  },
                  activeColor: Colors.teal,
                  inactiveColor: Colors.grey,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${distanceRange.start.toInt()} ${AppString.km}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    Text(
                      '${distanceRange.end.toInt()} ${AppString.km}',
                      style: const TextStyle(color: Colors.grey),
                    )
                  ],
                ),
                const SizedBox(height: 20),

                // Price Range Slider
                Text(AppString.priceRange, style: AppTextStyle.getTextStyle18FontWeightw600B,),
                RangeSlider(
                  values: priceRange,
                  min: 500,
                  max: 1500,
                  divisions: 10,
                  labels: RangeLabels(
                    '${AppString.rupee}${priceRange.start.toInt()}',
                    '${AppString.rupee}${priceRange.end.toInt()}',
                  ),
                  onChanged: (RangeValues values) {
                    setState(() {
                      priceRange = values;
                    });
                  },
                  activeColor: Colors.teal,
                  inactiveColor: Colors.grey,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${AppString.rupee}${priceRange.start.toInt()}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    Text(
                      '${AppString.rupee}${priceRange.end.toInt()}',
                      style: const TextStyle(color: Colors.grey),
                    )
                  ],
                ),
                const Spacer(),

                // Show Result Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      // await _viewModel.fetchSalonProviders(
                      //   selectedServiceFor,
                      //   selectedRating.toString(),
                      //   selectedService,
                      //   distanceRange.end, // Use the maximum value of the range for distance
                      //   '${priceRange.start.toInt()}-${priceRange.end.toInt()}',
                      //   location,
                      //   // _homeScreenViewModel.longitude,
                      //   // _homeScreenViewModel.latitude,
                      // );
                      Get.to(() => FilterSalonProviderPage());
                      print("$selectedServiceFor\n${selectedRating.toString()}\n$selectedService\n${distanceRange.end}\n${priceRange.start}-${priceRange.end}\n$location");
                      },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    child: Text(
                      AppString.showResult,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible: _viewModel.isLoading,
            child: Center(
                child: Container(
                  height: 40,
                  width: 40,
                  color: Colors.transparent,
                  child: const CircularProgressIndicator(),
                )),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceButton(String service) {
    bool isSelected = selectedService == service;
    return Container(
      width: 100,
      height: 35,
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            selectedService = service;
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Colors.teal : Colors.white,
          foregroundColor: isSelected ? Colors.white : Colors.teal,
          side: const BorderSide(color: Colors.teal),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          padding: const EdgeInsets.symmetric(horizontal: 20),
        ),
        child: Text(
          service,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _buildRatingStar(int star) {
    return IconButton(
      icon: Icon(
        Icons.star,
        size: 30,
        color: selectedRating >= star ? Colors.orange : Colors.grey,
      ),
      onPressed: () {
        setState(() {
          selectedRating = star;
        });
      },
    );
  }

  Widget _buildServiceForButton(String serviceFor) {
    bool isSelected = selectedServiceFor == serviceFor;
    return SizedBox(
      width: 100,
      height: 35,
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            selectedServiceFor = serviceFor;
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Colors.teal : Colors.white,
          foregroundColor: isSelected ? Colors.white : Colors.teal,
          side: const BorderSide(color: Colors.teal),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
}
