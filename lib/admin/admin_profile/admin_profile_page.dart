import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../../widget/custom_button.dart';
import '../widget/app_bar.dart';
import 'admin_profile_viewmodel.dart';

class AdminProfilePage extends StatefulWidget {
  @override
  _AdminProfilePageState createState() => _AdminProfilePageState();
}
class _AdminProfilePageState extends State<AdminProfilePage> {
  late AdminProfileViewModel _viewModel;
  @override
  Widget build(BuildContext context) {
    _viewModel = context.watch<AdminProfileViewModel>();
    return Scaffold(
      backgroundColor: const Color(0xffECECEC),
      appBar: CustomAppBar(showHomeButton: true),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Profile Image Container
            GestureDetector(
              onTap: () => _viewModel.pickServiceProviderImage(),
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: Offset(4, 4),
                    ),
                  ],
                  image: _viewModel.adminImage.isNotEmpty
                      ? DecorationImage(
                    image: NetworkImage('$BASE_URL/uploads/${_viewModel.adminImage}'),
                    fit: BoxFit.cover,
                  )
                      : DecorationImage(image: AssetImage(dummyimage)),
                ),
              ),
            ),
            SizedBox(width: 20),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomButtonWidget(
                  text: "Pick image",
                  textColor: Colors.white,
                  onPressed: () => _viewModel.pickServiceProviderImage(),
                  buttonColor: fabricColor,
                  borderRadius: 10,
                  buttonHeight: 40,
                  icon: Icons.upload_sharp,
                ),
                SizedBox(height: 10),
                CustomButtonWidget(
                  text: "Remove image",
                  textColor: Colors.white,
                  onPressed: () => _viewModel.adminImage.isNotEmpty
                      ? _viewModel.removeImage()
                      : null,
                  buttonColor: fabricColor,
                  borderRadius: 10,
                  buttonHeight: 40,
                  icon: Icons.delete_outline,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}