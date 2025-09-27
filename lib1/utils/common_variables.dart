import 'package:shared_preferences/shared_preferences.dart';

import '../models/count.dart';

int serviceProviderId = -1;

String userName = '';

String userEmail = '';

DateTime? userBirthday;

int? userGender;

String? userPhoneNumber;

int? get userId => prefs.getInt("userId");
bool get isPhoneAuth => prefs.getBool("isPhoneAuth") ?? false;

// int? userId = prefs.getInt("userId");
// int? userId = -1;

int? panelId = -1;

String mobileNumber = '';

String panelName = '';

String userProfileImage = '';

String salonName = '';

String location = '';

int? subCategoryId = -1;

late SharedPreferences prefs;