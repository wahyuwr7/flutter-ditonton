import 'package:equatable/equatable.dart';
import '../../domain/entities/movie.dart';

class MovieState extends Equatable {

  const MovieState();

  @override
  List<Object> get props => [];
}

class MovieStateEmpty extends MovieState {}

class MovieStateLoading extends MovieState {}

class MovieStateError extends MovieState {
  final String message;

  const MovieStateError(this.message);

  @override
  List<Object> get props => [message];
}

class MovieStateHasData extends MovieState {
  final List<Movie> result;

  const MovieStateHasData(this.result);

  @override
  List<Object> get props => [result];
}