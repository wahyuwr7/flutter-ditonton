part of 'movie_detail_bloc.dart';

class MovieDetailState extends Equatable {
  final MovieDetail? movie;
  final List<Movie> recommendations;
  final RequestState state;
  final String message;
  final bool watchlistStatus;

  const MovieDetailState({
    this.movie,
    required this.recommendations,
    required this.state,
    required this.message,
    required this.watchlistStatus
  });

  MovieDetailState replace({
    MovieDetail? movie,
    List<Movie>? recommendations,
    RequestState? state,
    String? message,
    bool? watchlistStatus
  }) => MovieDetailState(
      movie: movie ?? this.movie,
      recommendations:  recommendations ?? this.recommendations,
      state: state ?? this.state,
      message: message ?? this.message,
      watchlistStatus: watchlistStatus ?? this.watchlistStatus
  );

  factory MovieDetailState.init()
  => const MovieDetailState(
      movie: null,
      recommendations: [],
      state: RequestState.Empty,
      message: "",
      watchlistStatus: false
  );

  @override
  List<Object?> get props => [
    movie,
    recommendations,
    state,
    message,
    watchlistStatus
  ];
}