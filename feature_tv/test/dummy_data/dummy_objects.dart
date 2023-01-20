import 'package:tv/data/models/tv_table.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/entities/tv_detail.dart';

final testTvTable = TvTable(
  id: 1,
  name: 'name',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testTvMap = {
  'id': 1,
  'overview': 'overview',
  'posterPath': 'posterPath',
  'name': 'name',
};

final testTvDetail = TvDetail(
  adult: false,
  backdropPath: 'backdropPath',
  homepage: "https://google.com",
  id: 1,
  originalLanguage: 'en',
  overview: 'overview',
  popularity: 1,
  posterPath: 'posterPath',
  status: 'Status',
  tagline: 'Tagline',
  voteAverage: 1,
  voteCount: 1,
  episodeRunTime: [],
  firstAirDate: DateTime.parse("2022-10-10"),
  genres: [TvGenre(id: 1, name: "name"), TvGenre(id: 1, name: "name")],
  inProduction: false,
  languages: ["EN"],
  lastAirDate: DateTime.parse("2022-10-10"),
  name: 'name',
  networks: [Network(id: 1, name: "name", logoPath: "logoPath", originCountry: "originCountry")],
  numberOfEpisodes: 1,
  originCountry: ["EN"],
  originalName: 'Original Name',
  productionCompanies: [Network(id: 1, name: "name", logoPath: "logoPath", originCountry: "originCountry")],
  type: 'Type',
  numberOfSeasons: 1,
);

final testWatchlistTv = Tv.watchlist(
    id: 1,
    overview: "overview",
    posterPath: "posterPath",
    name: "name"
);

final testTv = Tv(
    backdropPath: "backdropPath",
    firstAirDate: "firstAirDate",
    genreIds: [1],
    id: 1,
    name: "name",
    originCountry: ["originCountry"],
    originalLanguage: "originalLanguage",
    originalName: "originalName",
    overview: "overview",
    popularity: 1.0,
    posterPath: "posterPath",
    voteAverage: 1.0,
    voteCount: 1
);

final List<Tv> testTvList = [testTv];