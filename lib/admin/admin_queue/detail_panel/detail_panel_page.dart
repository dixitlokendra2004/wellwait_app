import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import '../../../common_widgets/custom_button.dart';
import '../../../models/booking.dart';
import '../../../utils/colors.dart';
import '../../../widget/custom_button.dart';
import '../../../widget/snack_bar_widget.dart';
import '../../add_customer/add_customer_page.dart';
import '../../widget/app_bar.dart';
import 'detail_panel_viewmodel.dart';

class DetailPanelPage extends StatefulWidget {
  final String? panelName;
  final int? panelId;
  final String? salonName;

  const DetailPanelPage({
    super.key,
    this.panelName,
    this.panelId,
    this.salonName,
  });

  @override
  State<DetailPanelPage> createState() => _DetailPanelPageState();
}

class _DetailPanelPageState extends State<DetailPanelPage> {
  late DetailPanelViewModel _viewModel;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _viewModel = Provider.of<DetailPanelViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _viewModel.init(widget.panelId);
      _startTimer();
      // await _viewModel.fetchCustomer();
      setState(() {});
      print("panelId: ${widget.panelId}");
    });
  }
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    _viewModel = context.watch<DetailPanelViewModel>();
    return Scaffold(
      backgroundColor: const Color(0xffECECEC),
      appBar: CustomAppBar(showHomeButton: false),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                  child: Column(
                    children: [
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () { Get.back(); },
                              child: SvgPicture.asset(
                                "assets/icons/back_icon.svg",
                                height: 25,
                                width: 25,
                              ),
                            ),
                            Column(
                              children: [
                                Text(
                                  widget.salonName.toString(),
                                  style: const TextStyle(fontSize: 12, color: Colors.grey,fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  widget.panelName ?? "Unknown Panel",
                                  style: TextStyle(
                                      fontSize: 22,
                                      color: AppColors.primaryColor,
                                      fontWeight: FontWeight.w800),
                                ),
                              ],
                            ),
                            SvgPicture.asset("assets/icons/error.svg"),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      (_viewModel.panelBooking.isEmpty && _viewModel.panelBooking.isEmpty)
                      ? Center(child: Text("No booking available",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w400),))
                      : Container(
                        child: Column(
                          children: [
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: _viewModel.panelBooking.length,
                              itemBuilder: (context, index) {
                                final pendingBooking = _viewModel.panelBooking[index];
                                if (pendingBooking.finished == 1 && pendingBooking.paymentComplete == 0) {
                                  return pendingCard(pendingBooking.username.toString(),index + 1);
                                } else {
                                  return SizedBox.shrink();
                                }
                              },
                            ),
                            //SizedBox(height: 10),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              //padding: const EdgeInsets.only(left: 20, right: 20, bottom: 12),
                              itemCount: _viewModel.panelBooking.length,
                              itemBuilder: (context, index) {
                                final booking = _viewModel.panelBooking[index];
                                if (booking.finished == 1) {
                                  return SizedBox.shrink();
                                }
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Card(
                                    elevation: 4,
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(22),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(22),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    "#${index + 1}",
                                                    style: const TextStyle(
                                                      fontSize: 19,
                                                      fontWeight: FontWeight.w700,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 15),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        "customer",
                                                        style: TextStyle(color: AppColors.primaryColor,fontSize: 11,fontWeight: FontWeight.w400),
                                                      ),
                                                      Text(
                                                        booking.username.toString(),
                                                        style: const TextStyle(
                                                          fontWeight: FontWeight.w600,
                                                          fontSize: 18,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                booking.serviceName.toString(),
                                                style: TextStyle(color: AppColors.primaryColor,fontWeight: FontWeight.w500,fontSize: 13),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          //(booking.started == 1)
                                          // ? Container(
                                          //   width: 80,
                                          //   height: 25,
                                          //   decoration: BoxDecoration(
                                          //     color: Colors.white,
                                          //     borderRadius: BorderRadius.circular(16),
                                          //     border: Border.all(color: Colors.green),
                                          //   ),
                                          //   child: const Center(child: Text("Paid")),
                                          // ) : Container(),
                                          const SizedBox(height: 12),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              if (booking.finished == 1)
                                                Container(
                                                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                                  decoration: BoxDecoration(
                                                    color: Colors.green,
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  child: const Text(
                                                    "Completed",
                                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                                                  ),
                                                )
                                              else if (booking.started == 0)
                                                CustomButtonWidget(
                                                  text: "Start",
                                                  textColor: AppColors.startColor,
                                                  onPressed: () async {
                                                    await _viewModel.startedBooking(booking.id!);
                                                    await _viewModel.fetchBookings();
                                                    setState(() {});
                                                  },
                                                  buttonColor: Colors.white,
                                                  borderRadius: 8,
                                                  buttonHeight: 40,
                                                  buttonWidth: 110,
                                                  borderColor: Color(0xff7E7E7E4D),
                                                  borderWidth: 1,
                                                )
                                              else
                                                CustomButtonWidget(
                                                  text: "End",
                                                  textColor: Colors.white,
                                                  onPressed: () async {
                                                    await _viewModel.endBookings(booking.id!);
                                                    await _viewModel.fetchBookings();
                                                    // setState(() {
                                                    //   _viewModel.panelBooking.removeAt(index);
                                                    // });
                                                    if(booking.paymentComplete == 0) {
                                                      CustomSnackBar.showSnackBar("${booking.username} payment is pending!");
                                                    } else {
                                                      CustomSnackBar.showSnackBar("Completed!");
                                                    }
                                                  },
                                                  buttonColor: AppColors.closePanelColor,
                                                  borderRadius: 8,
                                                  buttonHeight: 40,
                                                  buttonWidth: 110,
                                                ),

                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  buildBookingDetails(booking),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible: _viewModel.isLoading,
            child: Center(
                child: Container(
                  height: 40,
                  width: 40,
                  color: Colors.transparent,
                  child: const CircularProgressIndicator(),
                )),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => AddCustomerPage(
            panelName: widget.panelName.toString(),
            panelId: widget.panelId!,
          ));
        },
        shape: const CircleBorder(),
        backgroundColor: AppColors.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),

    );
  }

  int _calculateElapsedTime(String? startedAt) {
    if (startedAt == null || startedAt.isEmpty) return 0;
    //
    // try {
    //   // Get current date
      DateTime currentDate = DateTime.now();
      String formattedStartTime = "${currentDate.year}-${currentDate.month.toString().padLeft(2, '0')}-${currentDate.day.toString().padLeft(2, '0')} $startedAt:00";
      DateTime startTime = DateTime.parse(formattedStartTime);
      DateTime currentTime = DateTime.now();
      int minutes = currentTime.difference(startTime).inMinutes;
      return minutes > 0 ? minutes : 0;
    // } catch (e) {
    //   debugPrint("Error parsing date: $startedAt - $e");
    //   return 0;
    // }
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 60), (timer) {
      setState(() {});
    });
  }


  Widget pendingCard(String user,int count) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Card(
        elevation: 4,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text("#${count}", style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700)),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text("customer", style: TextStyle(color: AppColors.primaryColor,fontWeight: FontWeight.w400,fontSize: 10)),
                      Text(
                        user,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Colors.black, // Default color
                        ),
                      ),
                      // RichText(
                      //   text: TextSpan(
                      //     text: user,  // Normal user text
                      //     style: const TextStyle(
                      //       fontWeight: FontWeight.w600,
                      //       fontSize: 18,
                      //       color: Colors.black, // Default color
                      //     ),
                      //     children: [
                      //       TextSpan(
                      //         text: " • $service",
                      //         style: const TextStyle(
                      //           color: Colors.teal,
                      //           fontSize: 10,
                      //           fontWeight: FontWeight.w300,
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: const Color(0xffA89C30),
                ),
                child: const Padding(
                  padding: EdgeInsets.only(left: 24,right: 24,top: 10,bottom: 10),
                  child: Center(
                    child: Text("Pending", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.white)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildBookingDetails(Booking booking) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: "Start time: ",
            style: TextStyle(
              color: Colors.black54,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            children: [
              TextSpan(
                text: booking.started == 1 ? booking.startedAt : "_",
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: Color(0xff737687),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        RichText(
          text: TextSpan(
            text: "Total time: ",
            style: TextStyle(
              color: Colors.black54,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            children: [
              TextSpan(
                text: "${_calculateElapsedTime(booking.startedAt)} mins",
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: Color(0xff737687),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }



// Widget servicesCard(
  //     int index,
  //     String customerName,
  //     String services,
  //     String startTime,
  //     String totalTime,
  //     String status,
  //     VoidCallback onTap,
  //     ) {
  //   return Card(
  //     elevation: 4,
  //     color: Colors.white,
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
  //     child: Padding(
  //       padding: const EdgeInsets.all(22),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               Row(
  //                 children: [
  //                   Text("#$index", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
  //                   const SizedBox(width: 15),
  //                   Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       const Text("Customer", style: TextStyle(color: AppColors.primaryColor)),
  //                       const SizedBox(height: 8),
  //                       Text(customerName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //               Text(services, style: const TextStyle(color: AppColors.primaryColor)),
  //             ],
  //           ),
  //           const SizedBox(height: 10),
  //           Container(
  //             width: 80,
  //             height: 25,
  //             decoration: BoxDecoration(
  //               color: Colors.white,
  //               borderRadius: BorderRadius.circular(16),
  //               border: Border.all(color: status == "Paid" ? Colors.green : Colors.orange),
  //             ),
  //             child: Center(
  //               child: Text(status, style: TextStyle(color: status == "Paid" ? Colors.green : Colors.orange)),
  //             ),
  //           ),
  //           const SizedBox(height: 12),
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               GestureDetector(
  //                 onTap: () {
  //                   onTap();
  //                 },
  //                 child: Container(
  //                   width: 100,
  //                   height: 40,
  //                   decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
  //                   child: const Center(
  //                     child: Text("End", style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white)),
  //                   ),
  //                 ),
  //               ),
  //               Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Text("Start time: $startTime", style: const TextStyle(color: Colors.grey, fontSize: 12)),
  //                   const SizedBox(height: 12),
  //                   Text("Total time: $totalTime", style: const TextStyle(color: Colors.grey, fontSize: 12)),
  //                 ],
  //               ),
  //             ],
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  //}
}


// class BookingCardWidget extends StatelessWidget {
//   final dynamic booking;
//   final Function(int) onStart;
//   final Function(int) onComplete;
//
//   const BookingCardWidget({
//     Key? key,
//     required this.booking,
//     required this.onStart,
//     required this.onComplete,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 4,
//       color: Colors.white,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(22),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(22),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Booking Details Row
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   children: [
//                     Text(
//                       "#${booking.index + 1}",
//                       style: const TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                     const SizedBox(width: 15),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Text(
//                           "Customer",
//                           style: TextStyle(color: AppColors.primaryColor),
//                         ),
//                         const SizedBox(height: 8),
//                         Text(
//                           booking.username.toString(),
//                           style: const TextStyle(
//                             fontWeight: FontWeight.w600,
//                             fontSize: 18,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//                 Text(
//                   booking.serviceName.toString(),
//                   style: const TextStyle(color: AppColors.primaryColor),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 10),
//             Container(
//               width: 80,
//               height: 25,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(16),
//                 border: Border.all(color: Colors.green),
//               ),
//               child: const Center(child: Text("Paid")),
//             ),
//             const SizedBox(height: 12),
//             // Buttons & Status Row
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 booking.status == 3
//                     ? const Text(
//                   'Completed',
//                   style: TextStyle(
//                     fontWeight: FontWeight.w300,
//                     fontSize: 18,
//                   ),
//                 )
//                     : Stack(
//                   children: [
//                     CustomButtonWidget(
//                       text: "Start",
//                       textColor: Colors.black,
//                       onPressed: () {
//                         if (booking.status != 2) {
//                           onStart(booking.id!);
//                         }
//                       },
//                       buttonColor: Colors.white,
//                       borderRadius: 8,
//                       buttonHeight: 40,
//                       buttonWidth: 100,
//                       borderColor: Colors.black,
//                       borderWidth: 1,
//                     ),
//                     Visibility(
//                       visible: booking.status == 2 || booking.status == 3,
//                       child: CustomButtonWidget(
//                         text: booking.status == 2 || booking.status == 3
//                             ? "Completed"
//                             : "End",
//                         textColor: Colors.white,
//                         onPressed: () async {
//                           if (booking.status == 2 || booking.status == 3) {
//                             CustomSnackBar.showSnackBar("Completed!");
//                           } else if (booking.status != 3) {
//                             onComplete(booking.id!);
//                           }
//                         },
//                         buttonColor: booking.status == 2 || booking.status == 3
//                             ? Colors.green
//                             : Colors.red,
//                         borderRadius: 8,
//                         buttonHeight: 40,
//                         buttonWidth: booking.status == 2 || booking.status == 3
//                             ? 120
//                             : 100,
//                       ),
//                     ),
//                   ],
//                 ),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "Start time: ${booking.status == 2 ? booking.startedAt : "_"}",
//                       style: const TextStyle(
//                         color: Colors.black54,
//                         fontSize: 12,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     const SizedBox(height: 12),
//                     Text(
//                       "Total time: ${booking.status == 2 ? booking.price : "_"}",
//                       style: const TextStyle(
//                         color: Colors.black54,
//                         fontSize: 12,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

