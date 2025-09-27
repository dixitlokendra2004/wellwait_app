import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import 'package:wellwait_app/admin/admin_panel/panel_viewmodel.dart';
import 'package:wellwait_app/admin/admin_phone_number_login/admin_auth_viewmodel.dart';
import 'package:wellwait_app/models/panel.dart';
import '../../config_screen.dart';
import '../../utils/app_strings.dart';
import '../../utils/app_text_style.dart';
import '../../utils/colors.dart';
import '../../utils/common_variables.dart';
import '../../widget/custom_button.dart';
import '../../widget/snack_bar_widget.dart';
import '../service_provider_panels/service_provider_panels_viewmodels.dart';
import '../utils/admin_ common_variable.dart';
import '../widget/app_bar.dart';

class AddEditPanelsPage extends StatefulWidget {
  final Panel? panel;

  AddEditPanelsPage({super.key, this.panel});

  @override
  State<AddEditPanelsPage> createState() => _AddEditPanelsPageState();
}

class _AddEditPanelsPageState extends State<AddEditPanelsPage> {
  late AddPanelViewModel _viewModel;
  final formKey = GlobalKey<FormState>();
  late ServiceProviderPanelsViewModels _serviceProviderPanelsViewModels;
  late AdminAuthViewModel _authViewModel;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.panel != null) _viewModel.initPanelDetails(widget.panel!);
    });
  }

  @override
  Widget build(BuildContext context) {
    _viewModel = context.watch<AddPanelViewModel>();
    _serviceProviderPanelsViewModels =
        context.watch<ServiceProviderPanelsViewModels>();
    _authViewModel = context.watch<AdminAuthViewModel>();
    return Scaffold(
      backgroundColor: const Color(0xffECECEC),
      appBar: CustomAppBar(showHomeButton: false),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //CustomAppBar(),
              Text(
                _authViewModel.serviceProvider.salonName.toString(),
                style: TextStyle(
                  fontSize: 22,
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Card(
                  elevation: 4,
                  color: const Color(0xffFFFFFF),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max, // Allow column to expand
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Form(
                              key: formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          Get.back();
                                        },
                                        icon: const Icon(
                                            Icons.arrow_back_ios_new,
                                            color: Colors.black,
                                            size: 19),
                                      ),
                                      const SizedBox(width: 10),
                                      const Text(
                                        "Add Panel",
                                        style: TextStyle(
                                            fontSize: 19,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w700),
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 25),
                                  _buildTextField(
                                      title: "Panel Name",
                                      hintText: "Enter Name",
                                      controller:
                                          _viewModel.panelNameController),
                                  const SizedBox(height: 16),
                                  _buildTextField(
                                      title: "Responsible Person",
                                      hintText: "Enter Name",
                                      controller: _viewModel
                                          .responsiblePersonController),
                                  const SizedBox(height: 16),
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16.0),
                                    child: Text(
                                      "Services",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                    child: DropdownButtonFormField<String>(
                                      decoration: InputDecoration(
                                        hintText: "Select...",
                                        hintStyle: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w400),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 8),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(25.0),
                                          borderSide: BorderSide(
                                              color: AppColors.primaryColor),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(25.0),
                                          borderSide: BorderSide(
                                              color: AppColors.primaryColor),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(25.0),
                                          borderSide: BorderSide(
                                              color: AppColors.primaryColor),
                                        ),
                                      ),
                                      value: _viewModel.selectedService,
                                      items: _viewModel.services
                                          .map((String service) {
                                        return DropdownMenuItem<String>(
                                          value: service,
                                          child: Text(service,
                                              style: const TextStyle(
                                                  fontSize: 14)),
                                        );
                                      }).toList(),
                                      onChanged: (String? value) {
                                        if (value != null &&
                                            !_viewModel.selectedServices
                                                .contains(value)) {
                                          setState(() {
                                            _viewModel.selectedServices
                                                .add(value);
                                            _viewModel.servicePrices[value] =
                                                ''; // Initialize price
                                            _viewModel
                                                    .serviceControllers[value] =
                                                TextEditingController(); // Assign a new controller
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  Column(
                                    children: _viewModel.selectedServices
                                        .map((service) {
                                      return Padding(
                                        padding: const EdgeInsets.all(6.0),
                                        child: Row(
                                          children: [
                                            // Service Name Container
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 20),
                                                child: Container(
                                                  height: 40,
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        const Color(0xffECF6F6),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6),
                                                    border: Border.all(
                                                        color: const Color(
                                                            0xff008080),
                                                        width: 0.8),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      // Service Name
                                                      Text(
                                                        service,
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: AppColors
                                                                .primaryColor),
                                                      ),
                                                      // Price Display
                                                      Row(
                                                        children: [
                                                          Text(
                                                            _viewModel
                                                                    .servicePrices[
                                                                        service]!
                                                                    .isNotEmpty
                                                                ? "₹ ${_viewModel.servicePrices[service]}"
                                                                : "₹ 0",
                                                            style: const TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: Color(
                                                                    0xff008080)),
                                                          ),
                                                          const SizedBox(
                                                              width: 10),
                                                          Container(
                                                            decoration: BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                color: Color(
                                                                    0xff50505080)),
                                                            child: IconButton(
                                                              icon: const Icon(
                                                                  Icons.close,
                                                                  color: Colors
                                                                      .white,
                                                                  size: 14),
                                                              padding:
                                                                  EdgeInsets
                                                                      .zero,
                                                              constraints:
                                                                  const BoxConstraints(),
                                                              onPressed: () {
                                                                setState(() {
                                                                  _viewModel
                                                                      .selectedServices
                                                                      .remove(
                                                                          service);
                                                                  _viewModel
                                                                      .servicePrices
                                                                      .remove(
                                                                          service);
                                                                  _viewModel
                                                                      .serviceControllers
                                                                      .remove(
                                                                          service); // Remove controller
                                                                });
                                                              },
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            // Price Input Field
                                            Container(
                                              width: 80,
                                              height: 40,
                                              margin: const EdgeInsets.only(
                                                  right: 10, top: 0),
                                              child: TextField(
                                                controller: _viewModel
                                                        .serviceControllers[
                                                    service],
                                                // Use service-specific controller
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration: InputDecoration(
                                                  hintText: "Price",
                                                  hintStyle: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color:
                                                          Color(0xff50505080)),
                                                  border:
                                                      const OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.grey),
                                                  ),
                                                  enabledBorder:
                                                      const OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.grey),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: _viewModel
                                                              .servicePrices[
                                                                  service]!
                                                              .isNotEmpty
                                                          ? const Color(
                                                              0xff008080)
                                                          : Colors.grey,
                                                    ),
                                                  ),
                                                  contentPadding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 8,
                                                          vertical: 6),
                                                ),
                                                onChanged: (value) {
                                                  setState(() {
                                                    _viewModel.servicePrices[
                                                        service] = value;
                                                  });
                                                },
                                                onSubmitted: (value) {
                                                  FocusScope.of(context)
                                                      .unfocus();
                                                },
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                  const SizedBox(height: 12),
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16.0),
                                    child: Text("Lunch Time",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black)),
                                  ),
                                  const SizedBox(height: 10),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16, right: 16),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        timePickerContainer(
                                            AppString.openingTime,
                                            _viewModel.lunchStartTime, (time) {
                                          setState(() {
                                            _viewModel.lunchStartTime = time;
                                          });
                                        }),
                                        SizedBox(width: 10),
                                        timePickerContainer(
                                            AppString.closingTime,
                                            _viewModel.lunchEndTime, (time) {
                                          setState(() {
                                            _viewModel.lunchEndTime = time;
                                          });
                                        }),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          width: double.infinity,
                          child: CustomButtonWidget(
                            text: (widget.panel != null)
                                ? "Save Changes"
                                : "Add Panel",
                            textColor: Colors.white,
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                if (_viewModel.selectedServices.isEmpty) {
                                  CustomSnackBar.showSnackBar(
                                      "Please select at least one service");
                                  return;
                                }

                                bool allPricesValid = true;
                                for (var service
                                    in _viewModel.selectedServices) {
                                  if (_viewModel.servicePrices[service] ==
                                          null ||
                                      _viewModel.servicePrices[service]!
                                          .trim()
                                          .isEmpty) {
                                    allPricesValid = false;
                                    break;
                                  }
                                }
                                if (!allPricesValid) {
                                  CustomSnackBar.showSnackBar(
                                      "Please enter a price for all services");
                                  return;
                                }
                                if (_viewModel.lunchStartTime == null ||
                                    _viewModel.lunchEndTime == null) {
                                  CustomSnackBar.showSnackBar(
                                      "Please select lunch start and end time");
                                  return;
                                }
                                if (_viewModel.lunchStartTime!
                                    .isAfter(_viewModel.lunchEndTime!)) {
                                  CustomSnackBar.showSnackBar(
                                      "Start time must be before end time");
                                  return;
                                }
                                if (_viewModel
                                    .panelNameController.text.isEmpty) {
                                  CustomSnackBar.showSnackBar(
                                      "Please fill the panel name");
                                  return;
                                }
                                if (_viewModel
                                    .responsiblePersonController.text.isEmpty) {
                                  CustomSnackBar.showSnackBar(
                                      "Please fill the responsible person");
                                  return;
                                }

                                if (widget.panel != null) {
                                  await _viewModel.updatePanelDetails(
                                      panelId: widget.panel?.id,
                                      lunchStart: _viewModel.lunchStartTime,
                                      lunchEnd: _viewModel.lunchEndTime);
                                } else {
                                  await _viewModel.addPanel();
                                }
                                Get.back();
                                _serviceProviderPanelsViewModels.fetchPanels();
                              }
                            },
                            buttonColor: fabricColor,
                            borderRadius: 5,
                            buttonHeight: 40,
                            buttonSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget timePickerContainer(
      String title, TimeOfDay? time, ValueChanged<TimeOfDay?> onTimeChanged) {
    return GestureDetector(
      onTap: () async {
        final selectedTime = await showTimePicker(
          context: context,
          initialTime: time ?? TimeOfDay.now(),
          builder: (context, child) {
            return Theme(
              data: ThemeData.light().copyWith(
                primaryColor: Colors.transparent, // Clock hands color
                hintColor: Colors.red, // Active hour/minute text color
                colorScheme: ColorScheme.light(
                  primary: AppColors.primaryColor, // OK & Cancel button color
                  onSurface: Colors.black, // Inactive hour/minute text color
                ),
                textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(
                    foregroundColor:
                        AppColors.primaryColor, // Cancel & OK button text color
                  ),
                ),
              ),
              child: child!,
            );
          },
        );

        if (selectedTime != null) {
          onTimeChanged(selectedTime);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Color(0xff7E7E7E4D), width: 1),
          color: Colors.white,
        ),
        padding: const EdgeInsets.only(left: 10, right: 10, top: 7, bottom: 7),
        child: Row(
          children: [
            Icon(Icons.access_time, color: fabricColor, size: 18),
            const SizedBox(width: 8),
            Text(
              time != null ? time.format(context) : AppString.selectTime,
              style: AppTextStyle.getTextStyle13FontWeightw700Black,
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildTimeContainer(
  //     {required String label, TimeOfDay? time, required VoidCallback onTap}) {
  //   return GestureDetector(
  //     onTap: onTap,
  //     child: Container(
  //       width: 150,
  //       padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
  //       decoration: BoxDecoration(
  //         border: Border.all(color: const Color(0xff7E7E7E4D)),
  //         borderRadius: BorderRadius.circular(12),
  //         color: Colors.white,
  //       ),
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           const Icon(Icons.access_time, color: Colors.teal, size: 24),
  //           // Clock icon
  //           const SizedBox(width: 10),
  //           Text(
  //             time != null ? time.format(context) : "Select",
  //             style: const TextStyle(fontSize: 14, color: Colors.black54),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // Method to create a TextField
  Widget _buildTextField(
      {required String title,
      required String hintText,
      required TextEditingController controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            title,
            style: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black),
          ),
        ),
        const SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontWeight: FontWeight.w400),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide(color: AppColors.primaryColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide(color: AppColors.primaryColor, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide(color: AppColors.primaryColor, width: 1),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _viewModel.disposeValues();
    super.dispose();
  }
}
