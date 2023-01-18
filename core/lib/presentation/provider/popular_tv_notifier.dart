import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/usecases/get_popular_tv.dart';
import 'package:flutter/cupertino.dart';

import '../../utils/state_enum.dart';

class PopularTvNotifier extends ChangeNotifier {

  final GetPopularTvs getPopularTvs;

  PopularTvNotifier({required this.getPopularTvs});

  RequestState _state = RequestState.Empty;
  RequestState get state => _state;

  List<Tv> _tv = [];
  List<Tv> get tv => _tv;

  String _message = '';
  String get message => _message;

  Future<void> fetchPopularTv() async {
    _tv = [];
    _state = RequestState.Loading;
    notifyListeners();

    final result = await getPopularTvs.execute();

    result.fold(
        (failure) {
          print("Error");
          _message = failure.message;
          _state = RequestState.Error;
          notifyListeners();
        },
        (tvDatas) {
          print(tvDatas);
          _tv = tvDatas;
          _state = RequestState.Loaded;
          notifyListeners();
        }
    );
  }
}