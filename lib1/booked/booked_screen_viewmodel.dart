import 'dart:io';

import 'package:flutter/cupertino.dart';

import '../models/booking.dart';
import '../services/services.dart';

class BookedScreenViewModel extends ChangeNotifier {




  refreshUI() {
    notifyListeners();
  }

}
