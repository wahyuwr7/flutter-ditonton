part of 'movie_list_bloc.dart';

class MovieListEvent extends Equatable {

  const MovieListEvent();

  @override
  List<Object> get props => [];
}

class FetchingMovieLists extends MovieListEvent {
  final int id;

  FetchingMovieLists(this.id);

  @override
  List<Object> get props => [id];
}