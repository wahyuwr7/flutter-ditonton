import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/domain/entities/tv_detail.dart';
import 'package:tv/domain/usecases/get_tv_recomendation.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/tv.dart';
import '../../../domain/usecases/get_tv_detail.dart';
import '../../../domain/usecases/get_watchlist_status_tv.dart';
import '../../../domain/usecases/remove_watchlist_tv.dart';
import '../../../domain/usecases/save_watchlist_tv.dart';

part 'tv_detail_event.dart';
part 'tv_detail_state.dart';

class TvDetailBloc extends Bloc<TvDetailEvent, TvDetailState> {
  final GetTvDetail getTvDetail;
  final GetTvRecomendation getTvRecomendation;
  final GetWatchListStatusTv getWatchListStatus;
  final SaveWatchlistTv saveWatchlist;
  final RemoveWatchlistTv removeWatchlist;

  TvDetailBloc(
    this.getTvDetail,
    this.getTvRecomendation,
    this.getWatchListStatus,
    this.saveWatchlist,
    this.removeWatchlist,
  ): super(TvDetailState.init()) {
    on<FetchingDetailData>((event, emit) async {

      emit(state.replace(
        state: RequestState.Loading
      ));

      final id = event.id;

      final result = await getTvDetail.execute(id);

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
              tv: datas
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

      final result = await getTvRecomendation.execute(id);

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
        watchlistStatus: result
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
