// To parse this JSON data, do
//
//     final count = countFromJson(jsonString);

import 'dart:convert';

Count countFromJson(String str) => Count.fromJson(json.decode(str));

String countToJson(Count data) => json.encode(data.toJson());

class Count {
  final int? count;

  Count({
    this.count,
  });

  Count copyWith({
    int? count,
  }) =>
      Count(
        count: count ?? this.count,
      );

  factory Count.fromJson(Map<String, dynamic> json) => Count(
    count: json["count"],
  );

  Map<String, dynamic> toJson() => {
    "count": count,
  };
}
