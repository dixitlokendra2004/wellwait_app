import 'dart:convert';

List<Customer> customerFromJson(String str) =>
    List<Customer>.from(json.decode(str).map((x) => Customer.fromJson(x)));

String customerToJson(List<Customer> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Customer {
  int id;
  String? name;
  String? panelName;
  String? serviceList;
  int? serviceProviderId;
  double? price;
  final int? started;
  final String? startedAt;
  final int? finished;
  final String? finishedAt;
  final int? status;


  Customer({
    required this.id,
    this.name,
    this.panelName,
    this.serviceList,
    this.serviceProviderId,
    this.price,
    this.started,
    this.startedAt,
    this.finished,
    this.finishedAt,
    this.status,
  });

  Customer copyWith({
    int? id,
    String? name,
    String? panelName,
    String? serviceList,
    int? serviceProviderId,
    double? price,
    int? started,
    String? startedAt,
    int? finished,
    String? finishedAt,
    int? status,

  }) =>
      Customer(
        id: id ?? this.id,
        name: name ?? this.name,
        panelName: panelName ?? this.panelName,
        serviceList: serviceList ?? this.serviceList,
        serviceProviderId: serviceProviderId ?? this.serviceProviderId,
        price: price ?? this.price,
        started: started ?? this.started,
        startedAt: startedAt ?? this.startedAt,
        finished: finished ?? this.finished,
        finishedAt: finishedAt ?? this.finishedAt,
        status: status ?? this.status,
      );

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
    id: json["customer_id"], // Ensure you're using `customer_id` from the API
    name: json["name"] ?? "",
    panelName: json["panel_name"] ?? "",
    serviceList: json["service_list"] ?? "",
    serviceProviderId: json["service_provider_id"] != null ? int.tryParse(json["service_provider_id"].toString()) : null,
    price: json["price"] != null ? double.tryParse(json["price"].toString()) : null,
    started: json["started"] != null ? int.tryParse(json["started"].toString()) : null,
    startedAt: json["started_at"] ?? "",
    finished: json["finished"] != null ? int.tryParse(json["finished"].toString()) : null,
    finishedAt: json["finished_at"] ?? "",
    status: json["status"] != null ? int.tryParse(json["status"].toString()) : null,
  );


  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "panel_name": panelName,
    "service_list": serviceList,
    "service_provider_id": serviceProviderId,
    "price": price,
    "started_at": startedAt.toString(),  // New field
    "finished": finished,        // New field
    "finished_at": finishedAt?.toString(),
    "status": status,
  };
}