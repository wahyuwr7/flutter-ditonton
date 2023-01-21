import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/presentation/bloc/movie_event.dart';
import 'package:movie/presentation/bloc/movie_popular_bloc/movie_popular_bloc.dart';
import 'package:movie/presentation/bloc/movie_state.dart';
import '../../../dummy_data/dummy_objects.dart';
import '../../provider/movie_list_notifier_test.mocks.dart';

void main() {
  late MockGetPopularMovies mockGetMoviePopular;
  late MoviePopularBloc moviePopularMock;

  setUp(() {
    mockGetMoviePopular = MockGetPopularMovies();
    moviePopularMock = MoviePopularBloc(mockGetMoviePopular);
  });

  test("Should initial state is MovieStateEmpty()", () {
    expect(moviePopularMock.state, MovieStateEmpty());
  });

  blocTest(
      "Should emit [Loading, HashListData] state when success get list data",
      build: () {
        when(mockGetMoviePopular.execute())
            .thenAnswer((realInvocation) async => Right(testMovieList));
        return moviePopularMock;
      },
    act: (bloc) => bloc.add(FetchingPopularMovies()),
    expect: () => [
      MovieStateLoading(),
      MovieStateHasData(testMovieList)
    ],
    verify: (bloc) {
        verify(mockGetMoviePopular.execute());
    }
  );

  blocTest(
      "Should emit [Loading, Error] state when get list data unsuccessfull",
      build: () {
        when(mockGetMoviePopular.execute())
            .thenAnswer((realInvocation) async => Left(ServerFailure("Error")));
        return moviePopularMock;
      },
      act: (bloc) => bloc.add(FetchingPopularMovies()),
      expect: () => [
        MovieStateLoading(),
        MovieStateError("Error"),
      ],
      verify: (bloc) {
        verify(mockGetMoviePopular.execute());
      }
  );
}