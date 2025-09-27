import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import 'package:wellwait_app/admin/admin_phone_number_login/admin_auth_viewmodel.dart';
import 'package:wellwait_app/models/services.dart';
import 'package:wellwait_app/utils/colors.dart';
import '../../config_screen.dart';
import '../widget/app_bar.dart';
import 'add_customer_viewmodel.dart';

class AddCustomerPage extends StatefulWidget {
  final String panelName;
  final int panelId;

  const AddCustomerPage(
      {super.key, required this.panelName, required this.panelId});

  @override
  State<AddCustomerPage> createState() => _AddCustomerPageState();
}

class _AddCustomerPageState extends State<AddCustomerPage> {
  late AddCustomerViewModel _viewModel;
  late AdminAuthViewModel _authViewModel;
  final _formKey = GlobalKey<FormState>();
  bool _isPreviewMode = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _viewModel = context.watch<AddCustomerViewModel>();
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () { Get.back(); },
                    child: SvgPicture.asset(
                      "assets/icons/back_icon.svg",
                      height: 25,
                      width: 25,
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        _authViewModel.serviceProvider.salonName ?? "",
                        style: TextStyle(fontSize: 12, color: Colors.grey,fontWeight: FontWeight.w600),
                      ),
                      Text(
                        widget.panelName,
                        style: TextStyle(
                            fontSize: 22,
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.w800),
                      )
                    ],
                  ),
                  SvgPicture.asset("assets/icons/error.svg"),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Card(
                  elevation: 4,
                  color: const Color(0xffFFFFFF),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max, // Allow column to expand
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text("Add Customer to Panel",
                                    style: TextStyle(fontSize: 19,fontWeight: FontWeight.w700),
                                  ),
                                  const SizedBox(height: 25),
                                  _buildTextField(
                                    title: "Customer Name",
                                    hintText: "Enter Name",
                                    controller:
                                        _viewModel.customerNameController,
                                    isViewOnly: _isPreviewMode,
                                  ),
                                  const SizedBox(height: 30),
                                  _buildTextField(
                                    title: "Panel",
                                    hintText: "Enter Name",
                                    controller: TextEditingController(text: widget.panelName),
                                    isViewOnly: true,
                                  ),
                                  const SizedBox(height: 20),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                                    child: Text(
                                      "Select Service",
                                      style: TextStyle(fontSize: 15,fontWeight: FontWeight.w400,color: Colors.black),
                                    ),
                                  ),
                                  Visibility(
                                    visible: !_isPreviewMode,
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(16.0, 0, 16, 10),
                                      child: DropdownButtonFormField<int>(
                                        decoration: InputDecoration(
                                          hintText: "Select Services...",
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
                                        value: null,
                                        items: _authViewModel
                                            .serviceProvider.services
                                            .map((ServiceModel service) {
                                          return DropdownMenuItem<int>(
                                            value: service.id,
                                            child: Text(
                                              service.name ?? "",
                                              style: const TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (int? value) {
                                          if (value != null) {
                                            ServiceModel selectedItem = _authViewModel.serviceProvider.services
                                                    .firstWhere((item) => item.id == value);
                                            _viewModel.addService(selectedItem);
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                  Column(
                                    children: _viewModel.selectedServices.asMap().entries.map((entry) =>
                                        getServiceUI(entry.value, entry.key)).toList(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          width: double.infinity,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                if (_formKey.currentState!.validate()) {
                                  if (_isPreviewMode) {
                                    _viewModel.bookAppointment(serviceProviderId: _authViewModel.serviceProvider.id,
                                      panelId: widget.panelId,
                                    );
                                  } else {
                                    setState(() => _isPreviewMode = true);
                                  }
                                }
                              },
                              child: Center(
                                child: Text(
                                  _isPreviewMode
                                      ? "Add Customer to Panel"
                                      : "Preview & Continue",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
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

  Widget getServiceUI(ServiceModel service, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 3),
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 16, 16, 16),
        decoration: BoxDecoration(
          color: AppColors.secondaryColor,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: AppColors.primaryColor, width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              service.name ?? "",
              style: TextStyle(
                fontSize: 16,
                color: AppColors.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            Row(
              children: [
                Text(
                  "₹ ${service.price}",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.primaryColor,
                  ),
                ),
                const SizedBox(width: 10),
                InkWell(
                  onTap: () {
                    setState(() => _viewModel.removeService(index));
                  },
                  child:
                      Icon(Icons.highlight_remove, color: Colors.red, size: 20),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String title,
    required String hintText,
    required TextEditingController controller,
    required bool isViewOnly,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black),
          ),
          const SizedBox(height: 6),
          (isViewOnly)
              ? Text(
                  controller.text,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryColor,
                  ),
                )
              : TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: hintText,
                    hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide(color: AppColors.primaryColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide:
                          BorderSide(color: AppColors.primaryColor, width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide:
                          BorderSide(color: AppColors.primaryColor, width: 1),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  ),
                ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _viewModel.disposeValues();
    super.dispose();
  }
}
