part of 'movie_watchlist_bloc.dart';

class MovieWatchlistState extends Equatable {

  const MovieWatchlistState();

  @override
  List<Object> get props => [];
}

class MovieWatchlistStateEmpty extends MovieWatchlistState {}

class MovieWatchlistStateLoading extends MovieWatchlistState {}

class MovieWatchlistStateError extends MovieWatchlistState {
  final String message;

  const MovieWatchlistStateError(this.message);

  @override
  List<Object> get props => [message];
}

class MovieWatchlistStateHasData extends MovieWatchlistState {
  final List<Movie> result;

  const MovieWatchlistStateHasData(this.result);

  @override
  List<Object> get props => [result];
}