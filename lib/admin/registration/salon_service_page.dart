import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import 'package:wellwait_app/admin/salon_service/salon_service_viewmodel.dart';
import 'package:wellwait_app/models/service_provider_banner.dart';
import 'package:wellwait_app/models/service_provider_image.dart';
import '../../utils/app_strings.dart';
import '../../utils/app_text_style.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../../widget/custom_button.dart';
import '../admin_email_login/admin_email_login_viewmodel.dart';
import 'package:http/http.dart' as http;
import '../utils/admin_ common_variable.dart';
import '../widget/app_bar.dart';

class SalonServicePage extends StatefulWidget {
  final Function()? onNext;
  final Function()? onBack;
  final bool salonServiceEdit;

  const SalonServicePage(
      {super.key, this.onNext, this.onBack, required this.salonServiceEdit});

  @override
  State<SalonServicePage> createState() => _SalonServicePageState();
}

class _SalonServicePageState extends State<SalonServicePage> {
  late SalonServiceViewModel _viewModel;
  String baseUrl = "$BASE_URL/uploads/";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.salonServiceEdit) {
        _viewModel.fetchData();
      } else {
        _viewModel.clearProviderData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _viewModel = context.watch<SalonServiceViewModel>();
    _viewModel.adminEmailLoginViewModel =
        context.watch<AdminEmailLoginViewModel>();
    return Scaffold(
      appBar: (widget.salonServiceEdit == true)
          ? PreferredSize(
              preferredSize: Size.fromHeight(kToolbarHeight),
              child: CustomAppBar(bgColor: Colors.white, showHomeButton: true),
            )
          : null,
      body: Column(
        children: [
          SizedBox(height: (widget.salonServiceEdit == true) ? 0 : 30),
          (widget.salonServiceEdit == true)
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: SvgPicture.asset(
                              "assets/icons/back_icon.svg",
                              height: 25,
                              width: 25,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        child: Column(
                          children: [
                            Text(
                              adminSalonName,
                              style: AppTextStyle.getTextStyle14FontWeightw600G,
                            ),
                            Text(AppString.settingsSalonShowcase,
                                style: AppTextStyle
                                    .getTextStyle18FontWeightw600FabricColor),
                          ],
                        ),
                      ),
                      Container(),
                    ],
                  ),
                )
              : Center(
                  child: Text(
                    "Salon Services",
                    style: AppTextStyle.getTextStyle18FontWeightw600FabricColor,
                  ),
                ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                        left: 15, right: 15, bottom: 15, top: 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Container for uploading and displaying multiple salon photos
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: Colors.black54,
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 16, bottom: 8),
                                decoration: BoxDecoration(
                                  color: Color(0xffD5ECEC),
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(20),
                                    // Circular border for top-right
                                    bottomRight: Radius.circular(
                                        20), // Circular border for bottom-right
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 4, bottom: 4, left: 8, right: 8),
                                  child: Text(
                                    AppString.uploadSalonPhotos,
                                    style: AppTextStyle
                                        .getTextStyle16FontWeightBold,
                                  ),
                                ),
                              ),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    ..._viewModel.salonProviderImages
                                        .map(
                                          (ServiceProviderImage image) =>
                                              Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Stack(
                                              clipBehavior: Clip.none,
                                              children: [
                                                Container(
                                                  width: 118,
                                                  height: 117,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    image: DecorationImage(
                                                      image: NetworkImage(
                                                          "$BASE_URL/uploads/${image.imageUrl}"),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  top: -8,
                                                  right: -8,
                                                  child: GestureDetector(
                                                    onTap: () async {
                                                      await _viewModel
                                                          .deleteServiceProviderImage(
                                                              image.id);
                                                      _viewModel.refreshUI();
                                                    },
                                                    child: Container(
                                                      width: 24,
                                                      height: 24,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Colors.black
                                                            .withOpacity(0.8),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color:
                                                                Colors.black26,
                                                            blurRadius: 4,
                                                            spreadRadius: 1,
                                                          ),
                                                        ],
                                                      ),
                                                      child: const Icon(
                                                          Icons.close,
                                                          color: Colors.white,
                                                          size: 16),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                        .toList(),
                                    GestureDetector(
                                      onTap: () async {
                                        await _viewModel
                                            .pickServiceProviderImage();
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.all(14),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 30, horizontal: 25),
                                        decoration: BoxDecoration(
                                          color: const Color(0xffEDF6F6),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          border: Border.all(
                                            color: fabricColor,
                                            width: 1,
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            const Icon(
                                                Icons.camera_alt_outlined,
                                                color: fabricColor,
                                                size: 35),
                                            const SizedBox(width: 8),
                                            Text(
                                              AppString.addPhotos,
                                              style: AppTextStyle
                                                  .getTextStyle14FontWeightw400FabricColor,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: Colors.black54,
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 16, bottom: 8),
                                decoration: BoxDecoration(
                                  color: Color(0xffD5ECEC),
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(20),
                                    bottomRight: Radius.circular(20),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 4, bottom: 4, left: 8, right: 8),
                                  child: Text(
                                    AppString.salonTopBanner,
                                    style: AppTextStyle
                                        .getTextStyle16FontWeightBold,
                                  ),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount:
                                        _viewModel.salonProviderBanners.length,
                                    itemBuilder: (context, index) {
                                      ServiceProviderBanner banner = _viewModel.salonProviderBanners[index];
                                      return Stack(
                                        clipBehavior: Clip.none,
                                        children: [
                                          Container(
                                            width: double.infinity,
                                            height: 200,
                                            margin: const EdgeInsets.all(8.0),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                    "$BASE_URL/uploads/${banner.imageUrl}"),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: -3,
                                            right: -3,
                                            child: GestureDetector(
                                              onTap: () {
                                                _viewModel.deleteSalonBanner(
                                                    banner.id);
                                              },
                                              child: Container(
                                                width: 24,
                                                height: 24,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.black
                                                      .withOpacity(0.8),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black26,
                                                      blurRadius: 4,
                                                      spreadRadius: 1,
                                                    ),
                                                  ],
                                                ),
                                                child: const Icon(
                                                  Icons.close,
                                                  color: Colors.white,
                                                  size: 18,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: InkWell(
                                      onTap: () async {
                                        await _viewModel
                                            .pickServiceProviderBanner();
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 20, left: 8, bottom: 20),
                                        child: Row(
                                          children: [
                                            Icon(Icons.upload_sharp,
                                                color: AppColors.primaryColor),
                                            SizedBox(width: 10),
                                            Text(
                                              "Add Banner",
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                                color: Color(0xff40A7A7),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppString.addServices,
                                style:
                                    AppTextStyle.getTextStyle20FontWeightBold,
                              ),
                              const SizedBox(height: 10),
                              buildCategorySection('Women'),
                              const SizedBox(height: 10),
                              buildCategorySection('Men'),
                              const SizedBox(height: 10),
                              buildCategorySection('Kids'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 15, right: 15, bottom: 20),
            child: (widget.salonServiceEdit == true)
                ? SizedBox()
                : Row(
                    children: [
                      Expanded(
                        child: CustomButtonWidget(
                          text: AppString.back,
                          textColor: Colors.black,
                          onPressed: () {
                            //Navigator.pop(context);
                            widget.onBack?.call();
                          },
                          buttonColor: Colors.white,
                          borderRadius: 5,
                          buttonHeight: 40,
                          borderColor: Colors.black54,
                          buttonWidth: 1,
                        ),
                      ),
                      const SizedBox(width: 25),
                      Expanded(
                        child: CustomButtonWidget(
                          text: AppString.next,
                          textColor: Colors.white,
                          onPressed: () {
                            widget.onNext?.call();
                          },
                          buttonColor: fabricColor,
                          borderRadius: 5,
                          buttonHeight: 40,
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget buildCategorySection(String category) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          category,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ..._viewModel.services[category]!.map((service) {
                // Ensure the service contains 'name', 'price', and 'imageUrl' keys
                String serviceFor = service['name'] ?? 'Unknown Service';
                String price = service['price']?.toString() ?? 'N/A';
                String imageUrl = service['imageUrl'] ??
                    'default_image_url.png'; // Replace with a default image if not available

                return buildServiceForButton(
                  serviceFor: serviceFor,
                  price: price,
                  imageUrl: imageUrl,
                  containerColor: const Color(0xffE6F4F4),
                  textColor: fabricColor,
                );
              }).toList(),
              buildServiceForButton(
                serviceFor: '+ add',
                price: '',
                // Add an empty price for the add button
                imageUrl: 'default_add_image_url.png',
                // Use a default image for the add button
                containerColor: Colors.white,
                textColor: Colors.black,
                isAddButton: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildServiceForButton({
    required String serviceFor,
    required String price,
    required String imageUrl,
    required Color containerColor,
    required Color textColor,
    FontWeight fontWeight = FontWeight.w700,
    bool isAddButton = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      child: ElevatedButton(
        onPressed: () {
          if (isAddButton) {
            _openAddServiceDialog(); // Open the dialog for adding a service
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: containerColor,
          foregroundColor: textColor,
          side: const BorderSide(color: Colors.teal),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          padding: const EdgeInsets.symmetric(horizontal: 0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!isAddButton) ...[
              // textSpan('Service Name: ','$serviceFor'),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  serviceFor,
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
            if (isAddButton)
              Text(
                serviceFor,
                style: AppTextStyle.getTextStyle14FontWeightw400FabricColor,
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _openAddServiceDialog() async {
    //String newService = '';
    //String servicePrice = '';
    //String imageName = '';
    String? selectedCategory = 'Women'; // Default selected category
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Title of dialog
                    const Text(
                      'Add Service',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    // Dropdown for Category Selection
                    SizedBox(
                      width: double.infinity, // Full width for dropdown
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.grey,
                            width: 1,
                          ),
                        ),
                        child: DropdownButton<String>(
                          value: selectedCategory,
                          isExpanded: true,
                          underline: SizedBox(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedCategory = newValue!;
                            });
                          },
                          items: <String>['Women', 'Men', 'Kids']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // TextField for Service Name
                    TextField(
                      controller: _viewModel.serviceNameController,
                      decoration: const InputDecoration(
                        labelText: 'Service Name',
                        hintText: 'Enter service name',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _viewModel.serviceNameController.text = value;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    // TextField for Price
                    TextField(
                      controller: _viewModel.priceController,
                      decoration: const InputDecoration(
                        labelText: 'Price',
                        hintText: 'Enter price',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          _viewModel.priceController.text = value;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        // Container to show image name
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6),
                              border:
                                  Border.all(color: Colors.black54, width: 1),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: Text(
                                _viewModel.imageName.isNotEmpty
                                    ? _viewModel.imageName
                                    : "No image selected",
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        // IconButton for uploading image
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.upload_file,
                                color: Colors.black, size: 25),
                            onPressed: () async {
                              await _viewModel.pickImage();
                              setState(() {});
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomButtonWidget(
                          text: AppString.cancel,
                          textColor: Colors.black,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          buttonColor: Colors.white,
                          borderRadius: 5,
                          buttonHeight: 40,
                          borderColor: Colors.black54,
                          buttonWidth: 100,
                        ),
                        CustomButtonWidget(
                          text: "Add Service",
                          textColor: Colors.white,
                          onPressed: () async {
                            if (_viewModel
                                    .serviceNameController.text.isNotEmpty &&
                                _viewModel.priceController.text.isNotEmpty &&
                                //promoImageUrl.isNotEmpty &&
                                _viewModel.imageName.isNotEmpty &&
                                selectedCategory != null) {
                              // Call the API to add the service
                              await _viewModel.addServices(
                                selectedCategory!,
                                _viewModel.serviceNameController.text,
                                _viewModel.priceController.text,
                              );
                              _viewModel.imageName = "";
                              _viewModel.refreshUI();
                              Navigator.of(context).pop();
                            }
                          },
                          buttonColor: fabricColor,
                          borderRadius: 5,
                          buttonHeight: 40,
                          buttonWidth: 130,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
