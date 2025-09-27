import 'dart:convert';

List<ServiceProviderImage> serviceProviderImageFromJson(String str) => List<ServiceProviderImage>.from(json.decode(str).map((x) => ServiceProviderImage.fromJson(x)));

String serviceProviderImageToJson(List<ServiceProviderImage> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ServiceProviderImage {
  final int? id;
  final int? serviceProviderId;
  final String imageUrl;

  ServiceProviderImage({
    this.id,
    this.serviceProviderId,
    this.imageUrl = "",
  });

  ServiceProviderImage copyWith({
    int? id,
    int? serviceProviderId,
    required String imageUrl,
  }) =>
      ServiceProviderImage(
        id: id ?? this.id,
        serviceProviderId: serviceProviderId ?? this.serviceProviderId,
        imageUrl: imageUrl,
      );

  factory ServiceProviderImage.fromJson(Map<String, dynamic> json) {
    return ServiceProviderImage(
      id: json["id"],
      serviceProviderId: json["service_provider_id"],
      imageUrl: json["image_url"].toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "service_provider_id": serviceProviderId,
    "image_urls": imageUrl,
  };
}
