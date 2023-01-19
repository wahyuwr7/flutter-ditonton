import 'package:core/utils/state_enum.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/usecases/get_popular_tv.dart';
import 'package:tv/domain/usecases/get_top_rated_tv.dart';
import 'package:flutter/cupertino.dart';


class TopRatedTvNotifier extends ChangeNotifier {

  final GetTopRatedTv getTopRatedTv;

  TopRatedTvNotifier({required this.getTopRatedTv});

  RequestState _state = RequestState.Empty;
  RequestState get state => _state;

  List<Tv> _tv = [];
  List<Tv> get tv => _tv;

  String _message = '';
  String get message => _message;

  Future<void> fetchTopRatedTv() async {
    _tv = [];
    _state = RequestState.Loading;
    notifyListeners();

    final result = await getTopRatedTv.execute();

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