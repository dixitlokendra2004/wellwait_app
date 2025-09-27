import 'package:wellwait_app/utils/common_variables.dart';

int get adminServiceProviderId => prefs.getInt("serviceProviderIdSP") ?? -1;
// int adminServiceProviderId = -1;

String providerLocation = '';

String adminSalonName = '';