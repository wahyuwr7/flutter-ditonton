import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/domain/usecases/get_popular_tv.dart';
import 'package:tv/domain/usecases/get_tv_on_air.dart';
import 'package:tv/presentation/bloc/tv_event.dart';
import 'package:tv/presentation/bloc/tv_state.dart';



class TvPopularBloc extends Bloc<TvEvent, TvState> {
  final GetPopularTvs _usecase;

  TvPopularBloc(
      this._usecase,
      ) : super(TvStateEmpty()) {
    on<GetTvPopularEvent>((event, emit) async {

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
