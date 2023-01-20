import 'dart:io';

import 'package:core/data/datasources/db/database_helper.dart';
import 'package:core/data/datasources/ssl_pinning.dart';
import 'package:http/io_client.dart';
import 'package:movie/data/datasources/movie_local_data_source.dart';
import 'package:movie/data/datasources/movie_remote_data_source.dart';
import 'package:tv/data/datasources/tv_local_data_source.dart';
import 'package:tv/data/datasources/tv_remote_data_source.dart';
import 'package:movie/data/repositories/movie_repository_impl.dart';
import 'package:tv/data/repositories/tv_repository_impl.dart';
import 'package:movie/domain/repositories/movie_repository.dart';
import 'package:tv/domain/repositories/tv_repository.dart';
import 'package:movie/domain/usecases/get_movie_detail.dart';
import 'package:movie/domain/usecases/get_movie_recommendations.dart';
import 'package:movie/domain/usecases/get_now_playing_movies.dart';
import 'package:movie/domain/usecases/get_popular_movies.dart';
import 'package:tv/domain/usecases/get_popular_tv.dart';
import 'package:movie/domain/usecases/get_top_rated_movies.dart';
import 'package:tv/domain/usecases/get_top_rated_tv.dart';
import 'package:tv/domain/usecases/get_tv_detail.dart';
import 'package:tv/domain/usecases/get_tv_on_air.dart';
import 'package:tv/domain/usecases/get_tv_recomendation.dart';
import 'package:movie/domain/usecases/get_watchlist_movies.dart';
import 'package:movie/domain/usecases/get_watchlist_status_movie.dart';
import 'package:tv/domain/usecases/get_watchlist_status_tv.dart';
import 'package:tv/domain/usecases/get_watchlist_tv.dart';
import 'package:movie/domain/usecases/remove_watchlist_movie.dart';
import 'package:tv/domain/usecases/remove_watchlist_tv.dart';
import 'package:movie/domain/usecases/save_watchlist.dart';
import 'package:tv/domain/usecases/save_watchlist_tv.dart';
import 'package:movie/presentation/provider/movie_detail_notifier.dart';
import 'package:movie/presentation/provider/movie_list_notifier.dart';
import 'package:search/presentation/bloc/movie_search_bloc.dart';
import 'package:search/presentation/provider/movie_search_notifier.dart';
import 'package:tv/presentation/provider/on_air_tv_notifier.dart';
import 'package:movie/presentation/provider/popular_movies_notifier.dart';
import 'package:tv/presentation/provider/popular_tv_notifier.dart';
import 'package:movie/presentation/provider/top_rated_movies_notifier.dart';
import 'package:tv/presentation/provider/top_rated_tv_notifier.dart';
import 'package:tv/presentation/provider/tv_detail_notifier.dart';
import 'package:tv/presentation/provider/tv_list_notifier.dart';
import 'package:search/presentation/provider/tv_search_notifier.dart';
import 'package:movie/presentation/provider/watchlist_movie_notifier.dart';
import 'package:tv/presentation/provider/watchlist_tv_notifier.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:search/domain/usecases/search_movies.dart';
import 'package:search/domain/usecases/search_tv.dart';

final locator = GetIt.instance;

void init() {

  // bloc
  locator.registerFactory(
        () => MovieSearchBloc(
      locator(),
    ),
  );

  // provider
  locator.registerFactory(
    () => MovieListNotifier(
      getNowPlayingMovies: locator(),
      getPopularMovies: locator(),
      getTopRatedMovies: locator(),
    ),
  );
  locator.registerFactory(
    () => MovieDetailNotifier(
      getMovieDetail: locator(),
      getMovieRecommendations: locator(),
      getWatchListStatus: locator(),
      saveWatchlist: locator(),
      removeWatchlist: locator(),
    ),
  );
  locator.registerFactory(
    () => MovieSearchNotifier(
      searchMovies: locator(),
    ),
  );
  locator.registerFactory(
    () => PopularMoviesNotifier(
      locator(),
    ),
  );
  locator.registerFactory(
    () => TopRatedMoviesNotifier(
      getTopRatedMovies: locator(),
    ),
  );
  locator.registerFactory(
    () => WatchlistMovieNotifier(
      getWatchlistMovies: locator(),
    ),
  );
  locator.registerFactory(
      () => PopularTvNotifier(getPopularTvs: locator())
  );
  locator.registerFactory(
          () => TopRatedTvNotifier(getTopRatedTv: locator())
  );
  locator.registerFactory(
          () => OnAirTvNotifier(getTvOnAir: locator())
  );
  locator.registerFactory(
          () => TvSearchNotifier(searchTv: locator())
  );
  locator.registerFactory(
          () => TvListNotifier(
              getTvOnAir: locator(),
              getPopularTvs: locator(),
              getTopRatedTv: locator()
          )
  );
  locator.registerFactory(
          () => TvDetailNotifier(
              getTvDetail: locator(),
              getTvRecomendation: locator(),
              getWatchListStatus: locator(),
              saveWatchlist: locator(),
              removeWatchlist: locator()
          )
  );
  locator.registerFactory(
          () => WatchlistTvNotifier(getWatchlistTvs: locator())
  );

  // use case
  locator.registerLazySingleton(() => GetNowPlayingMovies(locator()));
  locator.registerLazySingleton(() => GetPopularMovies(locator()));
  locator.registerLazySingleton(() => GetTopRatedMovies(locator()));
  locator.registerLazySingleton(() => GetMovieDetail(locator()));
  locator.registerLazySingleton(() => GetMovieRecommendations(locator()));
  locator.registerLazySingleton(() => SearchMovies(locator()));
  locator.registerLazySingleton(() => GetWatchListStatus(locator()));
  locator.registerLazySingleton(() => SaveWatchlistMovie(locator()));
  locator.registerLazySingleton(() => RemoveWatchlistMovie(locator()));
  locator.registerLazySingleton(() => GetWatchlistMovies(locator()));
  locator.registerLazySingleton(() => GetPopularTvs(locator()));
  locator.registerLazySingleton(() => GetTopRatedTv(locator()));
  locator.registerLazySingleton(() => GetTvOnAir(locator()));
  locator.registerLazySingleton(() => GetTvRecomendation(locator()));
  locator.registerLazySingleton(() => SearchTv(locator()));
  locator.registerLazySingleton(() => GetTvDetail(locator()));
  locator.registerLazySingleton(() => GetWatchlistTv(locator()));
  locator.registerLazySingleton(() => GetWatchListStatusTv(locator()));
  locator.registerLazySingleton(() => RemoveWatchlistTv(locator()));
  locator.registerLazySingleton(() => SaveWatchlistTv(locator()));



  // repository
  locator.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );
  locator.registerLazySingleton<TvRepository>(
      () => TvRepositoryImpl(
          remoteDataSource: locator(),
          localDataSource: locator()
      )
  );

  // data sources
  locator.registerLazySingleton<MovieRemoteDataSource>(
      () => MovieRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<MovieLocalDataSource>(
      () => MovieLocalDataSourceImpl(databaseHelper: locator()));
  locator.registerLazySingleton<TvRemoteDataSource>(
      () => TvRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<TvLocalDataSource>(
          () => TvLocalDataSourceImpl(databaseHelper: locator()));

  // helper
  locator.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());

  // external
  locator.registerLazySingleton(() => SSLPinning.client);
}
