import 'dart:convert';

List<ServiceProviderBanner> serviceProviderBannerFromJson(String str) => List<ServiceProviderBanner>.from(json.decode(str).map((x) => ServiceProviderBanner.fromJson(x)));

String serviceProviderBannerToJson(List<ServiceProviderBanner> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ServiceProviderBanner {
  final int? id;
  final int? serviceProviderId;
  final String imageUrl;

  ServiceProviderBanner({
    this.id,
    this.serviceProviderId,
    this.imageUrl = "",
  });

  ServiceProviderBanner copyWith({
    int? id,
    int? serviceProviderId,
    required String imageUrl,
  }) =>
      ServiceProviderBanner(
        id: id ?? this.id,
        serviceProviderId: serviceProviderId ?? this.serviceProviderId,
        imageUrl: imageUrl,
      );

  factory ServiceProviderBanner.fromJson(Map<String, dynamic> json) {
    return ServiceProviderBanner(
      id: json["id"],
      serviceProviderId: json["service_provider_id"],
      imageUrl: json["image_url"].toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "service_provider_id": serviceProviderId,
    "image_url": imageUrl
  };
}
