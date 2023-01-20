import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/domain/usecases/get_watchlist_movies.dart';

import '../../../domain/entities/movie.dart';

part 'movie_watchlist_event.dart';
part 'movie_watchlist_state.dart';

class MovieWatchlistBloc extends Bloc<MovieWatchlistEvent, MovieWatchlistState> {
  final GetWatchlistMovies getWatchlistMovies;

  MovieWatchlistBloc(this.getWatchlistMovies): super(MovieWatchlistStateEmpty()) {
    on<FetchingWatchlist>((event, emit) async {

      emit(MovieWatchlistStateLoading());

      final result = await getWatchlistMovies.execute();

      result.fold(
          (error) {
            emit(MovieWatchlistStateError(error.message));
          },
          (datas) {
            emit(MovieWatchlistStateHasData(datas));
          }
      );
    });
  }
}