import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/domain/usecases/get_popular_tv.dart';
import 'package:tv/domain/usecases/get_top_rated_tv.dart';
import 'package:tv/domain/usecases/get_tv_on_air.dart';
import 'package:tv/presentation/bloc/tv_event.dart';
import 'package:tv/presentation/bloc/tv_state.dart';

import '../../../domain/entities/tv.dart';



class TvListBloc extends Bloc<TvEvent, TvState> {
  final GetTopRatedTv getTopRatedTv;
  final GetTvOnAir getTvOnAir;
  final GetPopularTvs getPopularTvs;

  TvListBloc(
      this.getTopRatedTv,
      this.getTvOnAir,
      this.getPopularTvs
      ) : super(TvStateEmpty()) {
    on<GetTvListEvent>((event, emit) async {

      List<Tv> listTopRated = [];
      List<Tv> listPopular = [];
      List<Tv> listOnAir = [];

      emit(TvStateLoading());
      final topRated = await getTopRatedTv.execute();
      final popular = await getPopularTvs.execute();
      final tvOnAir = await getTvOnAir.execute();

      topRated.fold(
            (failure) {
              emit(TvStateError(failure.message));
            },
            (data) {
              listTopRated = data;
            },
      );
      popular.fold(
            (failure) {
          emit(TvStateError(failure.message));
        },
            (data) {
          listPopular = data;
        },
      );
      tvOnAir.fold(
            (failure) {
          emit(TvStateError(failure.message));
        },
            (data) {
          listOnAir = data;
        },
      );

      if(listOnAir.isNotEmpty && listTopRated.isNotEmpty && listPopular.isNotEmpty) emit(TvStateHasListData(listOnAir, listPopular, listTopRated));
    });
  }

}
