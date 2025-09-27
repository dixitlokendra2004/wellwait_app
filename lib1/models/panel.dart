import 'dart:convert';

// To parse this JSON data, do
// final panel = panelFromJson(jsonString);

List<Panel> panelFromJson(String str) => List<Panel>.from(json.decode(str).map((x) => Panel.fromJson(x)));

String panelToJson(List<Panel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Panel {
  final int? id;  // Added id field
  final String? name;
  final String? responsiblePerson;
  final int? price;
  final int? serviceProviderId;
  final String? serviceList;
  final String? lunchStart;
  final String? lunchEnd;
  int? queueCount;
  int? isPanelLive;

  Panel({
    this.id, // Include id in the constructor
    this.name,
    this.responsiblePerson,
    this.price,
    this.serviceProviderId,
    this.serviceList,
    this.lunchStart,
    this.lunchEnd,
    this.isPanelLive,
  });

  Panel copyWith({
    int? id,  // Add id to the copyWith method
    String? name,
    String? description,
    int? price,
    int? serviceProviderId,
    String? serviceList,
    String? lunchStart,
    String? lunchEnd,
    int? isPanelLive,
  }) =>
      Panel(
        id: id ?? this.id,  // Set id if provided, otherwise use existing
        name: name ?? this.name,
        responsiblePerson: description ?? this.responsiblePerson,
        price: price ?? this.price,
        serviceProviderId: serviceProviderId ?? this.serviceProviderId,
        serviceList: serviceList ?? this.serviceList,
        lunchStart: lunchStart ?? this.lunchStart,
        lunchEnd: lunchEnd ?? this.lunchEnd,
        isPanelLive: isPanelLive ?? this.isPanelLive,
      );

  factory Panel.fromJson(Map<String, dynamic> json) => Panel(
    id: json["id"],  // Parse id from JSON
    name: json["name"],
    responsiblePerson: json["responsible_person"],
    price: json["price"],
    serviceProviderId: json["service_provider_id"],
    serviceList: json["service_list"],
    lunchStart: json["lunch_start"],
    lunchEnd: json["lunch_end"],
    isPanelLive: json["is_panel_live"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,  // Include id in the JSON output
    "name": name,
    "responsible_person": responsiblePerson,
    "price": price,
    "service_provider_id": serviceProviderId,
    "service_list": serviceList,
    "lunch_start": lunchStart,
    "lunch_end": lunchEnd,
    "is_panel_live": isPanelLive,
  };
}
