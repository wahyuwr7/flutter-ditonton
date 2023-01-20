part of 'movie_detail_bloc.dart';

abstract class MovieDetailEvent extends Equatable {
  const MovieDetailEvent();

  @override
  List<Object> get props => [];
}

class FetchingDetailData extends MovieDetailEvent {
  final int id;

  const FetchingDetailData(this.id);

  @override
  List<Object> get props => [id];
}

class FetchingRecommendations extends MovieDetailEvent {
  final int id;

  const FetchingRecommendations(this.id);

  @override
  List<Object> get props => [id];
}

class CheckWatchlistStatus extends MovieDetailEvent {
  final int id;

  const CheckWatchlistStatus(this.id);

  @override
  List<Object> get props => [id];
}

class RemovingFromWatchlist extends MovieDetailEvent {
  final MovieDetail data;

  const RemovingFromWatchlist(this.data);

  @override
  List<Object> get props => [data];
}

class AddingToWatchlist extends MovieDetailEvent {
  final MovieDetail data;

  const AddingToWatchlist(this.data);

  @override
  List<Object> get props => [data];
}

