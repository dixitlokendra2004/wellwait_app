// To parse this JSON data, do
//
//     final allTest = allTestFromJson(jsonString);

import 'dart:convert';

List<Subcategories> allTestFromJson(String str) => List<Subcategories>.from(json.decode(str).map((x) => Subcategories.fromJson(x)));

String allTestToJson(List<Subcategories> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Subcategories {
  int? id;
  String? name;
  int? categoryId;
  String? icon;
  int? searchCount;

  Subcategories({
    this.id,
    this.name,
    this.categoryId,
    this.icon,
    this.searchCount,
  });

  Subcategories copyWith({
    int? id,
    String? name,
    int? categoryId,
    String? icon,
    int? searchCount,
  }) =>
      Subcategories(
        id: id ?? this.id,
        name: name ?? this.name,
        categoryId: categoryId ?? this.categoryId,
        icon: icon ?? this.icon,
        searchCount: searchCount ?? this.searchCount,
      );

  factory Subcategories.fromJson(Map<String, dynamic> json) => Subcategories(
    id: json["id"],
    name: json["name"],
    categoryId: json["category_id"],
    icon: json["icon"],
    searchCount: json["search_count"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "category_id": categoryId,
    "icon": icon,
    "search_count": searchCount,
  };
}
