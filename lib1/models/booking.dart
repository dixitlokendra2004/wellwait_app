import 'dart:convert';

List<Booking> bookingFromJson(String str) => List<Booking>.from(json.decode(str).map((x) => Booking.fromJson(x)));

String bookingToJson(List<Booking> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Booking {
  final int? id;
  final String? username;
  final String? photo;
  final DateTime? scheduledDate;
  final String? serviceName;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? panelId;
  final int? serviceProviderId;
  final int? status;
  final int? price;
  final String? panelName;
  final int? started;
  final String? startedAt;
  final int? finished;
  final String? finishedAt;
  final String? salonName;
  final String? address;
  final String? imageUrl;
  final double? averageRating;
  final int? totalRating;
  final int? paymentComplete;

  Booking({
    this.id,
    this.username,
    this.photo,
    this.scheduledDate,
    this.serviceName,
    this.createdAt,
    this.updatedAt,
    this.panelId,
    this.serviceProviderId,
    this.status,
    this.price,
    this.panelName,
    this.started,
    this.startedAt,
    this.finished,
    this.finishedAt,
    this.salonName,
    this.address,
    this.imageUrl,
    this.averageRating,
    this.totalRating,
    this.paymentComplete,
  });

  Booking copyWith({
    int? id,
    String? username,
    String? photo,
    DateTime? scheduledDate,
    String? serviceName,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? panelId,
    int? serviceProviderId,
    int? status,
    int? price,
    String? panelName,
    int? started,
    String? startedAt,
    int? finished,
    String? finishedAt,
    String? salonName,
    String? address,
    String? imageUrl,
    double? averageRating,
    int? totalRating,
    int? paymentComplete,
  }) =>
      Booking(
        id: id ?? this.id,
        username: username ?? this.username,
        photo: photo ?? this.photo,
        scheduledDate: scheduledDate ?? this.scheduledDate,
        serviceName: serviceName ?? this.serviceName,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        panelId: panelId ?? this.panelId,
        serviceProviderId: serviceProviderId ?? this.serviceProviderId,
        status: status ?? this.status,
        price: price ?? this.price,
        panelName: panelName ?? this.panelName,
        started: started ?? this.started,
        startedAt: startedAt ?? this.startedAt,
        finished: finished ?? this.finished,
        finishedAt: finishedAt ?? this.finishedAt,
        salonName: salonName ?? this.salonName,
        address: address ?? this.address,
        imageUrl: imageUrl ?? this.imageUrl,
        averageRating: averageRating ?? this.averageRating,
        totalRating: totalRating ?? this.totalRating,
        paymentComplete: paymentComplete ?? this.paymentComplete,
      );

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
    id: json["id"],
    username: json["username"] ?? '',
    photo: json["photo"] ?? '',
    scheduledDate: json["scheduled_date"] == null
        ? DateTime.now()
        : DateTime.tryParse(json["scheduled_date"]) ?? DateTime.now(),
    serviceName: json["service_name"] ?? '',
    createdAt: json["createdAt"] == null
        ? DateTime.now()
        : DateTime.tryParse(json["createdAt"]) ?? DateTime.now(),
    updatedAt: json["updatedAt"] == null
        ? DateTime.now()
        : DateTime.tryParse(json["updatedAt"]) ?? DateTime.now(),
    panelId: json["panel_id"] is int ? json["panel_id"] : int.tryParse(json["panel_id"].toString()) ?? 0,
    serviceProviderId: json["service_provider_id"] is int
        ? json["service_provider_id"]
        : int.tryParse(json["service_provider_id"].toString()) ?? 0,
    status: json["status"] is int ? json["status"] : int.tryParse(json["status"].toString()) ?? 0,
    price: json["price"] is int ? json["price"] : int.tryParse(json["price"].toString()) ?? 0,
    panelName: json["panel_name"] ?? '',
    started: json["started"],
    startedAt: json["started_at"],
    finished: json["finished"],
    finishedAt: json["finished_at"] ?? '',
    salonName: json["salon_name"] ?? '',
    address: json['address'] ?? '',
    imageUrl: json['image_url'] ?? '',
    averageRating: json["average_rating"]?.toDouble(),
    totalRating: json["total_ratings"],
    paymentComplete: json["payment_completed"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "photo": photo,
    "scheduled_date": scheduledDate?.toIso8601String(),
    "service_name": serviceName,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "panel_id": panelId,
    "service_provider_id": serviceProviderId,
    "status": status,
    "price": price,
    "panel_name": panelName,
    "started": started,
    "started_at": startedAt.toString(),
    "finished": finished,
    "finished_at": finishedAt?.toString(),
    "salon_name": salonName?.toString(),
    "address": address?.toString(),
    "image_url": imageUrl,
    "average_rating": averageRating,
    "total_ratings": totalRating,
    "payment_completed": paymentComplete,
  };
}

