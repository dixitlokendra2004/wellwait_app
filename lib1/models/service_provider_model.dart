import 'dart:convert';

import 'package:wellwait_app/models/salon_timing.dart';
import 'package:wellwait_app/models/services.dart';

class ServicesProvider {
  final int? id;
  final String? providerName;
  final String? salonName;
  final String? address;
  final String? mobileNumber;
  final String? email;
  final int? viewCount;
  final List<ServiceModel> services;
  final String? promoImages;
  double? averageRating; // Make this nullable
  int? totalRatings;     // Make this nullable
  final String? photo;
  final String? imageUrl;
  String? panCard;
  String? gstIn;
  String? bankAccountNumber;
  String? bankIfscCode;
  String? address2;
  String? city;
  String? state;
  String? country;
  String? pinCode;
  String? panCardImage;
  String? documentImage;
  List<SalonTiming> salonTimings;

  ServicesProvider({
    this.id,
    this.providerName,
    this.salonName,
    this.address,
    this.mobileNumber,
    this.email,
    this.viewCount,
    this.services = const [],
    this.promoImages,
    this.averageRating,
    this.totalRatings,
    this.photo,
    this.imageUrl,
    this.panCard,
    this.gstIn,
    this.bankAccountNumber,
    this.bankIfscCode,
    this.address2,
    this.city,
    this.state,
    this.country,
    this.pinCode,
    this.panCardImage,
    this.documentImage,
    this.salonTimings = const [],
  });

  ServicesProvider copyWith({
    int? id,
    String? providerName,
    String? salonName,
    String? address,
    String? mobileNumber,
    String? email,
    int? viewCount,
    required List<ServiceModel> services,
    String? promoImages,
    double? averageRating,
    int? totalRatings,
    String? photo,
    String? imageUrl,
    String? panCard,
    String? gstIn,
    String? bankAccountNumber,
    String? bankIfscCode,
    String? address2,
    String? city,
    String? state,
    String? country,
    String? pinCode,
    String? panCardImage,
    String? documentImage,
    required List<SalonTiming> salonTimings,
  }) =>
      ServicesProvider(
        id: id ?? this.id,
        providerName: providerName ?? this.providerName,
        salonName: salonName ?? this.salonName,
        address: address ?? this.address,
        mobileNumber: mobileNumber ?? this.mobileNumber,
        email: email ?? this.email,
        viewCount: viewCount ?? this.viewCount,
        services: services,
        promoImages: promoImages ?? this.promoImages,
        averageRating: averageRating ?? this.averageRating,
        totalRatings: totalRatings ?? this.totalRatings,
        photo: photo ?? this.photo,
        imageUrl: imageUrl ?? this.imageUrl,
        panCard: panCard ?? this.panCard,
        gstIn: gstIn ?? this.gstIn,
        bankAccountNumber: bankAccountNumber ?? this.bankAccountNumber,
        bankIfscCode: bankIfscCode ?? this.bankIfscCode,
        address2: address2 ?? this.address2,
        city: city ?? this.city,
        state: state ?? this.state,
        country: country ?? this.country,
        pinCode: pinCode ?? this.pinCode,
        panCardImage: panCardImage ?? this.panCardImage,
        documentImage: documentImage ?? this.documentImage,
        salonTimings: salonTimings,
      );

  factory ServicesProvider.fromJson(Map<String, dynamic> json) => ServicesProvider(
    id: json["id"],
    providerName: json["name"],
    salonName: json["salon_name"],
    address: json["address"],
    mobileNumber: json["mobile_number"],
    email: json["email"],
    viewCount: json["view_count"],
    services: json['services'] != null
        ? serviceModelFromJson(jsonEncode(json['services']))
        : [],
    promoImages: json["promo_images"],
    averageRating: json["average_rating"]?.toDouble(), // Parse averageRating
    totalRatings: json["total_ratings"], // Parse totalRatings
    photo: json['photo'],
    imageUrl: json['image_urls'],
    panCard: json['pan_card'],
    gstIn: json['gst_in'] ?? null,
    bankAccountNumber: json['bank_account_number'],
    bankIfscCode: json['bank_ifsc_code'],
    address2: json['address_2'],
    city: json['city'],
    state: json['state'],
    country: json['country'],
    pinCode: json['pincode']?.toString() ?? "",
    panCardImage: json['pancard_image'],
    documentImage: json['document_image'],
    salonTimings: json['salon_timings'] != null
        ? salonTimingFromJson(jsonEncode(json['salon_timings']))
        : [], // Handle null case
  );


  Map<String, dynamic> toJson() => {
    "id": id,
    "provider_name": providerName,
    "salon_name": salonName,
    "address": address,
    "mobile_number": mobileNumber,
    "email": email,
    "view_count": viewCount,
    "services": jsonEncode(services),
    "promo_images": promoImages,
    "average_rating": averageRating, // Include in toJson
    "total_ratings": totalRatings,     // Include in toJson
    "photo": photo,
    "image_urls": imageUrl,
    "pan_card": panCard,
    "gst_in": gstIn,
    "bank_account_number": bankAccountNumber,
    "bank_ifsc_code": bankIfscCode,
    "address_2": address2,
    "city": city,
    "state": state,
    "country": country,
    "pincode": pinCode,
    "pancard_image": panCardImage,
    "document_image": documentImage,
    "salon_timings": jsonEncode(salonTimings),
  };
}
