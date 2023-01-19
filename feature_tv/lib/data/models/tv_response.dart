import 'package:tv/data/models/tv_model.dart';
import 'dart:convert';

class TvResponse {
  TvResponse({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  final int? page;
  final List<TvModel> results;
  final int? totalPages;
  final int? totalResults;

  factory TvResponse.fromRawJson(String str) => TvResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TvResponse.fromJson(Map<String, dynamic> json) => TvResponse(
    page: json["page"],
    results: List<TvModel>.from(json["results"]!.map((x) => TvModel.fromJson(x))),
    totalPages: json["total_pages"],
    totalResults: json["total_results"],
  );

  Map<String, dynamic> toJson() => {
    "page": page,
    "results": results == null ? [] : List<dynamic>.from(results!.map((x) => x!.toJson())),
    "total_pages": totalPages,
    "total_results": totalResults,
  };
}