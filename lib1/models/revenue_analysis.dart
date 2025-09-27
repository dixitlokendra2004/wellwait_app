// To parse this JSON data, do
//
//     final revenueAnalysis = revenueAnalysisFromJson(jsonString);

import 'dart:convert';

RevenueAnalysis revenueAnalysisFromJson(String str) => RevenueAnalysis.fromJson(json.decode(str));

String revenueAnalysisToJson(RevenueAnalysis data) => json.encode(data.toJson());

class RevenueAnalysis {
  final List<RevenuePanel>? panels;
  final List<GraphDatum>? graphData;

  RevenueAnalysis({
    this.panels,
    this.graphData,
  });

  RevenueAnalysis copyWith({
    List<RevenuePanel>? panels,
    List<GraphDatum>? graphData,
  }) =>
      RevenueAnalysis(
        panels: panels ?? this.panels,
        graphData: graphData ?? this.graphData,
      );

  factory RevenueAnalysis.fromJson(Map<String, dynamic> json) => RevenueAnalysis(
    panels: json["panels"] == null ? [] : List<RevenuePanel>.from(json["panels"]!.map((x) => RevenuePanel.fromJson(x))),
    graphData: json["graphData"] == null ? [] : List<GraphDatum>.from(json["graphData"]!.map((x) => GraphDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "panels": panels == null ? [] : List<dynamic>.from(panels!.map((x) => x.toJson())),
    "graphData": graphData == null ? [] : List<dynamic>.from(graphData!.map((x) => x.toJson())),
  };
}

class GraphDatum {
  final String? label;
  final int? revenue;

  GraphDatum({
    this.label,
    this.revenue,
  });

  GraphDatum copyWith({
    String? label,
    int? revenue,
  }) =>
      GraphDatum(
        label: label ?? this.label,
        revenue: revenue ?? this.revenue,
      );

  factory GraphDatum.fromJson(Map<String, dynamic> json) => GraphDatum(
    label: json["label"],
    revenue: json["revenue"],
  );

  Map<String, dynamic> toJson() => {
    "label": label,
    "revenue": revenue,
  };
}

class RevenuePanel {
  final int? id;
  final int? earning;
  final String? panelName;

  RevenuePanel({
    this.id,
    this.earning,
    this.panelName,
  });

  RevenuePanel copyWith({
    int? id,
    int? earning,
    String? panelName,
  }) =>
      RevenuePanel(
        id: id ?? this.id,
        earning: earning ?? this.earning,
        panelName: panelName ?? this.panelName,
      );

  factory RevenuePanel.fromJson(Map<String, dynamic> json) => RevenuePanel(
    id: json["id"],
    earning: json["earning"],
    panelName: json["panelName"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "earning": earning,
    "panelName": panelName,
  };
}
