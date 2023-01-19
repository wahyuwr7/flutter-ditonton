part of 'tv_detail_bloc.dart';

class TvDetailState extends Equatable {
  final TvDetail? tv;
  final List<Tv> recommendations;
  final RequestState state;
  final String message;
  final bool watchlistStatus;

  const TvDetailState({
    this.tv,
    required this.recommendations,
    required this.state,
    required this.message,
    required this.watchlistStatus
  });

  TvDetailState replace({
    TvDetail? tv,
    List<Tv>? recommendations,
    RequestState? state,
    String? message,
    bool? watchlistStatus
  }) => TvDetailState(
      tv: tv ?? this.tv,
      recommendations:  recommendations ?? this.recommendations,
      state: state ?? this.state,
      message: message ?? this.message,
      watchlistStatus: watchlistStatus ?? this.watchlistStatus
  );

  factory TvDetailState.init()
  => const TvDetailState(
      tv: null,
      recommendations: [],
      state: RequestState.Empty,
      message: "",
      watchlistStatus: false
  );

  @override
  List<Object?> get props => [
    tv,
    recommendations,
    state,
    message,
    watchlistStatus
  ];
}