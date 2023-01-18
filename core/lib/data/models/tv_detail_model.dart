import 'dart:convert';

import 'package:core/domain/entities/tv_detail.dart';

class TvDetailModel {
  TvDetailModel({
    required this.adult,
    required this.backdropPath,
    required this.episodeRunTime,
    required this.firstAirDate,
    required this.genres,
    required this.homepage,
    required this.id,
    required this.inProduction,
    required this.languages,
    required this.lastAirDate,
    required this.name,
    required this.networks,
    required this.numberOfEpisodes,
    required this.numberOfSeasonModels,
    required this.originCountry,
    required this.originalLanguage,
    required this.originalName,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.productionCompanies,
    required this.status,
    required this.tagline,
    required this.type,
    required this.voteAverage,
    required this.voteCount,
  });

  final bool adult;
  final String backdropPath;
  final List<int> episodeRunTime;
  final DateTime firstAirDate;
  final List<GenreModel> genres;
  final String homepage;
  final int id;
  final bool inProduction;
  final List<String> languages;
  final DateTime lastAirDate;
  final String name;
  final List<NetworkModel> networks;
  final int numberOfEpisodes;
  final int numberOfSeasonModels;
  final List<String> originCountry;
  final String originalLanguage;
  final String originalName;
  final String overview;
  final double popularity;
  final String posterPath;
  final List<NetworkModel> productionCompanies;
  final String status;
  final String tagline;
  final String type;
  final double voteAverage;
  final int voteCount;

  factory TvDetailModel.fromRawJson(String str) => TvDetailModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TvDetailModel.fromJson(Map<String, dynamic> json) => TvDetailModel(
    adult: json["adult"],
    backdropPath: json["backdrop_path"],
    episodeRunTime: List<int>.from(json["episode_run_time"].map((x) => x)),
    firstAirDate: DateTime.parse(json["first_air_date"]),
    genres: List<GenreModel>.from(json["genres"].map((x) => GenreModel.fromJson(x))),
    homepage: json["homepage"],
    id: json["id"],
    inProduction: json["in_production"],
    languages: List<String>.from(json["languages"].map((x) => x)),
    lastAirDate: DateTime.parse(json["last_air_date"]),
    name: json["name"],
    networks: List<NetworkModel>.from(json["networks"].map((x) => NetworkModel.fromJson(x))),
    numberOfEpisodes: json["number_of_episodes"],
    numberOfSeasonModels: json["number_of_seasons"],
    originCountry: List<String>.from(json["origin_country"].map((x) => x)),
    originalLanguage: json["original_language"],
    originalName: json["original_name"],
    overview: json["overview"],
    popularity: json["popularity"].toDouble(),
    posterPath: json["poster_path"],
    productionCompanies: List<NetworkModel>.from(json["production_companies"].map((x) => NetworkModel.fromJson(x))),
    status: json["status"],
    tagline: json["tagline"],
    type: json["type"],
    voteAverage: json["vote_average"].toDouble(),
    voteCount: json["vote_count"],
  );

  Map<String, dynamic> toJson() => {
    "adult": adult,
    "backdrop_path": backdropPath,
    "episode_run_time": List<dynamic>.from(episodeRunTime.map((x) => x)),
    "first_air_date": "${firstAirDate.year.toString().padLeft(4, '0')}-${firstAirDate.month.toString().padLeft(2, '0')}-${firstAirDate.day.toString().padLeft(2, '0')}",
    "genres": List<dynamic>.from(genres.map((x) => x.toJson())),
    "homepage": homepage,
    "id": id,
    "in_production": inProduction,
    "languages": List<dynamic>.from(languages.map((x) => x)),
    "last_air_date": "${lastAirDate.year.toString().padLeft(4, '0')}-${lastAirDate.month.toString().padLeft(2, '0')}-${lastAirDate.day.toString().padLeft(2, '0')}",
    "name": name,
    "networks": List<dynamic>.from(networks.map((x) => x.toJson())),
    "number_of_episodes": numberOfEpisodes,
    "number_of_seasons": numberOfSeasonModels,
    "origin_country": List<dynamic>.from(originCountry.map((x) => x)),
    "original_language": originalLanguage,
    "original_name": originalName,
    "overview": overview,
    "popularity": popularity,
    "poster_path": posterPath,
    "production_companies": List<dynamic>.from(productionCompanies.map((x) => x.toJson())),
    "status": status,
    "tagline": tagline,
    "type": type,
    "vote_average": voteAverage,
    "vote_count": voteCount,
  };

  TvDetail toEntity() {
    return TvDetail(
        adult: this.adult,
        backdropPath: this.backdropPath,
        episodeRunTime: this.episodeRunTime,
        firstAirDate: this.firstAirDate,
        genres: this.genres.map((e) => e.toEntity()).toList(),
        homepage: this.homepage,
        id: this.id,
        inProduction: this.inProduction,
        languages: this.languages,
        lastAirDate: this.lastAirDate,
        name: this.name,
        networks: this.networks.map((e) => e.toEntity()).toList(),
        numberOfEpisodes: this.numberOfEpisodes,
        numberOfSeasons: this.numberOfSeasonModels,
        originCountry: this.originCountry,
        originalLanguage: this.originalLanguage,
        originalName: this.originalName,
        overview: this.overview,
        popularity: this.popularity,
        posterPath: this.posterPath,
        productionCompanies: this.productionCompanies.map((e) => e.toEntity()).toList(),
        status: this.status,
        tagline: this.tagline,
        type: this.type,
        voteAverage: this.voteAverage,
        voteCount: this.voteCount);
  }

}

class GenreModel {
  GenreModel({
    required this.id,
    required this.name,
  });

  final int id;
  final String name;

  factory GenreModel.fromRawJson(String str) => GenreModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GenreModel.fromJson(Map<String, dynamic> json) => GenreModel(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };

  TvGenre toEntity() {
    return TvGenre(
        id: id,
        name: name
    );
  }
}

class NetworkModel {
  NetworkModel({
    required this.id,
    required this.name,
    required this.logoPath,
    required this.originCountry,
  });

  final int id;
  final String name;
  final String logoPath;
  final String originCountry;

  factory NetworkModel.fromRawJson(String str) => NetworkModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory NetworkModel.fromJson(Map<String, dynamic> json) => NetworkModel(
    id: json["id"],
    name: json["name"],
    logoPath: json["logo_path"] != null ? json["logo_path"] : "",
    originCountry: json["origin_country"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "logo_path": logoPath,
    "origin_country": originCountry,
  };

  Network toEntity() => Network(
      id: this.id,
      name: this.name,
      logoPath: this.logoPath,
      originCountry: this.originCountry
  );
}
