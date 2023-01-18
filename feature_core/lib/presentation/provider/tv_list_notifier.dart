import 'package:core/utils/state_enum.dart';
import 'package:core/domain/usecases/get_popular_tv.dart';
import 'package:core/domain/usecases/get_top_rated_tv.dart';
import 'package:core/domain/usecases/get_tv_on_air.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/tv.dart';

class TvListNotifier extends ChangeNotifier {
  var _tvOnAir = <Tv>[];
  List<Tv> get tvOnAir => _tvOnAir;

  RequestState _onAirState = RequestState.Empty;
  RequestState get onAirState => _onAirState;

  var _popularTvs = <Tv>[];
  List<Tv> get popularTvs => _popularTvs;

  RequestState _popularTvsState = RequestState.Empty;
  RequestState get popularTvsState => _popularTvsState;

  var _topRatedTvs = <Tv>[];
  List<Tv> get topRatedTvs => _topRatedTvs;

  RequestState _topRatedTvsState = RequestState.Empty;
  RequestState get topRatedTvsState => _topRatedTvsState;

  String _message = '';
  String get message => _message;

  TvListNotifier({
    required this.getTvOnAir,
    required this.getPopularTvs,
    required this.getTopRatedTv,
  });

  final GetTvOnAir getTvOnAir;
  final GetPopularTvs getPopularTvs;
  final GetTopRatedTv getTopRatedTv;

  Future<void> fetchTvOnAir() async {
    _onAirState = RequestState.Loading;
    _tvOnAir = [];
    notifyListeners();

    final result = await getTvOnAir.execute();
    result.fold(
          (failure) {
        _onAirState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
          (tvsData) {
        _onAirState = RequestState.Loaded;
        _tvOnAir = tvsData;
        notifyListeners();
      },
    );
  }

  Future<void> fetchPopularTvs() async {
    _popularTvsState = RequestState.Loading;
    notifyListeners();

    final result = await getPopularTvs.execute();
    result.fold(
          (failure) {
        _popularTvsState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
          (tvsData) {
        _popularTvsState = RequestState.Loaded;
        _popularTvs = tvsData;
        notifyListeners();
      },
    );
  }

  Future<void> fetchTopRatedTvs() async {
    _topRatedTvsState = RequestState.Loading;
    notifyListeners();

    final result = await getTopRatedTv.execute();
    result.fold(
      (failure) {
        _topRatedTvsState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (tvsData) {
        _topRatedTvsState = RequestState.Loaded;
        _topRatedTvs = tvsData;
        notifyListeners();
      },
    );
  }
}
