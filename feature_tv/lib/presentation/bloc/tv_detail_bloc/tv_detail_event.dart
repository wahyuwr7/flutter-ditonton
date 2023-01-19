part of 'tv_detail_bloc.dart';

abstract class TvDetailEvent extends Equatable {
  const TvDetailEvent();

  @override
  List<Object> get props => [];
}

class FetchingDetailData extends TvDetailEvent {
  final int id;

  const FetchingDetailData(this.id);

  @override
  List<Object> get props => [id];
}

class FetchingRecommendations extends TvDetailEvent {
  final int id;

  const FetchingRecommendations(this.id);

  @override
  List<Object> get props => [id];
}

class CheckWatchlistStatus extends TvDetailEvent {
  final int id;

  const CheckWatchlistStatus(this.id);

  @override
  List<Object> get props => [id];
}

class RemovingFromWatchlist extends TvDetailEvent {
  final TvDetail data;

  const RemovingFromWatchlist(this.data);

  @override
  List<Object> get props => [data];
}

class AddingToWatchlist extends TvDetailEvent {
  final TvDetail data;

  const AddingToWatchlist(this.data);

  @override
  List<Object> get props => [data];
}


