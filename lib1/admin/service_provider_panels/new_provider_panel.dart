import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:wellwait_app/admin/admin_phone_number_login/admin_auth_viewmodel.dart';
import 'package:wellwait_app/admin/service_provider_panels/service_provider_panels_viewmodels.dart';
import 'package:wellwait_app/models/panel.dart';
import 'package:wellwait_app/models/salon_timing.dart';
import 'package:wellwait_app/utils/colors.dart';
import '../../utils/common_variables.dart';
import '../../widget/snack_bar_widget.dart';
import '../admin_panel/new_panel_page.dart';
import '../admin_queue/detail_panel/detail_panel_page.dart';
import '../utils/admin_ common_variable.dart';
import '../widget/app_bar.dart';

class NewProviderPanel extends StatefulWidget {
  const NewProviderPanel({super.key});

  @override
  State<NewProviderPanel> createState() => _NewProviderPanelState();
}

class _NewProviderPanelState extends State<NewProviderPanel> {
  late ServiceProviderPanelsViewModels _viewModel;
  late AdminAuthViewModel _authViewModel;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _viewModel.fetchPanels();
      await _viewModel.fetchBookingCount();
      adminSalonName =_authViewModel.serviceProvider.salonName.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    _viewModel = context.watch<ServiceProviderPanelsViewModels>();
    _authViewModel = context.watch<AdminAuthViewModel>();
    return Scaffold(
      backgroundColor: const Color(0xffECECEC),
      appBar: CustomAppBar(showHomeButton: false),
      body: Padding(
        padding:
            const EdgeInsets.only(left: 12, right: 12, bottom: 12, top: 20),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    _authViewModel.serviceProvider.salonName.toString(),
                    style: TextStyle(
                      fontSize: 22,
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () async {
                      Get.to(() => AddEditPanelsPage());
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.add, color: Colors.white, size: 15),
                          SizedBox(width: 6),
                          Text("Add Panel",
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                fontSize: 12,
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Expanded(
              child: _viewModel.panels.isEmpty
                  ? const Center(
                      child: Text(
                        "No panels available",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _viewModel.panels.length,
                      itemBuilder: (context, index) {
                        final panel = _viewModel.panels[index];
                        return panelCard(
                          index,
                          index + 1,
                          panel.name.toString(),
                          panel.lunchStart.toString(),
                          panel.lunchEnd.toString(),
                          panel.serviceList.toString(),
                          panel.queueCount ?? 0,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget panelCard(
      int index,
      int panelNumber,
      String panelName,
      String lunchStart,
      String lunchEnd,
      String selectedServices,
      int qCount
      ) {
    Panel panel = _viewModel.panels[index];
    SalonTiming todayTiming =
        _authViewModel.serviceProvider.salonTimings.firstWhere(
      (t) => t.dayIndex == DateTime.now().weekday,
      orElse: () => SalonTiming(endTime: "00:00"), // Default value
    );

    DateTime now = DateTime.now();
    DateTime closingTime = DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(todayTiming.endTime?.split(':')[0] ?? "0"),
      int.parse(todayTiming.endTime?.split(':')[1] ?? "0"),
    );

    Duration timeLeft = closingTime.difference(now);
    String formattedTimeLeft = timeLeft.isNegative
        ? "00:00"
        : DateFormat("H:mm").format(DateTime(0).add(timeLeft));
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: GestureDetector(
        onTap: () {
          Get.to(() => DetailPanelPage(
                panelId: panel.id ?? 0,
                panelName: panelName,
                salonName: _authViewModel.serviceProvider.salonName ?? "",
              ));
        },
        child: Card(
          color: Colors.white,
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Panel $panelNumber",
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            )),
                        const SizedBox(height: 4),
                        Text(panelName,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                              fontWeight: FontWeight.w600
                            )),
                      ],
                    ),
                    Row(
                      children: [
                        SvgPicture.asset("assets/icons/person_icon.svg"),
                        const SizedBox(width: 4),
                        Text(qCount.toString(),
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.w700,
                            )),
                        const SizedBox(width: 20),
                        GestureDetector(
                          onTap: () {
                            print(panel.id);
                            Get.to(() => AddEditPanelsPage(panel: panel));
                          },
                          child: SvgPicture.asset(
                            "assets/icons/edit.svg",
                            height: 22,
                          ),
                        ),
                        SizedBox(width: 20),
                        IconButton(
                          onPressed: () {
                            showDeleteDialog(context,index + 1,panel.id ?? 0);
                          },
                            icon: Icon(Icons.delete,color: Colors.red),
                        )
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedServices.isNotEmpty
                          ? "${selectedServices}"
                          : "No services selected",
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Lunch",
                          style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 7),
                        Text(
                          "$lunchStart - $lunchEnd",
                          style: TextStyle(fontSize: 14, color: Colors.grey,fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                if (panel.isPanelLive == 0)
                  InkWell(
                    onTap: () {
                      _viewModel.setPanelStatus(panel, 1);
                    },
                    child: Container(
                      width: double.infinity,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Color(0xff707070)),
                      ),
                      child: const Center(
                        child: Text(
                          "Start Panel",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  )
                else
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: AppColors.secondaryColor,
                            border: Border.all(color: AppColors.primaryColor),
                          ),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 10,
                            ),
                            child: Center(
                              child: Text(
                                "· Live      ${formattedTimeLeft} hrs, today",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.closePanelColor),
                        ),
                        child: InkWell(
                          onTap: () {
                            _viewModel.setPanelStatus(panel, 0);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 10,
                            ),
                            child: Text(
                              "Close",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: AppColors.closePanelColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatTime(TimeOfDay time) {
    final now = DateTime.now();
    final dateTime =
        DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat.jm().format(dateTime);
  }

  void showDeleteDialog(BuildContext context, int count,int panelId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white, // Ensure the dialog background is white
          title: Text(
            "Confirm Delete",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryColor,
            ),
          ),
          content: Text(
            "Are you sure you want to delete this panel ${count}?",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.black, // Ensure text is visible on white background
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                },
              child: Text("Cancel",style: TextStyle(color: Colors.black54)),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _viewModel.deletePanel(panelId,count);
                print("delete panel id : ${panelId}");
                await _viewModel.fetchPanels();
              },
              child: Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
