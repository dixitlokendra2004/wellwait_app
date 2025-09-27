import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:wellwait_app/admin/salon_documents/salon_documents_viewmodel.dart';
import '../../models/service_provider_model.dart';
import '../../utils/app_strings.dart';
import '../../utils/app_text_style.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../../widget/custom_button.dart';
import '../../widget/custom_textfield.dart';
import '../admin_queue/admin_queue_page.dart';
import '../dashboard/dashboard_page.dart';
import '../utils/admin_ common_variable.dart';
import '../widget/app_bar.dart';
import '../widget/bottom_bar/bottom_bar.dart';
import 'dart:typed_data'; // ✅ Import for Uint8List
import 'package:http/http.dart' as http;

class SalonDocumentsPage extends StatefulWidget {
  final Function()? onBack;
  final bool salonDocumentEdit;

  const SalonDocumentsPage({this.onBack, required this.salonDocumentEdit});

  @override
  State<SalonDocumentsPage> createState() => _SalonDocumentsPageState();
}

class _SalonDocumentsPageState extends State<SalonDocumentsPage> {
  late SalonDocumentsViewModel _viewModel;
  String baseUrl = "$BASE_URL/uploads/";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.salonDocumentEdit == true) {
        _viewModel.fetchServiceProviderDocuments();
      } else {
        _viewModel.clearServiceProviderDocuments();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _viewModel = context.watch<SalonDocumentsViewModel>();
    return Scaffold(
      appBar: (widget.salonDocumentEdit == true)
          ? PreferredSize(
              preferredSize: Size.fromHeight(kToolbarHeight),
              child: CustomAppBar(bgColor: Colors.white, showHomeButton: true),
            )
          : null,
      body: Column(
        children: [
          SizedBox(height: (widget.salonDocumentEdit == true) ? 0 : 30),
          (widget.salonDocumentEdit == true)
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
                            Text(AppString.settingsVerificationBanking,
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
                    AppString.salonDocumentsTitle,
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
                    child: Form(
                      key: _viewModel.formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                                Container(
                                  margin: EdgeInsets.only(top: 16),
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
                                      AppString.enterPanGstinDetails,
                                      style: AppTextStyle
                                          .getTextStyle16FontWeightBold,
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10,
                                        right: 10,
                                        bottom: 10,
                                        top: 20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CustomTextField(
                                          controller:
                                              _viewModel.panNumberController,
                                          hintText: AppString.enterPanHintText,
                                          title: AppString.businessOwnerPan,
                                          titleColor: Colors.black,
                                          borderRadius: 25,
                                          borderColor: Colors.teal,
                                          borderWidth: 1,
                                          textFieldColor: Colors.white,
                                          validator: (value) {
                                            final panRegex = RegExp(
                                                r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$');

                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter your PAN number';
                                            }

                                            if (!panRegex.hasMatch(value)) {
                                              return 'Please enter a valid PAN number';
                                            }

                                            return null;
                                          },
                                        ),
                                        SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                _viewModel
                                                    .pickServiceProviderPanCardImage();
                                              },
                                              child: Row(
                                                children: [
                                                  Icon(Icons.upload_sharp,
                                                      color: Colors.teal),
                                                  SizedBox(width: 10),
                                                  Text(
                                                    "Upload PAN",
                                                    style: TextStyle(
                                                      color: Colors.teal,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(width: 20),
                                            if (_viewModel.panImageName !=
                                                    null &&
                                                _viewModel
                                                    .panImageName!.isNotEmpty)
                                              Expanded(
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: SizedBox(
                                                    child: Text(
                                                      _viewModel.panImageName!,
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.black),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      // Prevent overflow issues
                                                      maxLines: 1,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        if (_viewModel.panImageName != null &&
                                            _viewModel.panImageName!.isNotEmpty)
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Stack(
                                              children: [
                                                // Image Container
                                                Container(
                                                  width: double.infinity,
                                                  height: 150,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    image: DecorationImage(
                                                      image: NetworkImage(
                                                          "$BASE_URL/uploads/${_viewModel.panImageName}"),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),

                                                // Close Icon (Positioned at top-right corner)
                                                Positioned(
                                                  top: 5,
                                                  right: 5,
                                                  child: GestureDetector(
                                                    onTap: () async {
                                                      _viewModel
                                                          .deletePanImage();
                                                      //_viewModel.fetchServiceProviderDocuments(adminServiceProviderId);
                                                      //_viewModel.selectedServiceProviderImage.clear();
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.black,
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: Icon(
                                                        Icons.close,
                                                        color: Colors.white,
                                                        size: 24,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        const SizedBox(height: 8),
                                        CustomTextField(
                                          controller:
                                              _viewModel.gstinController,
                                          hintText:
                                              AppString.enterGstinHintText,
                                          title: AppString.gstin,
                                          titleColor: Colors.black,
                                          borderRadius: 25,
                                          borderColor: Colors.teal,
                                          borderWidth: 1,
                                          textFieldColor: Colors.white,
                                          // validator: (value) {
                                          //   final gstinRegex = RegExp(r'^[0-9]{2}[A-Z]{4}[0-9]{4}[A-Z]{1}[0-9]{1}[Z]{1}[0-9A-Z]{1}$');
                                          //
                                          //   if (value == null || value.isEmpty) {
                                          //     return 'Please enter your GSTIN';
                                          //   }
                                          //
                                          //   if (!gstinRegex.hasMatch(value)) {
                                          //     return 'Please enter a valid GSTIN';
                                          //   }
                                          //
                                          //   return null;
                                          // },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Checkbox(
                                      value: _viewModel.isChecked,
                                      activeColor: Colors.teal,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          _viewModel.isChecked = value ?? false;
                                        });
                                      },
                                    ),
                                    Text(
                                      AppString.dontHaveGstin,
                                      style: AppTextStyle
                                          .getTextStyle14FontWeightw400BlackT,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 15),
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
                                Container(
                                  margin: EdgeInsets.only(top: 16, bottom: 4),
                                  decoration: BoxDecoration(
                                    color: Color(0xffD5ECEC),
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(20),
                                      bottomRight: Radius.circular(20),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 4, bottom: 4, left: 8, right: 8),
                                    child: Text(
                                      AppString.officialBankDetails,
                                      style: AppTextStyle
                                          .getTextStyle16FontWeightBold,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 10, top: 6),
                                  child: Text(
                                    AppString.bankDetailsDescription,
                                    style: AppTextStyle
                                        .getTextStyle12FontWeightw600G300,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CustomTextField(
                                        controller:
                                            _viewModel.accountNumberController,
                                        hintText: AppString
                                            .enterAccountNumberHintText,
                                        title: AppString.bankAccountNumber,
                                        titleColor: Colors.black,
                                        borderRadius: 25,
                                        borderColor: Colors.teal,
                                        borderWidth: 1,
                                        textFieldColor: Colors.white,
                                        validator: (value) {
                                          final accountNumberRegex =
                                              RegExp(r'^\d{10,16}$');

                                          if (value == null || value.isEmpty) {
                                            return 'Please enter your bank account number';
                                          }

                                          if (!accountNumberRegex
                                              .hasMatch(value)) {
                                            return 'Please enter a valid bank account number (10-16 digits)';
                                          }

                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 8),
                                      CustomTextField(
                                        controller:
                                            _viewModel.bankCodeController,
                                        hintText:
                                            AppString.enterIfscCodeHintText,
                                        title: AppString.ifscCode,
                                        titleColor: Colors.black,
                                        borderRadius: 25,
                                        borderColor: Colors.teal,
                                        borderWidth: 1,
                                        textFieldColor: Colors.white,
                                        validator: (value) {
                                          final ifscRegex =
                                              RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$');
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter your IFSC code';
                                          }
                                          if (!ifscRegex.hasMatch(value)) {
                                            return 'Please enter a valid IFSC code (e.g., ABCD0123456)';
                                          }
                                          return null;
                                        },
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        "Upload Document",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      if (_viewModel.documentsImageName !=
                                              null &&
                                          _viewModel
                                              .documentsImageName!.isNotEmpty)
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Stack(
                                            children: [
                                              // Image Container
                                              Container(
                                                width: double.infinity,
                                                height: 150,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  image: DecorationImage(
                                                    image: NetworkImage(
                                                        "$BASE_URL/uploads/${_viewModel.documentsImageName}"),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              // Close Icon (Positioned at top-right corner)
                                              Positioned(
                                                top: 5,
                                                right: 5,
                                                child: GestureDetector(
                                                  onTap: () async {
                                                    await _viewModel
                                                        .deleteDocumentImage();
                                                    _viewModel.refreshUI();
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.black,
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Icon(
                                                      Icons.close,
                                                      color: Colors.white,
                                                      size: 24,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      SizedBox(height: 15),
                                      GestureDetector(
                                        onTap: () async {
                                          await _viewModel
                                              .pickServiceProviderDocumentsImage();
                                        },
                                        child: Row(
                                          children: [
                                            Icon(Icons.upload_sharp,
                                                color: Colors.teal),
                                            SizedBox(width: 10),
                                            Text(
                                                "Edit\nPassbook first page / Cancelled cheque",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 14,
                                                    color: Colors.teal))
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 12),
                                      if (_viewModel.documentsImageName != null)
                                        Align(
                                          alignment: Alignment.center,
                                          child: SizedBox(
                                            child: Text(
                                              "Supported file ${_viewModel.documentsImageName ?? ""}",
                                              style: TextStyle(
                                                  fontSize: 11,
                                                  color:
                                                      AppColors.hintTextColor,
                                                  fontWeight: FontWeight.w400),
                                              overflow: TextOverflow.ellipsis,
                                              // Prevent overflow issues
                                              maxLines: 1,
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
                    ),
                  ),
                ],
              ),
            ),
          ),
          (widget.salonDocumentEdit == true)
              ? Container(
                  margin:
                      const EdgeInsets.only(left: 15, right: 15, bottom: 20),
                  width: double.infinity,
                  child: CustomButtonWidget(
                    text: AppString.saveChanges,
                    textColor: Colors.white,
                    onPressed: () {
                      if (_viewModel.formKey.currentState!.validate()) {
                        _viewModel.updateData(context);
                        //Get.offAll(() => DashBoardPage());
                        Get.offAll(() => CustomBottomBar());
                      }
                    },
                    buttonColor: fabricColor,
                    borderRadius: 5,
                    buttonHeight: 40,
                  ),
                )
              : Container(
                  margin:
                      const EdgeInsets.only(left: 15, right: 15, bottom: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomButtonWidget(
                          text: AppString.backButton,
                          textColor: Colors.black,
                          onPressed: () {
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
                            if (_viewModel.formKey.currentState!.validate()) {
                              _viewModel.updateData(context);
                              //Get.offAll(() => DashBoardPage());
                              Get.offAll(() => CustomBottomBar());
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

  Future<Uint8List> fetchImageAsBytes(String imageUrl) async {
    String fullUrl =
        imageUrl.startsWith("http") ? imageUrl : "$baseUrl$imageUrl";
    final response = await http.get(Uri.parse(fullUrl));
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception("Failed to load image from URL: $fullUrl");
    }
  }
}
