import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/sp_helper.dart';
import '../admin_email_login/admin_email_login_page.dart';
import '../admin_phone_number_login/admin_phone_number_page.dart';
import '../admin_queue/admin_queue_page.dart';
import '../service_provider_documents/service_provider_documents_page.dart';
import '../service_provider_panels/new_provider_panel.dart';
import '../service_provider_panels/service_providr_panels_page.dart';
import '../service_provider_timing/service_provider_timing_page.dart';

class BeautifulListView extends StatelessWidget {
  final List<Map<String, dynamic>> items = [
    {'title': 'Salon Timing', 'iconPath': Icons.access_time},
    {'title': 'Salon Documents', 'iconPath': Icons.library_books},
    {'title': 'Add Panels', 'iconPath': Icons.admin_panel_settings},
    {'title': 'Salon Queue', 'iconPath': Icons.people},
    {'title': 'Logout', 'iconPath': Icons.logout},
  ];
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true, // Ensures it takes only the required height
      physics: const NeverScrollableScrollPhysics(), // Prevents nested scrolling issues
      itemCount: items.length,
      itemBuilder: (BuildContext context, int index) {
        final isLogout = items[index]['title'] == 'Logout'; // Check if item is Logout
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          child: Container(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    items[index]['iconPath'],
                    size: 20,
                    color: isLogout ? Colors.red : Colors.black, // Red for Logout
                  ),
                  title: Text(
                    items[index]['title'],
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      
                      color: isLogout ? Colors.red : Colors.black, // Red for Logout
                    ),
                  ),
                  onTap: () {
                    // Handle item tap
                    switch (index) {
                      case 0:
                        Get.to(() => ServiceProviderTimingPage());
                        break;
                      case 1:
                        // Get.to(() => ServiceProviderDocumentsPage());
                        Get.to(() => SizedBox());
                        break;
                      case 2:
                        //Get.to(() => ServiceProviderPanelsPage());
                        Get.to(() => NewProviderPanel());
                        break;
                      case 3:
                        Get.to(() => AdminQueuePage());
                        break;
                      case 4:
                        {
                          final SharedPreferenceService _sharedPreferenceService =
                          SharedPreferenceService();
                          _sharedPreferenceService.clearCredentials();
                          //Get.to(() => AdminEmailLoginPage());
                          Get.offAll(() => const AdminPhoneNumberPage());
                          break;
                        }
                    }
                  },
                ),
                if (index != items.length - 1) // Add divider only if not the last item
                  const Divider(
                    thickness: 1,
                    height: 1,
                    color: Colors.grey,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
