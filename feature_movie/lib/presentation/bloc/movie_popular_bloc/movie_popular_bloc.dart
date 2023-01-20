import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/presentation/bloc/movie_event.dart';
import 'package:movie/presentation/bloc/movie_state.dart';
import '../../../domain/usecases/get_popular_movies.dart';


class MoviePopularBloc extends Bloc<MovieEvent, MovieState> {
  final GetPopularMovies getPopularMovies;

  MoviePopularBloc(this.getPopularMovies): super(MovieStateEmpty()) {
    on<FetchingPopularMovies>((event, emit) async {

      emit(MovieStateLoading());

      final result = await getPopularMovies.execute();

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