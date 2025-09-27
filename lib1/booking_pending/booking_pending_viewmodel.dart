import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:wellwait_app/utils/util.dart';

import '../email_login/email_login_viewmodel.dart';
import '../models/booking.dart';
import '../models/service_provider_model.dart';
import '../services/services.dart';
import '../utils/common_variables.dart';

class BookingPendingViewModel extends ChangeNotifier {
  List<Booking> bookings = [];
  bool isLoading = false;
  String? errorMessage;
  final ApiService apiService = ApiService();
  List<ServicesProvider> serviceProvider = [];

  int selectedIndex = 0;

  setLoading(bool loading) {
    isLoading = loading;
    notifyListeners();
  }

  Future<void> fetchData() async {
    isLoading = true;
    notifyListeners();
    try {
      bookings = await apiService.bookingPending(userId!);
      errorMessage = null;
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchSalonServiceProvidersById(int id) async {
    isLoading = true;
    notifyListeners();
    try {
      serviceProvider = await apiService.fetchSalonServiceProviderById(id);
      print('service_provider: ${serviceProvider}');
    } catch (e) {
      print("Error fetching salon service providers: $e");
    }
    isLoading = false;
    notifyListeners();
  }

  makePayment(int? bookingId) async {
    if(bookingId == null) return;
    setLoading(true);
    try {
      final orderResponse = await apiService.createOrder(bookingId);
      if (orderResponse == null) {
        Util.getSnackBar("Unable to make payment.");
        setLoading(false);
        return;
      }

      Razorpay razorpay = Razorpay();
      var options = {
        'key': 'rzp_test_1dVq7DqYDx7JCe',
        'amount': orderResponse['amount'],
        'order_id': orderResponse['id'],
        'name': 'Wellwait',
        'description': 'Payment for salon booking',
        'external': {
          'wallets': ['paytm']
        }
      };
      razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
      razorpay.on(
          Razorpay.EVENT_PAYMENT_SUCCESS,
          (PaymentSuccessResponse response) =>
              handlePaymentSuccessResponse(response, bookingId));
      razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWalletSelected);
      razorpay.open(options);
    } catch (e) {
      setLoading(false);
    }
  }

  void handlePaymentErrorResponse(PaymentFailureResponse response) {
    Util.getSnackBar(
        "Payment Failed- Code: ${response.code}\nDescription: ${response.message}\nMetadata:${response.error.toString()}");
    setLoading(false);
  }

  Future<void> handlePaymentSuccessResponse(
      PaymentSuccessResponse response, int bookingId) async {
    bool status = await apiService.confirmPayment(
      bookingId,
      response.orderId,
      response.paymentId,
      response.signature,
      response.data,
    );
    if (status) {
      Util.getSnackBar("Payment Completed Successfully", success: true);
      await fetchData();
    }
    setLoading(false);
  }

  void handleExternalWalletSelected(ExternalWalletResponse response) {
    Util.getSnackBar("External Wallet Selected");
    setLoading(false);
  }

  void refreshUI() {
    notifyListeners();
  }
}
