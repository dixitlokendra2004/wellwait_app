import 'package:shared_preferences/shared_preferences.dart';

import 'common_variables.dart';

class SharedPreferenceService {
  static const String _emailKey = 'email';
  static const String _passwordKey = 'password';
  static const String _phoneNumberKey = 'phone_number';
  static const String _emailAdminKey = 'email';
  static const String _passwordAdminKey = 'password';
  static const String _onBoardingConpleteKey = 'onboarding_complete';
  static const String _serviceProviderIdKey = 'serviceProviderIdSP';
  static const String _userIdKey = 'userId';
  static const String _usernameKey = 'userName';
  static const String _userPhoneNumberKey = 'phone_number';
  static const String _userEmailKey = 'email';
  static const String _userBirthDateKey = 'birthday';
  static const String _userGenderKey = 'gender';
  static const String _userProfileImageKey = 'photo';
  static const String _adminMobileNumberKey = 'mobile_number';
  static const String _userLocationKey = 'location';

  Future<Map<String, String?>> getCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString(_emailKey);
    String? password = prefs.getString(_passwordKey);
    return {'email': email, 'password': password};
  }

  Future<void> clearCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clears all preferences
  }

  // Save email and password
  Future<void> saveCredentials(String email, String password) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_emailKey, email);
    await prefs.setString(_passwordKey, password);
  }

  Future<void> savePhoneCredentials(String phoneNumber) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_phoneNumberKey, phoneNumber);
  }

  Future<void> saveAdminPhoneCredentials(String phoneNumber, int status) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_adminMobileNumberKey, phoneNumber);
    await prefs.setInt(_onBoardingConpleteKey, status);
  }

  Future<String?> getAdminPhoneCredentials() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_adminMobileNumberKey);
  }

  Future<void> saveAdminCredentials(
      String email, String password, int status) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_emailAdminKey, email);
    await prefs.setString(_passwordAdminKey, password);
    await prefs.setInt(_onBoardingConpleteKey, status);
  }

  Future<void> saveUsername(String username) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_usernameKey, username); // Save username
  }

  // Get saved username
  Future<String?> getUsername() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_usernameKey); // Retrieve username
  }

  Future<void> saveUserEmail(String userEmail) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userEmailKey, userEmail); // Save username
  }

  Future<String?> getUserEmail() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userEmailKey); // Retrieve username
  }

  Future<void> saveUserBirthday(String birthDate) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userBirthDateKey, birthDate);
  }

  Future<String?> getUserBirthday() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userBirthDateKey); // Retrieve username
  }

  Future<void> saveUserPhoneNumber(String userPhoneNumber) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        _userPhoneNumberKey, userPhoneNumber); // Save username
  }

  Future<String?> getUserPhoneNumber() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userPhoneNumberKey);
  }

  // Get saved email
  Future<String?> getEmail() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_emailKey);
  }

  Future<int?> getStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_onBoardingConpleteKey) ?? 0;
  }

  // Get saved password
  Future<String?> getPassword() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_passwordKey);
  }

  Future<void> saveOriginalId(int? originalId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (originalId != null)
      await prefs.setInt(_serviceProviderIdKey, originalId);
  }

  // Get originalId
  Future<int?> getOriginalId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_serviceProviderIdKey);
  }

  Future<void> saveUserGender(int? gender) async {
    if (gender != null) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_userGenderKey, gender);
    }
  }

  Future<int?> getUserGender() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final gender = prefs.get(_userGenderKey);
    if (gender is String) {
      // Convert string to int if it's a string
      return int.tryParse(gender);
    } else if (gender is int) {
      // Return the value if it's already an int
      return gender;
    }

    return null; // Return null if no valid gender is found
  }

  Future<void> saveUserId(int userId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_userIdKey, userId);
  }

  Future<void> saveUserLoginType(isPhoneAuth) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isPhoneAuth", isPhoneAuth == 1);
  }

  // Get userId
  Future<int?> getUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_userIdKey);
  }

  Future<void> saveUserInfo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_usernameKey, userName);
    await prefs.setString(_userPhoneNumberKey, userPhoneNumber!);
    await prefs.setString(
        _userBirthDateKey, userBirthday?.toIso8601String() ?? '');
    await prefs.setInt(_userGenderKey, userGender!);
    await prefs.setString(_userEmailKey, userEmail);
    await prefs.setString(_userProfileImageKey, userProfileImage.toString());
  }

  Future<void> saveUserProfileImage(String userProfileImage) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userProfileImageKey, userProfileImage);
  }

  Future<String?> getUserProfileImage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userProfileImageKey);
  }

  Future<void> saveUserLocation(String location) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userLocationKey, location); // Save username
  }

  Future<String?> getUserLocation() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userLocationKey); // Retrieve username
  }

  Future<void> saveGmailCredentials(String email) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_emailKey, email);
  }

  Future<void> saveAdminEmailCredentials(String email, int status) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_adminMobileNumberKey, email);
    await prefs.setInt(_onBoardingConpleteKey, status);
  }
}
