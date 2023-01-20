import 'package:equatable/equatable.dart';
import 'package:movie/domain/usecases/get_popular_movies.dart';
import 'package:movie/domain/usecases/get_top_rated_movies.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/movie.dart';
import '../../../domain/usecases/get_now_playing_movies.dart';

part 'movie_list_event.dart';
part 'movie_list_state.dart';


class MovieListBloc extends Bloc<MovieListEvent, MovieListState> {
  final GetNowPlayingMovies getNowPlayingMovies;
  final GetTopRatedMovies getTopRatedMovies;
  final GetPopularMovies getPopularMovies;

  MovieListBloc(
      this.getPopularMovies,
      this.getTopRatedMovies,
      this.getNowPlayingMovies
      ): super(MovieListStateEmpty()) {
    on<FetchingMovieLists>((event, emit) async {
      
      final todayResult = await getNowPlayingMovies.execute();
      final topResult = await getTopRatedMovies.execute();
      final popularResult = await getPopularMovies.execute();

      List<Movie> listToday = [];
      List<Movie> listTop = [];
      List<Movie> listPopular = [];

      todayResult.fold(
              (error) {
            emit(MovieListStateError(error.message));
          },
              (datas) {
            listToday = datas;
          }
      );

      topResult.fold(
              (error) {
            emit(MovieListStateError(error.message));
          },
              (datas) {
            listTop = datas;
          }
      );

      popularResult.fold(
              (error) {
            emit(MovieListStateError(error.message));
          },
              (datas) {
            listPopular = datas;
          }
      );

      if(listPopular.isNotEmpty && listTop.isNotEmpty && listToday.isNotEmpty) {
        emit(MovieListStateHasData(
          today: listToday,
          top: listTop,
          popular: listPopular
        ));
      }
    });
  }
}
