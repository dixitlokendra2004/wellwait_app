import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CustomSnackBar  {

  static showSnackBar(String message) {
    return  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}