part of 'tv_watchlist_bloc.dart';

abstract class TvWatchlistState extends Equatable {
  const TvWatchlistState();

  @override
  List<Object> get props => [];
}

class TvWatchlistStateEmpty extends TvWatchlistState {}

class TvWatchlistStateLoading extends TvWatchlistState {}

class TvWatchlistStateError extends TvWatchlistState {
  final String message;

  const TvWatchlistStateError(this.message);

  @override
  List<Object> get props => [message];
}

class TvWatchlistStateHasData extends TvWatchlistState {
  final List<Tv> result;

  const TvWatchlistStateHasData(this.result);

  @override
  List<Object> get props => [result];
}