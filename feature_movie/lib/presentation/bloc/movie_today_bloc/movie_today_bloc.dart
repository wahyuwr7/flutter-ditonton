import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/domain/usecases/get_now_playing_movies.dart';
import 'package:movie/presentation/bloc/movie_event.dart';
import 'package:movie/presentation/bloc/movie_state.dart';


class MovieTodayBloc extends Bloc<MovieEvent, MovieState> {
  final GetNowPlayingMovies getTodayMovies;

  MovieTodayBloc(this.getTodayMovies): super(MovieStateEmpty()) {
    on<FetchingTodayMovies>((event, emit) async {

      emit(MovieStateLoading());

      final result = await getTodayMovies.execute();

      result.fold(
              (error) {
            emit(MovieStateError(error.message));
          },
              (datas) {
            emit(MovieStateHasData(datas));
          }
      );
    });
  }
}