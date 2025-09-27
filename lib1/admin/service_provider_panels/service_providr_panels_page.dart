import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import 'package:wellwait_app/admin/service_provider_panels/service_provider_panels_viewmodels.dart';
import 'package:wellwait_app/admin/utils/admin_ common_variable.dart';
import 'package:wellwait_app/utils/colors.dart';
import '../../utils/app_text_style.dart';
import '../admin_email_login/admin_email_login_viewmodel.dart';
import '../admin_panel/admin_panel_page.dart';
import '../admin_panel/new_panel_page.dart';

class ServiceProviderPanelsPage extends StatefulWidget {
  const ServiceProviderPanelsPage({super.key});

  @override
  State<ServiceProviderPanelsPage> createState() => _ServiceProviderPanelsPageState();
}

class _ServiceProviderPanelsPageState extends State<ServiceProviderPanelsPage> {
  late ServiceProviderPanelsViewModels _viewModel;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      //await _viewModel.fetchPanels(_homePageViewModel.serviceProviderId!);
      await _viewModel.fetchPanels();
    });
  }
  late AdminEmailLoginViewModel _homePageViewModel;

  @override
  Widget build(BuildContext context) {
    _viewModel = context.watch<ServiceProviderPanelsViewModels>();
    _homePageViewModel = Provider.of<AdminEmailLoginViewModel>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
              "Salon Panels",
              style: AppTextStyle.getTextStyle18FontWeightBold
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back_ios_new,color: Colors.black,),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                child: GestureDetector(
                 // onTap: () {Get.to(() => AdminPanelPage());},
                  //onTap: () {Get.to(() => AddPanelsPage());},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Icon(Icons.add,size: 25,color: Colors.teal,),
                      const SizedBox(width: 8),
                      Text(
                        "Add panels",
                        style: AppTextStyle.getTextStyle16FontWeightw300Teal,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                child: Column(
                  children: _viewModel.panels.map((panel) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: ExpansionTile(
                        collapsedBackgroundColor: Colors.blue.shade50,
                        enableFeedback: false,
                        title: Text(
                          "Panel - ${panel.name ?? "Unnamed Panel"}",
                          style: AppTextStyle.getTextStyle16FontWeightw600,
                        ),
                        children: [
                          cardWidget("Panel Name: ",panel.name.toString(),Colors.white),
                          cardWidget("Description: ",panel.responsiblePerson.toString(),const Color(0xfff6f6f6)),
                          cardWidget("Price: ",panel.price.toString(),Colors.white),
                          cardWidget("Service List: ",panel.serviceList.toString(),const Color(0xfff6f6f6)),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  cardWidget(String title , String text,Color bgColor) {
    return Container(
      padding: const EdgeInsets.all(3),
      color: bgColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              
              color: Colors.black54,
            ),
          ),
          Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              
            ),
          ),
        ],
      ),
    );
  }

}
