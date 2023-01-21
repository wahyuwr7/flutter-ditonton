import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/domain/usecases/get_watchlist_movies.dart';
import 'package:movie/presentation/bloc/movie_watchlist_bloc/movie_watchlist_bloc.dart';
import '../../../dummy_data/dummy_objects.dart';
import 'movie_watchlist_bloc_test.mocks.dart';
import 'package:bloc_test/bloc_test.dart';

@GenerateMocks([
  GetWatchlistMovies
])
void main() {
  late MockGetWatchlistMovies mockGetWatchlistMovie;
  late MovieWatchlistBloc movieWatchlistBloc;

  setUp(() {
    mockGetWatchlistMovie = MockGetWatchlistMovies();
    movieWatchlistBloc = MovieWatchlistBloc(mockGetWatchlistMovie);
  });

  test(
    "initial state should be MovieWatchListStateEmpty",
      () {
        expect(movieWatchlistBloc.state, MovieWatchlistStateEmpty());
      }
  );

  blocTest(
      "Should emit [Loading, HasData] state when get data from databases is successfull",
      build: () {
        when(mockGetWatchlistMovie.execute())
            .thenAnswer((realInvocation) async => Right(testMovieList));
        return movieWatchlistBloc;
      },
    act: (bloc) => bloc.add(FetchingWatchlist()),
    expect: () => [
      MovieWatchlistStateLoading(),
      MovieWatchlistStateHasData(testMovieList)
    ],
    verify: (bloc) {
        verify(mockGetWatchlistMovie.execute());
    }
  );

  blocTest(
      "Should emit [Loading, HasData] state when get data from databases is successfull",
      build: () {
        when(mockGetWatchlistMovie.execute())
            .thenAnswer((realInvocation) async => Left(DatabaseFailure("Error")));
        return movieWatchlistBloc;
      },
      act: (bloc) => bloc.add(FetchingWatchlist()),
      expect: () => [
        MovieWatchlistStateLoading(),
        MovieWatchlistStateError("Error")
      ],
      verify: (bloc) {
        verify(mockGetWatchlistMovie.execute());
      }
  );
}

