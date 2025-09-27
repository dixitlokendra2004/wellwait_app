import 'dart:convert';

List<Favorite> favoriteFromJson(String str) =>
    List<Favorite>.from(json.decode(str).map((x) => Favorite.fromJson(x)));

String favoriteToJson(List<Favorite> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Favorite {
  int serviceProviderId;
  String? salonName;
  String? address;
  String? image_url;
  String? averageRating;

  Favorite({
    required this.serviceProviderId,
    this.salonName,
    this.address,
    this.image_url,
    this.averageRating,
  });

  Favorite copyWith({
    int? serviceProviderId,
    String? salonName,
    String? address,
    String? image_url,
    String? averageRating,
  }) =>
      Favorite(
        serviceProviderId: serviceProviderId ?? this.serviceProviderId,
        salonName: salonName ?? this.salonName,
        address: address ?? this.address,
        image_url: image_url ?? this.image_url,
        averageRating: averageRating ?? this.averageRating,
      );

  factory Favorite.fromJson(Map<String, dynamic> json) => Favorite(
    serviceProviderId: json["service_provider_id"],
    salonName: json["salon_name"] ?? "",
    address: json["address"] ?? "",
    image_url: json["image_url"] ?? "",
    averageRating: json["average_rating"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "service_provider_id": serviceProviderId,
    "salon_name": salonName,
    "address": address,
    "image_url": image_url,
    "average_rating": averageRating,
  };
}