import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/presentation/bloc/movie_event.dart';
import 'package:movie/presentation/bloc/movie_state.dart';
import 'package:movie/presentation/bloc/movie_top_rated_bloc/movie_top_rated_bloc.dart';
import '../../../dummy_data/dummy_objects.dart';
import '../../provider/movie_list_notifier_test.mocks.dart';

void main() {
  late MockGetTopRatedMovies mockGetMovieTopRated;
  late MovieTopRatedBloc movieTopRatedMock;

  setUp(() {
    mockGetMovieTopRated = MockGetTopRatedMovies();
    movieTopRatedMock = MovieTopRatedBloc(mockGetMovieTopRated);
  });

  test("Should initial state is MovieStateEmpty()", () {
    expect(movieTopRatedMock.state, MovieStateEmpty());
  });

  blocTest(
      "Should emit [Loading, HashListData] state when success get list data",
      build: () {
        when(mockGetMovieTopRated.execute())
            .thenAnswer((realInvocation) async => Right(testMovieList));
        return movieTopRatedMock;
      },
    act: (bloc) => bloc.add(FetchingTopRatedMovies()),
    expect: () => [
      MovieStateLoading(),
      MovieStateHasData(testMovieList)
    ],
    verify: (bloc) {
        verify(mockGetMovieTopRated.execute());
    }
  );

  blocTest(
      "Should emit [Loading, Error] state when get list data unsuccessfull",
      build: () {
        when(mockGetMovieTopRated.execute())
            .thenAnswer((realInvocation) async => Left(ServerFailure("Error")));
        return movieTopRatedMock;
      },
      act: (bloc) => bloc.add(FetchingTopRatedMovies()),
      expect: () => [
        MovieStateLoading(),
        MovieStateError("Error"),
      ],
      verify: (bloc) {
        verify(mockGetMovieTopRated.execute());
      }
  );
}