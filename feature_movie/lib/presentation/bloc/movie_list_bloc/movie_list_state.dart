part of 'movie_list_bloc.dart';

class MovieListState extends Equatable {

  const MovieListState();

  @override
  List<Object?> get props => [];
}

class MovieListStateEmpty extends MovieListState {}

class MovieListStateLoading extends MovieListState {}

class MovieListStateError extends MovieListState {
  final String message;

  const MovieListStateError(this.message);

  @override
  List<Object> get props => [message];
}

class MovieListStateHasData extends MovieListState {
  final List<Movie>? today;
  final List<Movie>? popular;
  final List<Movie>? top;

  const MovieListStateHasData({this.today, this.popular, this.top});

  MovieListStateHasData replace(
      List<Movie>? today,
      List<Movie>? popular,
      List<Movie>? top,
      ) => MovieListStateHasData(
    top: top ?? this.top,
    today: today ?? this.today,
    popular: popular ?? this.popular,
  );

  @override
  List<Object?> get props => [today, popular, top];
}