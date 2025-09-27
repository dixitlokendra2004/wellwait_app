import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Util {
  static getSnackBar(String text,
      {var icon,
        color,
        int duration = 3,
        int delayMilli = 0,
        bool success = false}) async {
    if (!Get.isSnackbarOpen) {
      await Future.delayed(Duration(milliseconds: delayMilli));
      Get.showSnackbar(
        GetSnackBar(
          maxWidth: 600,
          messageText: Row(
            children: [
              Container(
                  margin: EdgeInsets.only(right: 20),
                  child: Icon(
                      icon ??
                          (success
                              ? Icons.check_circle_outline
                              : Icons.info_outline),
                      color: Colors.white,
                      size: 25)),
              Expanded(
                child: Text(
                  text,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          borderRadius: 13,
          backgroundColor: color ??
              (success ? Colors.green : const Color.fromRGBO(238, 82, 95, 1)),
          duration: Duration(seconds: duration),
        ),
      );
    }
  }
}

printString(var v) {
  print(v);
}

printLog(var v) {
  log(v);
}
