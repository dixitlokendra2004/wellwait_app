// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:provider/provider.dart';
// import 'package:wellwait_app/admin/service_provider_documents/service_provider_documents_viewmodel.dart';
// import '../../utils/app_text_style.dart';
// import '../admin_email_login/admin_email_login_viewmodel.dart';
// import '../service_provider_details/service_provider_details_viewmodel.dart';
//
// class ServiceProviderDocumentsPage extends StatefulWidget {
//   const ServiceProviderDocumentsPage({super.key});
//
//   @override
//   State<ServiceProviderDocumentsPage> createState() => _ServiceProviderDocumentsPageState();
// }
//
// class _ServiceProviderDocumentsPageState extends State<ServiceProviderDocumentsPage> {
//   late ServiceProviderDocumentsViewModel _viewModel;
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       await _viewModel.fetchSalonServiceProvidersData();
//     });
//   }
//   late AdminEmailLoginViewModel homePageViewModel;
//   @override
//   Widget build(BuildContext context) {
//     _viewModel = context.watch<ServiceProviderDocumentsViewModel>();
//     _viewModel.homePageViewModel = Provider.of<AdminEmailLoginViewModel>(context, listen: false);
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         title: Center(
//           child: Text(
//               "Salon Documents",
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
//                 const SizedBox(height: 15),
//                 cardWidget("Pan card number: ",ServiceProvider.panCard.toString(),Colors.white),
//                 cardWidget("GstIn: ",ServiceProvider.gstIn.toString(),const Color(0xfff6f6f6)),
//                 cardWidget("Bank account number: ",ServiceProvider.bankAccountNumber.toString(),Colors.white),
//                 cardWidget("Bank IFSC code: ",ServiceProvider.bankIfscCode.toString(),const Color(0xfff6f6f6)),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   cardWidget(String title , String text,Color bgColor) {
//     return Container(
//       padding: const EdgeInsets.all(8.0),
//       color: bgColor,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             title,
//             style: const TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.w400,
//               
//               color: Colors.black54,
//             ),
//           ),
//           Text(
//             text,
//             style: const TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w500,
//               
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
// }
