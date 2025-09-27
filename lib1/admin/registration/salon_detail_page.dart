import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:wellwait_app/admin/admin_phone_number_login/admin_phone_number_page.dart';
import 'package:wellwait_app/admin/registration/salonRegistrationViewModel.dart';
import 'package:wellwait_app/admin/utils/admin_%20common_variable.dart';
import 'package:wellwait_app/admin/widget/app_bar.dart';
import 'package:wellwait_app/utils/common_variables.dart';
import '../../utils/app_strings.dart';
import '../../utils/app_text_style.dart';
import '../../utils/colors.dart';
import '../../utils/sp_helper.dart';
import '../../widget/custom_button.dart';
import '../../widget/custom_textfield.dart';
import '../../widget/snack_bar_widget.dart';

class SalonDetailPage extends StatefulWidget {
  final Function()? onNext;
  final bool salonDetailEdit;

  const SalonDetailPage({super.key, this.onNext,required this.salonDetailEdit});

  @override
  State<SalonDetailPage> createState() => _SalonDetailPageState();
}

class _SalonDetailPageState extends State<SalonDetailPage> {
  final _formKey = GlobalKey<FormState>();
  double? latitude;
  double? longitude;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      updateDetails();
    });
  }

  updateDetails() {
    if (widget.salonDetailEdit == true) {
      print("Fetching service provider info for ID: $adminServiceProviderId");
      _viewModel.fetchServiceProviderInfo(adminServiceProviderId).then((_) {
        print("Fetch completed, checking serviceProviderInfo...");
        if (_viewModel.serviceProviderInfo != null) {
          final serviceProvider = _viewModel.serviceProviderInfo!;
          print("Fetched Service Provider Data: ${serviceProvider.toJson()}");
          _viewModel.ownerFullNameController.text = serviceProvider.providerName ?? "";
          _viewModel.salonNameController.text = serviceProvider.salonName ?? "";
          _viewModel.salonFullAddressController.text = serviceProvider.address ?? "";
          _viewModel.emailController.text = serviceProvider.email ?? "";
          _viewModel.cityController.text = serviceProvider.city ?? "";
          _viewModel.stateController.text = serviceProvider.state ?? "";
          _viewModel.countryController.text = serviceProvider.country ?? "";
          _viewModel.pincodeController.text = serviceProvider.pinCode ?? "";
          _viewModel.address2Controller.text = serviceProvider.address2 ?? "";
          _viewModel.refreshUI();
        } else {
          print("Error: serviceProviderInfo is null");
        }
      });
    } else {
      print("salonDetailEdit is false, clearing all fields...");
      _viewModel.ownerFullNameController.clear();
      _viewModel.salonNameController.clear();
      _viewModel.salonFullAddressController.clear();
      _viewModel.emailController.clear();
      _viewModel.cityController.clear();
      _viewModel.stateController.clear();
      _viewModel.countryController.clear();
      _viewModel.pincodeController.clear();
      _viewModel.address2Controller.clear();
      _viewModel.refreshUI();
    }
  }
  late SolonRegistrationViewModel _viewModel;
  @override
  Widget build(BuildContext context) {
    _viewModel = context.watch<SolonRegistrationViewModel>();
    return Scaffold(
      appBar: (widget.salonDetailEdit == true)
          ? PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(bgColor: Colors.white,showHomeButton: true),
      ) : null,
      body: Column(
        children: [
          SizedBox(height: (widget.salonDetailEdit == true) ? 0 : 30),
          (widget.salonDetailEdit == true)
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
                      Text(AppString.settingsBusinessDetails,style:  AppTextStyle.getTextStyle18FontWeightw600FabricColor),
                    ],
                  ),
                ),
                Container(),
              ],
            ),
          ) : Center(
            child: Text(
              AppString.salonDetailTitle,
              style: AppTextStyle.getTextStyle18FontWeightw600FabricColor,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin:
                        const EdgeInsets.only(left: 15, right: 15, bottom: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        Container(
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
                              // Owner Full Name
                              Container(
                                margin: EdgeInsets.only(top: 16,bottom: 18),
                                decoration: BoxDecoration(
                                  color: Color(0xffD5ECEC),
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(20),  // Circular border for top-right
                                    bottomRight: Radius.circular(20), // Circular border for bottom-right
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 4,bottom: 4,left: 8,right: 8),
                                  child: Text(
                                    AppString.basicDetails,
                                    style: AppTextStyle.getTextStyle16FontWeightBold,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Container(
                                  child: Form(
                                    key: _formKey,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        CustomTextField(
                                          controller: _viewModel.ownerFullNameController,
                                          hintText: AppString.enterNameHintText,
                                          title: AppString.ownerFullName,
                                          titleColor: Colors.black,
                                          borderRadius: 25,
                                          borderColor: Colors.teal,
                                          borderWidth: 1,
                                          textFieldColor: Colors.white,
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return AppString.enterName;
                                            }
                                            return null;
                                          },
                                        ),
                                        const SizedBox(height: 8),
                                        // Salon Name
                                        CustomTextField(
                                          controller: _viewModel.salonNameController,
                                          hintText: AppString.enterNameHintText,
                                          title: AppString.salonName,
                                          titleColor: Colors.black,
                                          borderRadius: 25,
                                          borderColor: Colors.teal,
                                          borderWidth: 1,
                                          textFieldColor: Colors.white,
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Please enter your Salon Name';
                                            }
                                            return null;
                                          },
                                        ),
                                        const SizedBox(height: 8),
                                        Text("Salon Address",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w300),),
                                        const SizedBox(height: 8),
                                        // Salon Address
                                        CustomTextField(
                                          controller: _viewModel.salonFullAddressController,
                                          hintText: AppString.enterAddressHintText,
                                          title: AppString.addressLine1,
                                          titleColor: Colors.black,
                                          borderRadius: 25,
                                          borderColor: Colors.teal,
                                          borderWidth: 1,
                                          textFieldColor: Colors.white,
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Please enter your Salon Address';
                                            }
                                            return null;
                                          },
                                        ),
                                        const SizedBox(height: 8),
                                        CustomTextField(
                                          controller: _viewModel.address2Controller,
                                          hintText: AppString.enterAddressHintText,
                                          title: AppString.addressLine2,
                                          titleColor: Colors.black,
                                          borderRadius: 25,
                                          borderColor: Colors.teal,
                                          borderWidth: 1,
                                          textFieldColor: Colors.white,
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Please enter your Salon Address';
                                            }
                                            return null;
                                          },
                                        ),
                                        const SizedBox(height: 8),
                                        // City Dropdown
                                        CustomTextField(
                                          controller: _viewModel.cityController,
                                          hintText: "Enter City",
                                          title: "City",
                                          titleColor: Colors.black,
                                          borderRadius: 25,
                                          borderColor: Colors.teal,
                                          borderWidth: 1,
                                          textFieldColor: Colors.white,
                                          // keyboardType: TextInputType.number,
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Please enter your City';
                                            }
                                            return null;
                                          },
                                        ),

                                        const SizedBox(height: 8),
                                        // Pincode TextField
                                        CustomTextField(
                                          controller: _viewModel.stateController,
                                          hintText: "Enter State",
                                          title: "State",
                                          titleColor: Colors.black,
                                          borderRadius: 25,
                                          borderColor: Colors.teal,
                                          borderWidth: 1,
                                          textFieldColor: Colors.white,
                                          // keyboardType: TextInputType.number,
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Please enter your State';
                                            }
                                            return null;
                                          },
                                        ),
                                        const SizedBox(height: 8),
                                        // Pincode TextField
                                        CustomTextField(
                                          controller: _viewModel.countryController,
                                          hintText: "Enter Country",
                                          title: "Country",
                                          titleColor: Colors.black,
                                          borderRadius: 25,
                                          borderColor: Colors.teal,
                                          borderWidth: 1,
                                          textFieldColor: Colors.white,
                                          // keyboardType: TextInputType.number,
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Please enter your State';
                                            }
                                            return null;
                                          },
                                        ),
                                        CustomTextField(
                                          controller: _viewModel.pincodeController,
                                          hintText: "Enter Pincode",
                                          title: "Pincode",
                                          titleColor: Colors.black,
                                          borderRadius: 25,
                                          borderColor: Colors.teal,
                                          borderWidth: 1,
                                          textFieldColor: Colors.white,
                                          // keyboardType: TextInputType.number,
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Please enter your Pincode';
                                            }
                                            return null;
                                          },
                                        ),
                                        // const SizedBox(height: 8),
                                        // Row(
                                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        //   children: [
                                        //     Text(
                                        //       "Location",
                                        //       style: TextStyle(
                                        //         fontSize: 16,
                                        //         fontWeight: FontWeight.w500,
                                        //         
                                        //         color: Colors.black,
                                        //       ),
                                        //     ),
                                        //     InkWell(
                                        //       onTap: _fetchLocation,
                                        //       child: Row(
                                        //         children: [
                                        //           Icon(Icons.location_on_outlined, color: Colors.teal),
                                        //           SizedBox(width: 4),
                                        //           Text(
                                        //             "Fetch Location",
                                        //             style: TextStyle(
                                        //               fontSize: 16,
                                        //               fontWeight: FontWeight.w500,
                                        //               
                                        //               color: Colors.teal,
                                        //             ),
                                        //           ),
                                        //         ],
                                        //       ),
                                        //     ),
                                        //   ],
                                        // ),
                                        // SizedBox(height: 10),
                                        // Container(
                                        //   height: 50,
                                        //   width: double.infinity,
                                        //   padding: EdgeInsets.all(12),
                                        //   decoration: BoxDecoration(
                                        //     color: Colors.white,
                                        //     borderRadius: BorderRadius.circular(30),
                                        //     border: Border.all(color: Colors.teal, width: 1),
                                        //   ),
                                        //   child: Row(
                                        //     crossAxisAlignment: CrossAxisAlignment.start,
                                        //     children: [
                                        //       Text(
                                        //         "${latitude ?? "Not selected"}",
                                        //         style: TextStyle(fontSize: 14),
                                        //       ),
                                        //       SizedBox(width: 5),
                                        //       Text(
                                        //         "${longitude ?? "Not selected"}",
                                        //         style: TextStyle(fontSize: 14),
                                        //       ),
                                        //     ],
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),

                        const SizedBox(height: 15),
                        Visibility(
                          visible: !_viewModel.isGoogleAuth,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppString.ownerContactDetails,
                                style:
                                    AppTextStyle.getTextStyle20FontWeightBold,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                AppString.contactDetailsDescription,
                                style:
                                    AppTextStyle.getTextStyle13FontWeightw200,
                              ),
                              const SizedBox(height: 20),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                    color: Colors.black54,
                                    width: 1,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    children: [
                                      CustomTextField(
                                        controller:
                                            _viewModel.emailController,
                                        hintText: AppString.enterEmailId,
                                        title: AppString.emailId,
                                        titleColor: Colors.black,
                                        borderRadius: 25,
                                        borderColor: Colors.teal,
                                        borderWidth: 1,
                                        textFieldColor: Colors.white,
                                        validator: (value) {
                                          if (value == null ||
                                              value.isEmpty) {
                                            return 'Please enter your email';
                                          }
                                          if (!value.contains('@')) {
                                            return 'Please enter a valid email';
                                          }
                                          return null;
                                        },
                                      ),
                                      // const SizedBox(height: 8),
                                      // CustomTextField(
                                      //   controller: _viewModel.mobileNumberController,
                                      //   hintText: AppString.enterMobileNumber,
                                      //   title: AppString.phoneNumber,
                                      //   titleColor: Colors.black,
                                      //   borderRadius: 25,
                                      //   borderColor: Colors.teal,
                                      //   borderWidth: 1,
                                      //   textFieldColor: Colors.white,
                                      //   maxLength: 10,
                                      //   validator: (value) {
                                      //     if (value == null || value.isEmpty) {
                                      //       return 'Please enter your Mobile Number';
                                      //     }
                                      //     return null;
                                      //   },
                                      // ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          (widget.salonDetailEdit == true) ?
              Container(
                margin: const EdgeInsets.only(left: 15, right: 15, bottom: 20),
                width: double.infinity,
                child: CustomButtonWidget(
                  text: AppString.saveChanges,
                  textColor: Colors.white,
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      String address =
                          _viewModel.salonFullAddressController.text;
                      try {
                        Map<String, dynamic> locationData =
                        await getCoordinatesFromAddress(address);

                        double latitude = locationData['latitude'];
                        double longitude = locationData['longitude'];

                        providerLocation = '${longitude},${latitude}';

                        await _viewModel.updateServiceProvider(
                          adminServiceProviderId,
                          address,
                          providerLocation,
                        );
                        Get.back();
                        print(
                          'provider Id: ${adminServiceProviderId}\n'
                              'Full Name: ${_viewModel.ownerFullNameController.text}\n'
                              'Salon Name: ${_viewModel.salonNameController.text}\n'
                              'Address: $address\n'
                              'Email: ${_viewModel.emailController.text}\n'
                              'Location: $providerLocation',
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  'Error: Invalid address or unable to fetch coordinates.')),
                        );
                      }
                    }
                  },
                  buttonColor: fabricColor,
                  borderRadius: 5,
                  buttonHeight: 40,
                ),
              )
             : Container(
            margin: const EdgeInsets.only(left: 15, right: 15, bottom: 20),
            child: Row(
              children: [
                Expanded(
                  child: CustomButtonWidget(
                    text: AppString.backButton,
                    textColor: Colors.black,
                    onPressed: () {
                      final SharedPreferenceService _sharedPreferenceService =
                          SharedPreferenceService();
                      _sharedPreferenceService.clearCredentials();
                      //Get.to(() => AdminEmailLoginPage());
                      Get.offAll(() => AdminPhoneNumberPage());
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
                    text: AppString.nextButton,
                    textColor: Colors.white,
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        String address =
                            _viewModel.salonFullAddressController.text;
                        try {
                          Map<String, dynamic> locationData =
                              await getCoordinatesFromAddress(address);

                          double latitude = locationData['latitude'];
                          double longitude = locationData['longitude'];

                          providerLocation = '${longitude},${latitude}';

                          await _viewModel.updateServiceProvider(
                            adminServiceProviderId,
                            address,
                            providerLocation,
                          );
                          widget.onNext?.call();
                          print(
                            'provider Id: ${adminServiceProviderId}\n'
                            'Full Name: ${_viewModel.ownerFullNameController.text}\n'
                            'Salon Name: ${_viewModel.salonNameController.text}\n'
                            'Address: $address\n'
                            'Email: ${_viewModel.emailController.text}\n'
                            'Location: $providerLocation',
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    'Error: Invalid address or unable to fetch coordinates.')),
                          );
                        }
                      }
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

  Future<Map<String, dynamic>> getCoordinatesFromAddress(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);

      if (locations.isNotEmpty) {
        return {
          'latitude': locations.first.latitude,
          'longitude': locations.first.longitude,
          'address': address, // Returning the address too
        };
      } else {
        throw Exception('Address not found');
      }
    } catch (e) {
      throw Exception('Failed to get coordinates: $e');
    }
  }


}


// class Location {
//   final double latitude;
//   final double longitude;
//
//   Location({required this.latitude, required this.longitude});
//
//   Map<String, dynamic> toJson() {
//     return {
//       'latitude': latitude,
//       'longitude': longitude,
//     };
//   }
// }
