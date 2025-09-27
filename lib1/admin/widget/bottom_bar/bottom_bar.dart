import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:wellwait_app/admin/admin_phone_number_login/admin_auth_viewmodel.dart';
import 'package:wellwait_app/utils/colors.dart';
import '../../../utils/common_variables.dart';
import '../../Transactions/Transactions_page.dart';
import '../../admin_email_login/admin_email_login_viewmodel.dart';
import '../../admin_notification/admin_notification_page.dart';
import '../../service_provider_panels/new_provider_panel.dart';
import '../../service_provider_timing/service_provider_timing_page.dart';
import '../../total_panel_payment/total_panel_payment_page.dart';
import '../../utils/admin_ common_variable.dart';
import 'bottom_bar_viewmodel.dart';

class CustomBottomBar extends StatefulWidget {
  final List<Widget>? pages; // Accepts a list of pages, can be null

  const CustomBottomBar({super.key, this.pages}); // No 'required' keyword

  @override
  State<CustomBottomBar> createState() => _CustomBottomBarState();
}

class _CustomBottomBarState extends State<CustomBottomBar> {
  late AdminEmailLoginViewModel _homePageViewModel;
  late AdminAuthViewModel _authViewModel;
  late BottomBarViewModel _viewModel;
  late var panelsProvider;
  late String salonServiceImage;
  late var provider;
  bool initailzed = false;
  late String number;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      //await _viewModel.fetchSalonTimings(_homePageViewModel.serviceProviderId.toString());
      await _viewModel.updateFcmToken();
      await _viewModel.fetchSalonTimings(adminServiceProviderId.toString());
      await _viewModel.fetchBookingCount();
      //await _viewModel.fetchPanels(_homePageViewModel.serviceProviderId!);
      await _viewModel.fetchPanels(adminServiceProviderId);
      //await _viewModel.fetchSalonServiceProvidersById(_homePageViewModel.serviceProviderId!);
      //await _viewModel.fetchSalonServiceProvidersData(_homePageViewModel.serviceProviderId!);
      await _authViewModel
          .fetchSalonServiceProvidersData(adminServiceProviderId);
      panelsProvider = _viewModel.panels[0];
      // final List<dynamic> promoImages =
      // (provider.imageUrl ?? '').split(',').map((s) => s.trim()).toList();
      // salonServiceImage = (promoImages.isNotEmpty && promoImages[0].isNotEmpty)
      //     ? '$BASE_URL/uploads/${promoImages[0]}'
      //     : dummyimage;
      mobileNumber = Provider.of<AdminAuthViewModel>(context, listen: false)
          .serviceProvider
          .mobileNumber
          .toString();
      panelId = panelsProvider.id;
      initailzed = true;
      setState(() {});
    });
  }

  void _onIconTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    _viewModel = context.watch<BottomBarViewModel>();
    _authViewModel = context.watch<AdminAuthViewModel>();
    _homePageViewModel =
        Provider.of<AdminEmailLoginViewModel>(context, listen: false);

    final List<Widget> pages = widget.pages ??
        [
          NewProviderPanel(),
          TransactionsPage(),
          TotalPanelPaymentPage(),
          AdminNotificationPage(),
        ];

    return Scaffold(
      body: (_authViewModel.serviceProvider.id == null)
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 70),
                  child: Container(
                      color: const Color(0xffECECEC),
                      child: pages[selectedIndex]),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: EdgeInsets.only(left: 30,right: 30),
                    width: double.infinity,
                    height: 70,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: containerButtons(),
                  ),
                ),
              ],
            ),
    );
  }

  Widget containerButtons() {
    return Padding(
      padding: const EdgeInsets.all(22),
      child: Container(
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => _onIconTapped(0),
              child: SvgPicture.asset(
                "assets/icons/home.svg",
                height: selectedIndex == 0 ? 30 : 25,
                color: selectedIndex == 0 ? AppColors.primaryColor : Colors.grey,
              ),
            ),
            GestureDetector(
              onTap: () => _onIconTapped(1),
              child: SvgPicture.asset(
                "assets/icons/money_bag.svg",
                height: selectedIndex == 1 ? 30 : 25,
                color: selectedIndex == 1 ? AppColors.primaryColor : Colors.grey,
              ),
            ),
            GestureDetector(
              onTap: () => _onIconTapped(2),
              child: SvgPicture.asset(
                "assets/icons/graph_icon.svg",
                height: selectedIndex == 2 ? 30 : 25,
                color: selectedIndex == 2 ? AppColors.primaryColor : Colors.grey,
              ),
            ),
            GestureDetector(
              onTap: () => _onIconTapped(3),
              child: SvgPicture.asset(
                "assets/icons/well_icon.svg",
                height: selectedIndex == 3 ? 30 : 25,
                color: selectedIndex == 3 ? AppColors.primaryColor : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// HomePage passes the pages to MainScreen
// class HomePage extends StatelessWidget {
//   const HomePage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MainScreen(
//       pages: [
//         Center(child: GestureDetector(
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => LandingPage()),
//             );
//           },
//             child: Text("Home Page"))),
//         const Center(child: Text("Users Page")),
//         const Center(child: Text("Settings Page")),
//       ],
//     );
//   }
// }

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomBottomBar(
      pages: [
        Center(
          child: Text("Landing Page"),
        ),
      ],
    );
  }
}
