import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/domain/usecases/get_tv_on_air.dart';
import 'package:tv/presentation/bloc/tv_event.dart';
import 'package:tv/presentation/bloc/tv_state.dart';



class OnAirBloc extends Bloc<TvEvent, TvState> {
  final GetTvOnAir getTvOnAir;

  OnAirBloc(
      this.getTvOnAir,
      ) : super(TvStateEmpty()) {
    on<GetOnAirEvent>((event, emit) async {

      emit(TvStateLoading());
      final result = await getTvOnAir.execute();

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
