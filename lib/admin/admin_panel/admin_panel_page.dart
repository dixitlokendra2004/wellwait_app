import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import 'package:wellwait_app/admin/utils/admin_%20common_variable.dart';
import '../../utils/app_strings.dart';
import '../../utils/app_text_style.dart';
import '../../utils/colors.dart';
import '../../widget/custom_button.dart';
import '../../widget/custom_textfield.dart';
import '../admin_email_login/admin_email_login_viewmodel.dart';
import '../dashboard/dashboard_viewmodel.dart';
import '../service_provider_panels/service_provider_panels_viewmodels.dart';
import 'admin_panel_viewmodel.dart';

class AdminPanelPage extends StatefulWidget {
  final Function()? onNext;
  final Function()? onBack; // Add this line

  AdminPanelPage({super.key, this.onNext, this.onBack});

  @override
  State<AdminPanelPage> createState() => _AdminPanelPageState();
}

class _AdminPanelPageState extends State<AdminPanelPage> {
  final _formKey = GlobalKey<FormState>();
  late AdminPanelViewModel _viewModel;
  late ServiceProviderPanelsViewModels _serviceProviderPanelsViewModels;

  @override
  Widget build(BuildContext context) {
    _viewModel = context.watch<AdminPanelViewModel>();
    _viewModel.adminEmailLoginViewModel = context.watch<AdminEmailLoginViewModel>();
    _serviceProviderPanelsViewModels = context.watch<ServiceProviderPanelsViewModels>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Salon Panels",
          style: AppTextStyle.getTextStyle18FontWeightBold
        ),
        leading: IconButton(
          onPressed: () {
            //Navigator.pop(context);
            Get.back();
          },
          icon: const Icon(Icons.arrow_back_ios_new,color: Colors.black,),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 15, right: 15, bottom: 15,top: 12),
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
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTextField(
                              controller: _viewModel.nameController,
                              hintText: "Enter name",
                              title: "Name",
                              titleColor: Colors.black,
                              borderRadius: 25,
                              borderColor: Colors.teal,
                              borderWidth: 1,
                              textFieldColor: Colors.white,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your Name';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 8),
                            CustomTextField(
                              controller: _viewModel.descriptionController,
                              hintText: "Enter description",
                              title: "Description",
                              titleColor: Colors.black,
                              borderRadius: 25,
                              borderColor: Colors.teal,
                              borderWidth: 1,
                              textFieldColor: Colors.white,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your description';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 8),
                            CustomTextField(
                              controller: _viewModel.priceController,
                              hintText: "Enter price",
                              title: "Price",
                              titleColor: Colors.black,
                              borderRadius: 25,
                              borderColor: Colors.teal,
                              borderWidth: 1,
                              textFieldColor: Colors.white,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your price';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 8),
                            CustomTextField(
                              controller: _viewModel.serviceListController,
                              hintText: "Enter service list",
                              title: "Service List",
                              titleColor: Colors.black,
                              borderRadius: 25,
                              borderColor: Colors.teal,
                              borderWidth: 1,
                              textFieldColor: Colors.white,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your service list';
                                }
                                return null;
                              },
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
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(left: 15, right: 15, bottom: 20),
            child: CustomButtonWidget(
              text: "Submit",
              textColor: Colors.white,
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Call the addPanel function if form is valid
                  _viewModel.addPanel();
                  Get.back();
                  _viewModel.nameController.text = "";
                  _viewModel.descriptionController.text = "";
                  _viewModel.priceController.text = "";
                  _viewModel.serviceListController.text = "";
                  _serviceProviderPanelsViewModels.fetchPanels();
                }
              },
              buttonColor: fabricColor,
              borderRadius: 5,
              buttonHeight: 40,
              //borderColor: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
