// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import 'package:wellwait_app/admin/utils/admin_ common_variable.dart';
// import 'package:wellwait_app/utils/common_variables.dart';
// import '../../models/salon_timing.dart';
// import '../../utils/app_text_style.dart';
// import '../../utils/colors.dart';
// import '../../utils/constants.dart';
// import '../admin_email_login/admin_email_login_viewmodel.dart';
// import '../widget/beautiful_list.dart';
// import 'dashboard_viewmodel.dart';
//
// class DashBoardPage extends StatefulWidget {
//   const DashBoardPage({Key? key}) : super(key: key);
//
//   @override
//   State<DashBoardPage> createState() => _DashBoardPageState();
// }
//
// class _DashBoardPageState extends State<DashBoardPage> {
//   late DashboardViewModel _viewModel;
//   late var serviceProvider;
//   late String salonServiceImage;
//   late var provider;
//   bool initailzed = false;
//   late String number;
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       //await _viewModel.fetchSalonTimings(_homePageViewModel.serviceProviderId.toString());
//       await _viewModel.updateFcmToken();
//       await _viewModel.fetchSalonTimings(adminServiceProviderId.toString());
//       await _viewModel.fetchBookingCount();
//       //await _viewModel.fetchPanels(_homePageViewModel.serviceProviderId!);
//       await _viewModel.fetchPanels(adminServiceProviderId);
//       //await _viewModel.fetchSalonServiceProvidersById(_homePageViewModel.serviceProviderId!);
//       await _viewModel.fetchSalonServiceProvidersById(adminServiceProviderId);
//       //await _viewModel.fetchSalonServiceProvidersData(_homePageViewModel.serviceProviderId!);
//       await _viewModel.fetchSalonServiceProvidersData(adminServiceProviderId);
//       serviceProvider = _viewModel.serviceProvider[0];
//       provider = _viewModel.serviceProvider[0];
//       final List<dynamic> promoImages =
//           (provider.imageUrl ?? '').split(',').map((s) => s.trim()).toList();
//       salonServiceImage = (promoImages.isNotEmpty && promoImages[0].isNotEmpty)
//           ? '$BASE_URL/uploads/${promoImages[0]}'
//           : dummyimage;
//       mobileNumber = serviceProvider.mobileNumber.toString();
//       initailzed = true;
//       setState(() {});
//     });
//   }
//
//   late AdminEmailLoginViewModel _homePageViewModel;
//
//   @override
//   Widget build(BuildContext context) {
//     _viewModel = context.watch<DashboardViewModel>();
//     _homePageViewModel = Provider.of<AdminEmailLoginViewModel>(context, listen: false);
//     return Scaffold(
//       body: Stack(
//         children: [
//           (!initailzed)
//               ? Container()
//               : SingleChildScrollView(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       //topImage(context),
//                       imageCard(salonServiceImage),
//                       Container(
//                         margin:
//                             const EdgeInsets.only(left: 15, right: 15, top: 10),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text(
//                                   serviceProvider.salonName.toString(),
//                                   style:
//                                       AppTextStyle.getTextStyle22FontWeightw700,
//                                   overflow: TextOverflow.ellipsis,
//                                   maxLines: 1,
//                                 ),
//                                 Text(
//                                   serviceProvider.providerName.toString(),
//                                   style: AppTextStyle
//                                       .getTextStyle20FontWeightw600B,
//                                 ),
//                               ],
//                             ),
//                             //const SizedBox(height: 10),
//                             Text(
//                               serviceProvider.address.toString(),
//                               style: AppTextStyle.getTextStyle14FontWeightw700,
//                             ),
//                             // Text(
//                             //  mobileNumber,
//                             //   style: AppTextStyle.getTextStyle14FontWeightw700,
//                             // ),
//                             const SizedBox(height: 20),
//                             Row(
//                               children: [
//                                 Row(
//                                   children: [
//                                     const Icon(
//                                       Icons.access_time_outlined,
//                                       color: fabricColor,
//                                     ),
//                                     const SizedBox(width: 12),
//                                     Text(
//                                       "[Open Today]",
//                                       style: AppTextStyle
//                                           .getTextStyle12FontWeightw300Black,
//                                     ),
//                                   ],
//                                 ),
//                                 // const SizedBox(width: 22),
//                                 // Row(
//                                 //   children: [
//                                 //     const Icon(
//                                 //       Icons.add_moderator,
//                                 //       size: 20,
//                                 //       color: fabricColor,
//                                 //     ),
//                                 //     const SizedBox(width: 10),
//                                 //     Text(
//                                 //       "58%",
//                                 //       style: AppTextStyle.getTextStyle14FontWeightw600FabricColor,
//                                 //     ),
//                                 //   ],
//                                 // ),
//                               ],
//                             ),
//                             const SizedBox(height: 10),
//                             Row(
//                               children: [
//                                 Row(
//                                   children: [
//                                     const Icon(
//                                       Icons.star,
//                                       color: Colors.yellow,
//                                     ),
//                                     const SizedBox(width: 12),
//                                     Text(
//                                       "${provider.averageRating} (${provider.totalRatings})",
//                                       style: AppTextStyle
//                                           .getTextStyle14FontWeightw500B,
//                                     ),
//                                   ],
//                                 ),
//                                 const SizedBox(width: 40),
//                                 Row(
//                                   children: [
//                                     const Icon(
//                                       Icons.remove_red_eye,
//                                       size: 20,
//                                       color: Colors.grey,
//                                     ),
//                                     const SizedBox(width: 10),
//                                     Text(
//                                       "${serviceProvider.viewCount} views",
//                                       style: AppTextStyle
//                                           .getTextStyle12FontWeightw300Black,
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: 10),
//                             Divider(
//                               color: Colors.grey[300],
//                             ),
//                             Text(
//                               "Opening Hours",
//                               style: AppTextStyle.getTextStyle18FontWeightBold,
//                             ),
//                             const SizedBox(height: 20),
//                             _viewModel.salonTiming.length > 0
//                                 ? timeRow(_viewModel.salonTiming[0])
//                                 : SizedBox(),
//                             // const SizedBox(height: 10),
//                             //  Container(
//                             //    margin: const EdgeInsets.only(right: 10, top: 10),
//                             //    child: CustomButtonWidget(
//                             //      text: "Add Panels",
//                             //      textColor: Colors.black,
//                             //      onPressed: () {
//                             //        Get.to(() => AdminPanelPage());
//                             //      },
//                             //      buttonColor: Colors.blue.shade50,
//                             //      borderRadius: 5,
//                             //      buttonHeight: 25,
//                             //      //buttonWidth: 100,
//                             //      borderColor: Colors.transparent,
//                             //      icon: Icons.add,
//                             //    ),
//                             //  ),
//                             //const SizedBox(height: 12),
//                             // Container(
//                             //   child: GestureDetector(
//                             //     onTap: () {Get.to(() => AdminPanelPage());},
//                             //     child: Row(
//                             //       mainAxisAlignment: MainAxisAlignment.end,
//                             //       children: [
//                             //         Icon(Icons.add,size: 25,color: Colors.teal,),
//                             //         SizedBox(width: 8),
//                             //         Text(
//                             //           "Add panels",
//                             //           style: AppTextStyle.getTextStyle16FontWeightw300Teal,
//                             //         ),
//                             //       ],
//                             //     ),
//                             //   ),
//                             // ),
//                             // const SizedBox(height: 8),
//                             // Container(
//                             //   child: Column(
//                             //     children: _viewModel.panels.map((panel) {
//                             //       return ExpansionTile(
//                             //         collapsedBackgroundColor: Colors.blue.shade50,
//                             //         enableFeedback: false,
//                             //         title: Text(
//                             //           "Panel ${panel.id} - ${panel.name ?? "Unnamed Panel"}",
//                             //           style: AppTextStyle.getTextStyle16FontWeightw600,
//                             //         ),
//                             //         trailing: Text(
//                             //           "Queue - ${panel.queueCount ?? 0}",
//                             //           style: AppTextStyle.getTextStyle14FontWeightw300B,
//                             //         ),
//                             //         children: _viewModel.services
//                             //             .where((service) => service.serviceProviderId == panel.serviceProviderId)
//                             //             .map((service) {
//                             //           final List<String> promoImages = (service.promoImage ?? '')
//                             //               .split(',')
//                             //               .map((s) => s.trim())
//                             //               .toList();
//                             //           final String salonServiceProviderImage = (promoImages.isNotEmpty && promoImages[0].isNotEmpty)
//                             //               ? '$BASE_URL/uploads/${promoImages[0]}'
//                             //               : dummyimage;
//                             //
//                             //           return CardWidget(
//                             //             title: service.name ?? "Unnamed Service",
//                             //             subtitle: "${service.price ?? 0}",
//                             //             imagePath: salonServiceProviderImage,
//                             //             serivceId: service.id!,
//                             //             panelId: panel.id!,
//                             //           );
//                             //         }).toList(),
//                             //       );
//                             //     }).toList(),
//                             //   ),
//                             // ),
//                             // const SizedBox(height: 25),
//                             // Row(
//                             //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             //   children: [
//                             //     Text(
//                             //       "Gallery",
//                             //       style: AppTextStyle.getTextStyle17FontWeightw600B,
//                             //     ),
//                             //   ],
//                             // ),
//                             // const SizedBox(height: 20),
//                             // Container(
//                             //   height: 110,
//                             //   //color: Colors.red,
//                             //   child: ListView.builder(
//                             //     itemCount: _viewModel.panels.length,
//                             //     itemBuilder: (context, index) {
//                             //       final panel = _viewModel.panels[index];
//                             //       return Column(
//                             //         crossAxisAlignment: CrossAxisAlignment.start,
//                             //         children: [
//                             //           // Check if the current panel is opened
//                             //           const SizedBox(height: 8),
//                             //           Container(
//                             //             height: 100,
//                             //             //color: Colors.red,
//                             //             child: ListView.builder(
//                             //               scrollDirection: Axis.horizontal,
//                             //               itemCount: _viewModel.services.length,
//                             //               itemBuilder: (context, serviceIndex) {
//                             //                 final service = _viewModel.services[serviceIndex];
//                             //                 final List<String> promoImages = (service.promoImage ?? '')
//                             //                     .split(',')
//                             //                     .map((s) => s.trim())
//                             //                     .toList();
//                             //                 // Use the first promo image if available; otherwise, use a dummy image
//                             //                 final String salonServiceProviderImage = (promoImages.isNotEmpty && promoImages[0].isNotEmpty)
//                             //                     ? '$BASE_URL/uploads/${promoImages[0]}'
//                             //                     : dummyimage;
//                             //                 print('services image : $BASE_URL/uploads/${promoImages[0]}');
//                             //                 // Check if the current service's provider ID matches the panel's provider ID
//                             //                 if (service.serviceProviderId == panel.serviceProviderId) {
//                             //                   return Padding(
//                             //                     padding: const EdgeInsets.only(right: 10), // Space between images
//                             //                     child: imageCard(salonServiceProviderImage), // Display the service image
//                             //                   );
//                             //                 }
//                             //                 return SizedBox.shrink(); // Return empty box if no match
//                             //               },
//                             //             ),
//                             //           ),
//                             //         ],
//                             //       );
//                             //     },
//                             //   ),
//                             // ),
//                           ],
//                         ),
//                       ),
//                       Container(
//                         child: BeautifulListView(),
//                       ),
//                       const SizedBox(height: 20),
//                     ],
//                   ),
//                 ),
//           Visibility(
//               visible: _viewModel.isLoading,
//               child: const Center(child: CircularProgressIndicator()))
//         ],
//       ),
//     );
//   }
//
//   Widget imageCard(String imagePath) {
//     return Container(
//         width: double.infinity,
//         height: 200,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: CachedNetworkImage(
//           fit: BoxFit.cover,
//           imageUrl: imagePath,
//           imageBuilder: (context, imageProvider) => Container(
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(15),
//               image: DecorationImage(
//                   image: imageProvider,
//                   fit: BoxFit.cover,
//                   colorFilter: const ColorFilter.mode(
//                       Colors.transparent, BlendMode.colorBurn)),
//             ),
//           ),
//           placeholder: (context, url) =>
//               const Center(child: CircularProgressIndicator()),
//           errorWidget: (context, url, error) => const Icon(Icons.error),
//         ));
//   }
//
//   Widget panelContainer(String title, String text) {
//     return Container(
//       padding: EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.blue.shade50,
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             title,
//             style: AppTextStyle.getTextStyle16FontWeightw600,
//           ),
//           Text(
//             text,
//             style: AppTextStyle.getTextStyle14FontWeightw300B,
//           ),
//         ],
//       ),
//     );
//   }
//
//   timeRow(SalonTiming salonTimings) {
//     print(
//         "${formatTime(salonTimings.startTime!)} - ${formatTime(salonTimings.endTime!)}");
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 "Today",
//                 style: AppTextStyle.getTextStyle15FontWeightw400G,
//               ),
//               Text(
//                 "${formatTime(salonTimings.startTime!)} - ${formatTime(salonTimings.endTime!)}",
//                 style: AppTextStyle.getTextStyle14FontWeightw500B,
//               ),
//             ],
//           ),
//         ),
//         salonTimings.lunchStart != null && salonTimings.lunchEnd != null
//             ? Container(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "Lunch Time",
//                       style: AppTextStyle.getTextStyle15FontWeightw400G,
//                     ),
//                     Text(
//                       "${formatTime(salonTimings.lunchStart!)} - ${formatTime(salonTimings.lunchEnd!)}",
//                       style: AppTextStyle.getTextStyle14FontWeightw500B,
//                     ),
//                   ],
//                 ),
//               )
//             : SizedBox(),
//       ],
//     );
//   }
//
//   // topImage(BuildContext context) {
//   //   return Stack(
//   //     children: [
//   //       CachedNetworkImage(
//   //         height: 250,
//   //         fit: BoxFit.cover,
//   //         imageUrl: widget.imagePath,
//   //         imageBuilder: (context, imageProvider) => Container(
//   //           decoration: BoxDecoration(
//   //             image: DecorationImage(
//   //                 image: imageProvider,
//   //                 fit: BoxFit.cover,
//   //                 colorFilter:
//   //                 const ColorFilter.mode(Colors.transparent, BlendMode.colorBurn)),
//   //           ),
//   //         ),
//   //         placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
//   //         errorWidget: (context, url, error) => const Icon(Icons.error),
//   //       ),
//   //       Positioned(
//   //         left: 16,
//   //         top: 100,
//   //         child: Container(
//   //           height: 60,
//   //           width: 60,
//   //           decoration: const BoxDecoration(
//   //               color: Colors.white38,
//   //               shape: BoxShape.circle
//   //           ),
//   //           child: IconButton(
//   //             icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black,size: 30,),
//   //             onPressed: () {
//   //               // if(_viewModel.selectedServices.length > 0 ) {
//   //               //   CustomSnackBar.showSnackBar("All the selected services will be removed");
//   //               //   _viewModel.selectedServices.clear();
//   //               // }
//   //               Get.back();
//   //               //Navigator.pop(context); // Navigate back when pressed
//   //             },
//   //           ),
//   //         ),
//   //       ),
//   //       Positioned(
//   //         right: 16,
//   //         top: 100,
//   //         child: Row(
//   //           children: [
//   //             Container(
//   //               height: 60,
//   //               width: 60,
//   //               decoration: const BoxDecoration(
//   //                   color: Colors.white38,
//   //                   shape: BoxShape.circle
//   //               ),
//   //               child: IconButton(
//   //                 icon: const Icon(Icons.favorite_border, color: Colors.red,size: 30,),
//   //                 onPressed: () {
//   //                   // Handle favorite action
//   //                 },
//   //               ),
//   //             ),
//   //             const SizedBox(width: 12),
//   //             Container(
//   //               height: 60,
//   //               width: 60,
//   //               decoration: const BoxDecoration(
//   //                   color: Colors.white38,
//   //                   shape: BoxShape.circle
//   //               ),
//   //               child: IconButton(
//   //                 icon: const Icon(Icons.navigation_sharp, color: fabricColor,size: 35,),
//   //                 onPressed: () {
//   //                   // Handle share action
//   //                 },
//   //               ),
//   //             ),
//   //           ],
//   //         ),
//   //       ),
//   //     ],
//   //   );
//   // }
//
//   String formatTime(String time) {
//     String formattedTime = "";
//     try {
//       final DateTime parsedTime = DateFormat("HH:mm").parse(time);
//       formattedTime = DateFormat("h:mm a").format(parsedTime);
//     } catch (e) {}
//     return formattedTime;
//   }
// }
//
// // ... existing imports
//
// class CardWidget extends StatefulWidget {
//   final String title;
//   final String subtitle;
//   final String imagePath;
//   final int serivceId;
//   final int panelId;
//
//   // final Function onServiceAdded;
//   // final Function onServiceRemoved; // Add this line
//
//   const CardWidget({
//     Key? key,
//     required this.title,
//     required this.subtitle,
//     required this.imagePath,
//     required this.serivceId,
//     // required this.onServiceAdded,
//     // required this.onServiceRemoved,
//     required this.panelId,
//   }) : super(key: key);
//
//   @override
//   _CardWidgetState createState() => _CardWidgetState();
// }
//
// class _CardWidgetState extends State<CardWidget> {
//   bool _isAdded = false; // Tracks if the service is added
//
//   // void _toggleService() {
//   //   setState(() {
//   //     _isAdded = !_isAdded; // Toggle the added state
//   //
//   //     if (_isAdded) {
//   //       widget.onServiceAdded(widget.title, widget.subtitle, widget.imagePath,widget.serivceId, widget.panelId);
//   //     } else {
//   //       widget.onServiceRemoved(widget.serivceId, widget.panelId);
//   //     }
//   //   });
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 4,
//       color: Colors.white,
//       child: SizedBox(
//         height: 100,
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             // Image on the left side
//             Container(
//               width: 70,
//               height: double.infinity,
//               decoration: const BoxDecoration(
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(8),
//                   bottomLeft: Radius.circular(8),
//                 ),
//               ),
//               child: CachedNetworkImage(
//                 imageUrl: widget.imagePath,
//                 imageBuilder: (context, imageProvider) => Container(
//                   decoration: BoxDecoration(
//                     borderRadius: const BorderRadius.only(
//                       topLeft: Radius.circular(8),
//                       bottomLeft: Radius.circular(8),
//                     ),
//                     image: DecorationImage(
//                         image: imageProvider,
//                         fit: BoxFit.cover,
//                         colorFilter: const ColorFilter.mode(
//                             Colors.transparent, BlendMode.colorBurn)),
//                   ),
//                 ),
//                 placeholder: (context, url) =>
//                     const Center(child: CircularProgressIndicator()),
//                 errorWidget: (context, url, error) => const Icon(Icons.error),
//               ),
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     widget.title,
//                     style: AppTextStyle.getTextStyle16FontWeightw600,
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     widget.subtitle,
//                     style: AppTextStyle.getTextStyle15FontWeightw600FabricColor,
//                   ),
//                 ],
//               ),
//             ),
//             // Padding(
//             //   padding: const EdgeInsets.only(right: 15),
//             //   child: GestureDetector(
//             //     onTap: _toggleService,
//             //     child: _isAdded ?
//             //     const Icon(Icons.remove_circle_outline,color: Colors.red,size: 35,) :
//             //     Container(
//             //       height: 40,
//             //       width: 40,
//             //       decoration: const BoxDecoration(
//             //         shape: BoxShape.circle,
//             //         color: fabricColor,
//             //       ),
//             //       child: const Center(
//             //         child: Icon(Icons.add,size: 20,color: Colors.white,),
//             //       ),
//             //     ),
//             //   ),
//             // ),
//           ],
//         ),
//       ),
//     );
//   }
// }
