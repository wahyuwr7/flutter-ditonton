import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/domain/usecases/get_popular_tv.dart';
import 'package:tv/domain/usecases/get_top_rated_tv.dart';
import 'package:tv/domain/usecases/get_tv_on_air.dart';
import 'package:tv/presentation/bloc/tv_event.dart';
import 'package:tv/presentation/bloc/tv_state.dart';



class TvTopRatedBloc extends Bloc<TvEvent, TvState> {
  final GetTopRatedTv _usecase;

  TvTopRatedBloc(
      this._usecase,
      ) : super(TvStateEmpty()) {
    on<GetTvTopRatedEvent>((event, emit) async {

      emit(TvStateLoading());
      final result = await _usecase.execute();

      result.fold(
            (failure) {
              emit(TvStateError(failure.message));
            },
            (data) {
          emit(TvStateHasData(data));
        },
      );
    });
  }

}
