import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:wellwait_app/admin/Transactions/transactions_viewmodel.dart';
import 'package:wellwait_app/admin/utils/admin_%20common_variable.dart';
import 'package:wellwait_app/utils/colors.dart';
import '../../models/booking.dart';
import '../admin_phone_number_login/admin_auth_viewmodel.dart';
import '../utils/date_picker.dart';
import '../widget/app_bar.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  late TransactionsViewModel _viewModel;
  late AdminAuthViewModel _authViewModel;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _viewModel.fetchTransactions(_authViewModel.serviceProvider.id ?? 0);
      print("serviceProviderId: ${adminServiceProviderId}");
    });
  }

  @override
  Widget build(BuildContext context) {
    _viewModel = context.watch<TransactionsViewModel>();
    _authViewModel = context.watch<AdminAuthViewModel>();
    return Scaffold(
      backgroundColor: const Color(0xffECECEC),
      appBar: CustomAppBar(showHomeButton: false),
      body: Column(
        children: [
          Text(
            _authViewModel.serviceProvider.salonName.toString(),
            style: TextStyle(fontSize: 12, color: Colors.grey,fontWeight: FontWeight.w600),
          ),
          Text(
            "Transactions",
            style: TextStyle(
                fontSize: 22,
                color: AppColors.primaryColor,
                fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 20),

          // Segmented Control
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildSegment("Paid", Color(0xff40A758),0),
                  _buildSegment("Pending", Color(0xffA89C30),1),
                  _buildSegment("Failed", Color(0xffBF2424),2),
                ],
              ),
            ),
          ),
          SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center, // Align items properly
              children: [
                Flexible( // Prevents overflow
                  child: DatePicker(
                    selectedDate: _viewModel.selectedStartDate,
                    onDateSelected: (date) {
                      setState(() {
                        _viewModel.selectedStartDate = date;
                      });
                      _viewModel.fetchTransactions(_authViewModel.serviceProvider.id ?? 0);
                    },
                  ),
                ),
                SizedBox(width: 8),
                SvgPicture.asset("assets/icons/to_icon.svg", height: 15, width: 15),
                SizedBox(width: 8),
                Flexible( // Prevents overflow
                  child: DatePicker(
                    selectedDate: _viewModel.selectedEndDate,
                    onDateSelected: (date) {
                      setState(() {
                        _viewModel.selectedEndDate = date;
                      });
                      _viewModel.fetchTransactions(_authViewModel.serviceProvider.id ?? 0);
                    },
                  ),
                ),
              ],
            ),
          ),

          // Content Based on Selected Index
          Expanded(child: getPage(_viewModel.selectedIndex)),
        ],
      ),
    );
  }

  Widget _buildSegment(String text, Color dotColor, int index) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _viewModel.selectedIndex = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: _viewModel.selectedIndex == index ? AppColors.primaryColor : Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(index == 2 ? 0 : 24),
              bottomLeft: Radius.circular(index == 2 ? 0 : 24),
              topRight: Radius.circular(index == 0 ? 0 : 24),
              bottomRight: Radius.circular(index == 0 ? 0 : 24),
            ),
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                text,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: _viewModel.selectedIndex == index ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(width: 6), // Space between text and dot
              Container(
                width: 8, // Dot size
                height: 8, // Dot size
                decoration: BoxDecoration(
                  color: dotColor,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getPage(int index) {
    switch (index) {
      case 0:
        return transactionList();
      case 1:
        return transactionList();
      case 2:
        return transactionList();
      default:
        return const Center(child: Text("Unknown Page", style: TextStyle(fontSize: 18)));
    }
  }

  Widget transactionList() {
    List<Booking> filteredBookings = [];
    if (_viewModel.selectedIndex == 0) {
      filteredBookings = _viewModel.paymentBooking.where((b) => b.paymentComplete == 1).toList();
    } else if (_viewModel.selectedIndex == 1) {
      filteredBookings = _viewModel.paymentBooking.where((b) => b.paymentComplete == 0).toList();
    } else if (_viewModel.selectedIndex == 2) {
      filteredBookings = _viewModel.paymentBooking.where((b) => b.paymentComplete == 2).toList();
    } else {
      filteredBookings = [];
    }
    return _viewModel.isLoading
        ? const Center(child: CircularProgressIndicator())
        : filteredBookings.isEmpty
        ? const Center(child: Text("No transactions available", style: TextStyle(fontSize: 18,fontWeight: FontWeight.w400)))
        : Padding(
      padding: const EdgeInsets.only(left: 22, right: 22, top: 20, bottom: 15),
      child: ListView.builder(
        itemCount: filteredBookings.length,
        itemBuilder: (context, index) {
          return transactionItem(filteredBookings[index]);
        },
      ),
    );
  }

  Widget transactionItem(Booking paymentBooking) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 5),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                paymentBooking.username.toString(),
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600,color: Colors.black),
              ),
              Text(
                paymentBooking.scheduledDate != null
                    ? DateFormat('dd/MM/yy').format(paymentBooking.scheduledDate!)
                    : "N/A",
                style: const TextStyle(color: Colors.grey, fontSize: 12,fontWeight: FontWeight.w600),
              ),
              Text(
                "₹ ${paymentBooking.price ?? 0}",
                style: TextStyle(
                  color: (_viewModel.selectedIndex != 0) ? Colors.red : Color(0xff40A758),
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
