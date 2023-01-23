import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/presentation/bloc/movie_event.dart';
import 'package:movie/presentation/bloc/movie_state.dart';

import '../../../domain/usecases/get_top_rated_movies.dart';


class MovieTopRatedBloc extends Bloc<MovieEvent, MovieState> {
  final GetTopRatedMovies getTopRatedMovies;

  MovieTopRatedBloc(this.getTopRatedMovies): super(MovieStateEmpty()) {
    on<FetchingTopRatedMovies>((event, emit) async {

      emit(MovieStateLoading());

      final result = await getTopRatedMovies.execute();

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