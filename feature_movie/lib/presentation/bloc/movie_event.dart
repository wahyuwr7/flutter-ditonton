import 'package:equatable/equatable.dart';

class MovieEvent extends Equatable {

  const MovieEvent();

  @override
  List<Object> get props => [];
}

class FetchingPopularMovies extends MovieEvent {}

class FetchingTopRatedMovies extends MovieEvent {}

class FetchingTodayMovies extends MovieEvent {}