

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../home_screen/home_screen_viewmodel.dart';
import '../widget/custom_button.dart';
import 'app_strings.dart';
import 'app_text_style.dart';
import 'colors.dart';
import 'constants.dart';

String formatAverageRating(double averageRating) {
  // Format averageRating to show only the first two digits
  String averageString = averageRating.toStringAsFixed(2); // Shows up to two decimal places
  if (averageString.length > 2 && averageString.contains('.')) {
    return averageString.substring(0, averageString.indexOf('.') + 2);
  }
  return averageString;
}


String getProfileImage(String? imageUrl) {
  final List<String> promoImages = (imageUrl ?? '').split(',').map((s) => s.trim()).toList();
  return (promoImages.isNotEmpty && promoImages[0].isNotEmpty)
      ? '$BASE_URL/uploads/${promoImages[0]}' : dummyimage;
}