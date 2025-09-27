import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import '../setting/admin_setting_page.dart';
import '../setting/setting_viewmodel.dart';
import 'bottom_bar/bottom_bar.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Color? bgColor;
  final bool showHomeButton;
  CustomAppBar({super.key,this.bgColor = const Color(0xffECECEC), required this.showHomeButton});
  late AdminSettingsViewModel _adminSettingsViewModel;
  @override
  Widget build(BuildContext context) {
    _adminSettingsViewModel = context.watch<AdminSettingsViewModel>();
    return AppBar(
      backgroundColor: bgColor,
      shadowColor: bgColor,
      elevation: 0,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 15),
          child: (showHomeButton == true)
              ? GestureDetector(
                  onTap: () {
                    Get.offAll(() => CustomBottomBar());
                  },
                  child: Container(
                    child: SvgPicture.asset("assets/icons/home.svg",
                        height: 25, width: 25, color: Colors.black),
                  ),
                )
              : GestureDetector(
                  onTap: () {
                    Get.to(() => AdminSettingScreen());
                  },
                  child: ClipOval(
                    child: Image.asset(
                      "assets/icons/profile.png",
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
        ),
      ],
      leading: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SvgPicture.asset(
          "assets/icons/star.svg",
          height: 24,
          width: 24,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  // String getProfileImage(String? imageUrl) {
  //   final List<String> promoImages = (imageUrl ?? '').split(',').map((s) => s.trim()).toList();
  //   return (promoImages.isNotEmpty && promoImages[0].isNotEmpty)
  //       ? '$BASE_URL/uploads/${promoImages[0]}' : dummyimage;
  // }
  //
  // circularAdminImage() {
  //   return IconButton(
  //     icon: CircleAvatar(
  //       radius: 18,
  //       backgroundImage: NetworkImage(
  //           getProfileImage(_adminSettingsViewModel.adminImage)),
  //     ),
  //     onPressed: () {
  //       Get.to(() => AdminSettingScreen());
  //     },
  //   );
  // }
}
