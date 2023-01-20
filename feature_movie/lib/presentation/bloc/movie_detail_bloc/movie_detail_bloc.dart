import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/domain/entities/movie_detail.dart';
import 'package:equatable/equatable.dart';
import 'package:movie/domain/usecases/get_movie_recommendations.dart';
import 'package:movie/domain/usecases/save_watchlist.dart';
import '../../../domain/entities/movie.dart';
import '../../../domain/usecases/get_movie_detail.dart';
import '../../../domain/usecases/get_watchlist_status_movie.dart';
import '../../../domain/usecases/remove_watchlist_movie.dart';

part 'movie_detail_event.dart';
part 'movie_detail_state.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  final GetMovieDetail getMovieDetail;
  final GetMovieRecommendations getMovieRecomendation;
  final GetWatchListStatus getWatchListStatus;
  final SaveWatchlistMovie saveWatchlist;
  final RemoveWatchlistMovie removeWatchlist;

  MovieDetailBloc(
      this.getMovieDetail,
      this.getMovieRecomendation,
      this.getWatchListStatus,
      this.saveWatchlist,
      this.removeWatchlist,
      ): super(MovieDetailState.init()) {
    on<FetchingDetailData>((event, emit) async {

      emit(state.replace(
          state: RequestState.Loading
      ));

      final id = event.id;

      final result = await getMovieDetail.execute(id);

      result.fold(
              (err) {
            emit(state.replace(
                state: RequestState.Error,
                message: err.message
            ));
          },
              (datas) {
            emit(state.replace(
                state: RequestState.Loaded,
                movie: datas
            ));
            add(FetchingRecommendations(id));
            add(CheckWatchlistStatus(id));
          }
      );
    });

    on<FetchingRecommendations>((event, emit) async {
      final id = event.id;

      emit(state.replace(
          state: RequestState.Loading
      ));

      final result = await getMovieRecomendation.execute(id);

      result.fold(
              (err) {
            emit(state.replace(
                state: RequestState.Error,
                message: err.message
            ));
          },
              (datas) {
            emit(state.replace(
                state: RequestState.Loaded,
                recommendations: datas
            ));
          }
      );
    });

    on<CheckWatchlistStatus>((event, emit) async {
      final id = event.id;

      emit(state.replace(
          state: RequestState.Loading
      ));

      final result = await getWatchListStatus.execute(id);

      emit(state.replace(
          watchlistStatus: result,
          state: RequestState.Loaded
      ));

    });
    on<RemovingFromWatchlist>((event, emit) async {
      final data = event.data;

      final result = await removeWatchlist.execute(data);

      result.fold(
              (err){
            emit(state.replace(
                message: err.message
            ));
          },
              (success) {
            emit(state.replace(
                message: success,
                watchlistStatus: false
            ));
          }
      );
    });

    on<AddingToWatchlist>((event, emit) async {
      final data = event.data;

      final result = await saveWatchlist.execute(data);

      result.fold(
              (err){
            emit(state.replace(
                message: err.message
            ));
          },
              (success) {
            emit(state.replace(
                message: success,
                watchlistStatus: true
            ));
          }
      );
    });
  }
}