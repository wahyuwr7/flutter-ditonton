import 'package:equatable/equatable.dart';

import '../../domain/entities/tv_detail.dart';

abstract class TvEvent extends Equatable {
  const TvEvent();

  @override
  List<Object> get props => [];
}

class GetOnAirEvent extends TvEvent {

  const GetOnAirEvent();

  @override
  List<Object> get props => [];
}

class GetTvPopularEvent extends TvEvent {

  const GetTvPopularEvent();

  @override
  List<Object> get props => [];
}

class GetTvTopRatedEvent extends TvEvent {

  const GetTvTopRatedEvent();

  @override
  List<Object> get props => [];
}

class GetTvRecommendationEvent extends TvEvent {
  final int query;
  const GetTvRecommendationEvent(this.query);

  @override
  List<Object> get props => [query];
}

class GetTvListEvent extends TvEvent {

  const GetTvListEvent();

  @override
  List<Object> get props => [];
}

class GetTvDetailEvent extends TvEvent {
  final int id;
  const GetTvDetailEvent(this.id);

  @override
  List<Object> get props => [id];
}

class TvAddWatchlistEvent extends TvEvent {
  final int id;
  const TvAddWatchlistEvent(this.id);

  @override
  List<Object> get props => [id];
}

class TvRemoveWatchlistEvent extends TvEvent {
  final TvDetail data;
  const TvRemoveWatchlistEvent(this.data);

  @override
  List<Object> get props => [data];
}