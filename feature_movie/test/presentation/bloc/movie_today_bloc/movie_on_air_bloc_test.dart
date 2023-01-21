import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/presentation/bloc/movie_event.dart';
import 'package:movie/presentation/bloc/movie_state.dart';
import 'package:movie/presentation/bloc/movie_today_bloc/movie_today_bloc.dart';
import '../../../dummy_data/dummy_objects.dart';
import '../../provider/movie_list_notifier_test.mocks.dart';

void main() {
  late MockGetNowPlayingMovies mockGetTodayData;
  late MovieTodayBloc movieTodayBloc;

  setUp(() {
    mockGetTodayData = MockGetNowPlayingMovies();
    movieTodayBloc = MovieTodayBloc(mockGetTodayData);
  });

  test("Should initial state is MovieStateEmpty()", () {
    expect(movieTodayBloc.state, MovieStateEmpty());
  });

  blocTest(
      "Should emit [Loading, HashListData] state when success get list data",
      build: () {
        when(mockGetTodayData.execute())
            .thenAnswer((realInvocation) async => Right(testMovieList));
        return movieTodayBloc;
      },
    act: (bloc) => bloc.add(FetchingTodayMovies()),
    expect: () => [
      MovieStateLoading(),
      MovieStateHasData(testMovieList)
    ],
    verify: (bloc) {
        verify(mockGetTodayData.execute());
    }
  );

  blocTest(
      "Should emit [Loading, Error] state when get list data unsuccessfull",
      build: () {
        when(mockGetTodayData.execute())
            .thenAnswer((realInvocation) async => Left(ServerFailure("Error")));
        return movieTodayBloc;
      },
      act: (bloc) => bloc.add(FetchingTodayMovies()),
      expect: () => [
        MovieStateLoading(),
        MovieStateError("Error"),
      ],
      verify: (bloc) {
        verify(mockGetTodayData.execute());
      }
  );
}