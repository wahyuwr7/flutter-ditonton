import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/domain/usecases/get_now_playing_movies.dart';
import 'package:movie/domain/usecases/get_popular_movies.dart';
import 'package:movie/domain/usecases/get_top_rated_movies.dart';
import 'package:movie/presentation/bloc/movie_list_bloc/movie_list_bloc.dart';
import '../../../dummy_data/dummy_objects.dart';
import '../../provider/movie_list_notifier_test.mocks.dart';
import 'package:bloc_test/bloc_test.dart';

@GenerateMocks([
  GetNowPlayingMovies,
  GetTopRatedMovies,
  GetPopularMovies
])
void main() {
  late MockGetNowPlayingMovies mockGetMovieListOnAir;
  late MockGetTopRatedMovies mockGetTopRatedMovieList;
  late MockGetPopularMovies mockGetPopularMovieLists;
  late MovieListBloc movieListBloc;

  setUp(() {
    mockGetPopularMovieLists = MockGetPopularMovies();
    mockGetTopRatedMovieList = MockGetTopRatedMovies();
    mockGetMovieListOnAir = MockGetNowPlayingMovies();
    movieListBloc = MovieListBloc(mockGetPopularMovieLists, mockGetTopRatedMovieList, mockGetMovieListOnAir);
  });

  test("Should initial state is MovieListStateEmpty()", () {
    expect(movieListBloc.state, MovieListStateEmpty());
  });

  blocTest(
      "Should emit [Loading, HashListData] state when success get list data",
      build: () {
        when(mockGetPopularMovieLists.execute())
            .thenAnswer((realInvocation) async => Right(testMovieList));
        when(mockGetTopRatedMovieList.execute())
            .thenAnswer((realInvocation) async => Right(testMovieList));
        when(mockGetMovieListOnAir.execute())
            .thenAnswer((realInvocation) async => Right(testMovieList));
        return movieListBloc;
      },
    act: (bloc) => bloc.add(FetchingMovieLists()),
    expect: () => [
      MovieListStateLoading(),
      MovieListStateHasData(
        top: testMovieList,
        today: testMovieList,
        popular: testMovieList
      )
    ],
    verify: (bloc) {
        verify(mockGetPopularMovieLists.execute());
        verify(mockGetTopRatedMovieList.execute());
        verify(mockGetMovieListOnAir.execute());
    }
  );

  blocTest(
      "Should emit [Loading, Error] state when get list data unsuccessfull",
      build: () {
        when(mockGetPopularMovieLists.execute())
            .thenAnswer((realInvocation) async => Left(ServerFailure("Error")));
        when(mockGetTopRatedMovieList.execute())
            .thenAnswer((realInvocation) async => Left(ServerFailure("Error")));
        when(mockGetMovieListOnAir.execute())
            .thenAnswer((realInvocation) async => Left(ServerFailure("Error")));
        return movieListBloc;
      },
      act: (bloc) => bloc.add(FetchingMovieLists()),
      expect: () => [
        MovieListStateLoading(),
        MovieListStateError("Error"),
      ],
      verify: (bloc) {
        verify(mockGetPopularMovieLists.execute());
        verify(mockGetTopRatedMovieList.execute());
        verify(mockGetMovieListOnAir.execute());
      }
  );
}