// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:provider/provider.dart';
// import 'package:wellwait_app/admin/service_provider_details/service_provider_details_viewmodel.dart';
//
// import '../../utils/app_text_style.dart';
// import '../../utils/colors.dart';
// import '../admin_email_login/admin_email_login_viewmodel.dart';
//
// class ServiceProviderDetailsPage extends StatefulWidget {
//   const ServiceProviderDetailsPage({super.key});
//
//   @override
//   State<ServiceProviderDetailsPage> createState() => _ServiceProviderDetailsPageState();
// }
//
// class _ServiceProviderDetailsPageState extends State<ServiceProviderDetailsPage> {
//   late ServiceProviderDetailsViewModel _viewModel;
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       //await _viewModel.fetchSalonServiceProvidersById(_homePageViewModel.serviceProviderId!);
//       await _viewModel.fetchSalonServiceProvidersData(_homePageViewModel.serviceProviderId!);
//
//     });
//   }
//   late AdminEmailLoginViewModel _homePageViewModel;
//   @override
//   Widget build(BuildContext context) {
//     _viewModel = context.watch<ServiceProviderDetailsViewModel>();
//     _homePageViewModel = Provider.of<AdminEmailLoginViewModel>(context, listen: false);
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         title: Center(
//           child: Text(
//               "Salon Details",
//               style: AppTextStyle.getTextStyle18FontWeightBold
//           ),
//         ),
//         leading: IconButton(
//           onPressed: () {
//             Get.back();
//           },
//           icon: const Icon(Icons.arrow_back_ios_new,color: Colors.black,),
//         ),
//       ),
//       body: _viewModel.isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : ListView.builder(
//         itemCount: _viewModel.serviceProvider.length,
//         itemBuilder: (context, index) {
//           final ServiceProvider = _viewModel.serviceProvider[index];
//           return Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   ServiceProvider.salonName.toString(),
//                   style: const TextStyle(
//                     
//                     fontWeight: FontWeight.w500,
//                     fontSize: 22,
//                     color: fabricColor,
//                   ),
//                 ),
//                 const SizedBox(height: 15),
//                 cardWidget("Name: ",ServiceProvider.providerName.toString()),
//                 cardWidget("Service Name: ",ServiceProvider.serviceNames.toString()),
//                 cardWidget("Address: ",ServiceProvider.address.toString()),
//                 cardWidget("Mobile Number: ",ServiceProvider.mobileNumber.toString()),
//                 cardWidget("Email: ",ServiceProvider.email.toString()),
//
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   cardWidget(String title , String text) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           title,
//           style: const TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.w400,
//             
//             color: Colors.black54,
//           ),
//         ),
//         Text(
//           text,
//           style: const TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.w500,
//             
//           ),
//         ),
//       ],
//     );
//   }
// }
