import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:wellwait_app/admin/registration/salonRegistrationViewModel.dart';
import 'package:wellwait_app/past_booking/past_booking_viewmodel.dart';
import 'package:wellwait_app/phone_number_login/phone_number_login_viewmodel.dart';
import 'package:wellwait_app/queue/queue_viewmodel.dart';
import 'package:wellwait_app/rating/rating_page_viewmodel.dart';
import 'package:wellwait_app/schedule/schedule_viewmodel.dart';
import 'package:wellwait_app/service_detail/service_detail_viewmodel.dart';
import 'package:wellwait_app/service_provider_details/sp_detail_viewmodel.dart';
import 'package:wellwait_app/settings/settings_viewmodel.dart';
import 'Screens/Filter/filter_viewmodel.dart';
import 'Screens/Splash/splash_screen.dart';
import 'Screens/booking2/booking_screen2_viewmodel.dart';
import 'Screens/notification/notification_viewmodel.dart';
import 'Screens/registration/registration_viewmodel.dart';
import 'Screens/search_screen/search_viewmodel.dart';
import 'admin/Transactions/transactions_viewmodel.dart';
import 'admin/add_customer/add_customer_viewmodel.dart';
import 'admin/admin_email_login/admin_email_login_viewmodel.dart';
import 'admin/admin_login/admin_login_viewmodel.dart';
import 'admin/admin_notification/admin_notification_viewmodel.dart';
import 'admin/admin_otp_verification/otp_verification_viewmodel.dart';
import 'admin/admin_panel/admin_panel_viewmodel.dart';
import 'admin/admin_panel/panel_viewmodel.dart';
import 'admin/admin_phone_number_login/admin_auth_viewmodel.dart';
import 'admin/admin_profile/admin_profile_viewmodel.dart';
import 'admin/admin_queue/admin_queue_viewmodel.dart';
import 'admin/admin_queue/detail_panel/detail_panel_viewmodel.dart';
import 'admin/admin_register/admin_register_viewmodel.dart';
import 'admin/salon_detail/solon_detail_viewmodel.dart';
import 'admin/salon_documents/salon_documents_viewmodel.dart';
import 'admin/salon_information/salon_information_viewmodel.dart';
import 'admin/salon_service/salon_service_viewmodel.dart';
import 'admin/service_provider_panels/service_provider_panels_viewmodels.dart';
import 'admin/service_provider_timing/service_provider_timing_viewmodel.dart';
import 'admin/setting/setting_viewmodel.dart';
import 'admin/total_panel_payment/total_panel_payment_viewmodel.dart';
import 'admin/widget/bottom_bar/bottom_bar_viewmodel.dart';
import 'booked/booked_screen_viewmodel.dart';
import 'booking_pending/booking_pending_viewmodel.dart';
import 'edit_profile/edit_profile_viewmodel.dart';
import 'email_login/email_login_viewmodel.dart';
import 'filter_salon_provider/filter_salon_provider_viewmodel.dart';
import 'home_screen/home_screen_viewmodel.dart';
import 'otp_verification/otp_verification_viewmodel.dart';

class ConfigScreen extends StatefulWidget {
  @override
  _ConfigScreenState createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> {

  @override
  initState() {
    FirebaseMessaging.instance.requestPermission();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RegistrationViewModel()),
        ChangeNotifierProvider(create: (_) => HomeScreenViewModel()),
        ChangeNotifierProvider(create: (_) => ScheduleViewModel()),
        ChangeNotifierProvider(create: (_) => EditProfileViewModel()),
        ChangeNotifierProvider(create: (_) => BookedScreenViewModel()),
        ChangeNotifierProvider(create: (_) => RatingViewModel()),
        ChangeNotifierProvider(create: (_) => EmailLoginViewModel()),
        ChangeNotifierProvider(create: (_) => SPDetailViewModel()),
        ChangeNotifierProvider(create: (_) => NotificationViewModel()),
        ChangeNotifierProvider(create: (_) => SettingsViewModel()),
        ChangeNotifierProvider(create: (_) => QueueViewModel()),
        ChangeNotifierProvider(create: (_) => AdminLoginViewModel()),
        ChangeNotifierProvider(create: (_) => SolonDetailViewModel()),
        ChangeNotifierProvider(create: (_) => SalonInformationViewModel()),
        ChangeNotifierProvider(create: (_) => SalonServiceViewModel()),
        ChangeNotifierProvider(create: (_) => SalonDocumentsViewModel()),
        ChangeNotifierProvider(create: (_) => AdminEmailLoginViewModel()),
        ChangeNotifierProvider(create: (_) => AdminRegisterViewModel()),
        ChangeNotifierProvider(create: (_) => BookingScreen2ViewModel()),
        ChangeNotifierProvider(create: (_) => AdminQueueViewModel()),
        ChangeNotifierProvider(create: (_) => BookingPendingViewModel()),
        ChangeNotifierProvider(create: (_) => PastBookingVieModel()),
        ChangeNotifierProvider(create: (_) => AdminPanelViewModel()),
        // ChangeNotifierProvider(create: (_) => DashboardViewModel()),
        ChangeNotifierProvider(create: (_) => ServiceProviderPanelsViewModels()),
        ChangeNotifierProvider(create: (_) => ServiceProviderTimingViewModels()),
        // ChangeNotifierProvider(create: (_) => ServiceProviderDetailsViewModel()),
        // ChangeNotifierProvider(create: (_) => ServiceProviderDocumentsViewModel()),
        ChangeNotifierProvider(create: (_) => OtpVerificationViewModel()),
        // ChangeNotifierProvider(create: (_) => ServiceProviderDocumentsViewModel()),
        ChangeNotifierProvider(create: (_) => PhoneNumberLoginViewModel()),
        ChangeNotifierProvider(create: (_) => SearchViewModel()),
        ChangeNotifierProvider(create: (_) => AdminAuthViewModel()),
        ChangeNotifierProvider(create: (_) => AdminOtpVerificationViewModel()),
        ChangeNotifierProvider(create: (_) => FilterViewModel()),
        ChangeNotifierProvider(create: (_) => FilterSalonProviderViewModel()),
        ChangeNotifierProvider(create: (_) => ServiceDetailViewModel()),
        ChangeNotifierProvider(create: (_) => SolonRegistrationViewModel()),
        ChangeNotifierProvider(create: (_) => AddPanelViewModel()),
        ChangeNotifierProvider(create: (_) => AddCustomerViewModel()),
        ChangeNotifierProvider(create: (_) => BottomBarViewModel()),
        ChangeNotifierProvider(create: (_) => AdminSettingsViewModel()),
        ChangeNotifierProvider(create: (_) => DetailPanelViewModel()),
        ChangeNotifierProvider(create: (_) => TransactionsViewModel()),
        ChangeNotifierProvider(create: (_) => AnalysisViewModel()),
        ChangeNotifierProvider(create: (_) => AdminNotificationViewModel()),
        ChangeNotifierProvider(create: (_) => AdminProfileViewModel()),
      ],
      child: GetMaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.light,
        //home: PhoneNumberLoginPage(),
        home: SplashScreen(),
        theme: ThemeData(
          fontFamily: 'Manrope',
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          scaffoldBackgroundColor: Colors.white,
            // Add more text styles as needed
        ),
      ),
    );
  }
}


// to start mysql
// sudo /usr/local/mysql/support-files/mysql.server start
// sudo /usr/local/mysql/support-files/mysql.server stop
// sudo /usr/local/mysql/support-files/mysql.server restart

// https://drive.google.com/file/d/1Z638BABqFG2WIJj0ipYLwSnQMYXWtSVx/view?usp=drive_link
// https://drive.google.com/file/d/1Z638BABqFG2WIJj0ipYLwSnQMYXWtSVx/view?usp=sharing