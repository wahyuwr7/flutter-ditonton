import 'package:equatable/equatable.dart';
import 'package:tv/domain/entities/tv_detail.dart';

import '../../domain/entities/tv.dart';

abstract class TvState extends Equatable {
  const TvState();

  @override
  List<Object> get props => [];
}

class TvStateEmpty extends TvState {}

class TvStateLoading extends TvState {}

class TvStateError extends TvState {
  final String message;

  const TvStateError(this.message);

  @override
  List<Object> get props => [message];
}

class TvStateHasData extends TvState {
  final List<Tv> result;

  const TvStateHasData(this.result);

  @override
  List<Object> get props => [result];
}

class TvStateHasListData extends TvState {
  final List<Tv> onAir;
  final List<Tv> popular;
  final List<Tv> topRated;

  const TvStateHasListData(
      this.onAir,
      this.popular,
      this.topRated
      );

  @override
  List<Object> get props => [
    onAir,
    popular,
    topRated
  ];
}
