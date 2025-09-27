// To parse this JSON data, do
//
//     final adminNotification = adminNotificationFromJson(jsonString);

import 'dart:convert';

List<AdminNotification> adminNotificationFromJson(String str) => List<AdminNotification>.from(json.decode(str).map((x) => AdminNotification.fromJson(x)));

String adminNotificationToJson(List<AdminNotification> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AdminNotification {
  final int? id;
  final int? serviceProviderId;
  final dynamic userId;
  final String? title;
  final String? body;
  final DateTime? createdDate;

  AdminNotification({
    this.id,
    this.serviceProviderId,
    this.userId,
    this.title,
    this.body,
    this.createdDate,
  });

  AdminNotification copyWith({
    int? id,
    int? serviceProviderId,
    dynamic userId,
    String? title,
    String? body,
    DateTime? createdDate,
  }) =>
      AdminNotification(
        id: id ?? this.id,
        serviceProviderId: serviceProviderId ?? this.serviceProviderId,
        userId: userId ?? this.userId,
        title: title ?? this.title,
        body: body ?? this.body,
        createdDate: createdDate ?? this.createdDate,
      );

  factory AdminNotification.fromJson(Map<String, dynamic> json) => AdminNotification(
    id: json["id"],
    serviceProviderId: json["service_provider_id"],
    userId: json["user_id"],
    title: json["title"],
    body: json["body"],
    createdDate: json["created_date"] == null ? null : DateTime.parse(json["created_date"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "service_provider_id": serviceProviderId,
    "user_id": userId,
    "title": title,
    "body": body,
    "created_date": createdDate?.toIso8601String(),
  };
}
