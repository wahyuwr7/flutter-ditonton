import 'dart:convert';

import 'package:core/data/models/tv_model.dart';
import 'package:core/data/models/tv_response.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../json_reader.dart';

void main() {
  final tTvModel = TvModel(
      backdropPath: "/path.jpg",
      firstAirDate: "2020-10-05",
      genreIds: [1,2,3],
      id: 1,
      name: "Name",
      originCountry: ["IN"],
      originalLanguage: "Original language",
      originalName: "Original name",
      overview: "Overview",
      popularity: 1.0,
      posterPath: "/path.jpg",
      voteAverage: 5.4,
      voteCount: 21
  );

  final tTvResponseModel =
      TvResponse(results: <TvModel>[tTvModel], page: 1, totalPages: 1, totalResults: 1);

  group('fromJson', () {
    test('should return a valid model from JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(readJson('dummy_data/tv_on_the_air.json'));
      // act
      final result = TvResponse.fromJson(jsonMap);
      // assert
      expect(result.results, tTvResponseModel.results);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      // arrange

      // act
      final result = tTvResponseModel.toJson();
      // assert
      final expectedJsonMap = {
        "page": 1,
        "results": [
          {
            "backdrop_path": "/path.jpg",
            "first_air_date": "2020-10-05",
            "genre_ids": [
              1,
              2,
              3
            ],
            "id": 1,
            "name": "Name",
            "origin_country": [
              "IN"
            ],
            "original_language": "Original language",
            "original_name": "Original name",
            "overview": "Overview",
            "popularity": 1.0,
            "poster_path": "/path.jpg",
            "vote_average": 5.4,
            "vote_count": 21
          }
        ],
        "total_pages": 1,
        "total_results": 1
      };
      expect(result, expectedJsonMap);
    });
  });
}
