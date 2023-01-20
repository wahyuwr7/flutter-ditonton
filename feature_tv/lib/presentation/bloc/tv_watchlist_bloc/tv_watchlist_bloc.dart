import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/tv.dart';
import '../../../domain/usecases/get_watchlist_tv.dart';

part 'tv_watchlist_event.dart';
part 'tv_watchlist_state.dart';

class TvWatchlistBloc extends Bloc<TvWatchlistEvent, TvWatchlistState> {
  final GetWatchlistTv getWatchlistTv;

  TvWatchlistBloc(
    this.getWatchlistTv
  ): super(TvWatchlistStateEmpty()) {
    on<FetchingWatchlistData>((event, emit) async {

      emit(TvWatchlistStateLoading());

      final result = await getWatchlistTv.execute();

      result.fold(
          (err) {
            emit(TvWatchlistStateError(err.message));
          },
          (datas) {
            emit(TvWatchlistStateHasData(datas));
          }
      );
    });
  }
}
