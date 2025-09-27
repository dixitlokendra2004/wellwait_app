// To parse this JSON data, do
//
//     final services = servicesFromJson(jsonString);

import 'dart:convert';

List<ServiceModel> serviceModelFromJson(String str) => List<ServiceModel>.from(json.decode(str).map((x) => ServiceModel.fromJson(x)));

String serviceModelToJson(List<ServiceModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ServiceModel {
  final int? id;
  final String? name;
  final String? category;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? price;
  final String? promoImage;
  final int? rating;
  final String? categoryType;
  final int? serviceProviderId;
  final String? salonName;
  final String? address;
  final int? viewCount;

  ServiceModel({
    this.id,
    this.name,
    this.category,
    this.createdAt,
    this.updatedAt,
    this.price,
    this.promoImage,
    this.rating,
    this.categoryType,
    this.serviceProviderId,
    this.salonName,
    this.address,
    this.viewCount,
  });

  ServiceModel copyWith({
    int? id,
    String? name,
    String? category,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? price,
    String? promoImage,
    int? rating,
    String? categoryType,
    int? serviceProviderId,
    String? salonName,
    String? address,
    int? viewCount,
  }) =>
      ServiceModel(
        id: id ?? this.id,
        name: name ?? this.name,
        category: category ?? this.category,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        price: price ?? this.price,
        promoImage: promoImage ?? this.promoImage,
        rating: rating ?? this.rating,
        categoryType: categoryType ?? this.categoryType,
        serviceProviderId: serviceProviderId ?? this.serviceProviderId,
        salonName: salonName ?? this.salonName,
        address: address ?? this.address,
        viewCount: viewCount ?? this.viewCount,
      );

  factory ServiceModel.fromJson(Map<String, dynamic> json) => ServiceModel(
    id: json["id"],
    name: json["name"],
    category: json["category"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    price: json["price"],
    promoImage: json["promo_image"],
    rating: json["rating"],
    categoryType: json["category_type"],
    serviceProviderId: json["service_provider_id"],
    salonName: json["salon_name"],
    address: json["address"],
    viewCount: json["view_count"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "category": category,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "price": price,
    "promo_image": promoImage,
    "rating": rating,
    "category_type": categoryType,
    "service_provider_id": serviceProviderId,
    "salon_name": salonName,
    "address": address,
    "view_count": viewCount,
  };
}

