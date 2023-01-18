import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/usecases/get_tv_on_air.dart';
import 'package:flutter/cupertino.dart';

import '../../utils/state_enum.dart';

class OnAirTvNotifier extends ChangeNotifier {

  final GetTvOnAir getTvOnAir;

  OnAirTvNotifier({required this.getTvOnAir});

  RequestState _state = RequestState.Empty;
  RequestState get state => _state;

  List<Tv> _tv = [];
  List<Tv> get tv => _tv;

  String _message = '';
  String get message => _message;

  Future<void> fetchOnAirTv() async {
    _tv = [];
    _state = RequestState.Loading;
    notifyListeners();

    final result = await getTvOnAir.execute();

    result.fold(
            (failure) {
          _message = failure.message;
          _state = RequestState.Error;
          notifyListeners();
        },
        (tvDatas) {
          _tv = tvDatas;
          _state = RequestState.Loaded;
          notifyListeners();
        }
    );
  }
}