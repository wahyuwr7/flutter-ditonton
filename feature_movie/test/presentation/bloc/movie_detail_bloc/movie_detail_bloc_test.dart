import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/domain/usecases/get_movie_detail.dart';
import 'package:movie/domain/usecases/get_movie_recommendations.dart';
import 'package:movie/domain/usecases/get_watchlist_status_movie.dart';
import 'package:movie/domain/usecases/remove_watchlist_movie.dart';
import 'package:movie/domain/usecases/save_watchlist.dart';
import 'package:movie/presentation/bloc/movie_detail_bloc/movie_detail_bloc.dart';
import '../../../dummy_data/dummy_objects.dart';
import '../../provider/movie_detail_notifier_test.mocks.dart';
import 'package:bloc_test/bloc_test.dart';

@GenerateMocks([
  GetMovieDetail,
  GetMovieRecommendations,
  GetWatchListStatus,
  SaveWatchlistMovie,
  RemoveWatchlistMovie,
])

void main() {
  late MockGetMovieDetail mockGetMovieDetail;
  late MockGetMovieRecommendations mockGetMovieRecomendation;
  late MockGetWatchListStatus mockGetWatchListStatusMovie;
  late MockSaveWatchlistMovie mockSaveWatchlistMovie;
  late MockRemoveWatchlistMovie mockRemoveWatchlistMovie;
  late MovieDetailBloc movieDetailBloc;


  setUp(() {
    mockGetMovieDetail = MockGetMovieDetail();
    mockGetMovieRecomendation = MockGetMovieRecommendations();
    mockGetWatchListStatusMovie = MockGetWatchListStatus();
    mockSaveWatchlistMovie = MockSaveWatchlistMovie();
    mockRemoveWatchlistMovie = MockRemoveWatchlistMovie();

    movieDetailBloc = MovieDetailBloc(
        mockGetMovieDetail,
        mockGetMovieRecomendation,
        mockGetWatchListStatusMovie,
        mockSaveWatchlistMovie,
        mockRemoveWatchlistMovie
    );

  });
  
  const tId = 1;
  final tMovieDetailState = MovieDetailState.init();

  test('initial state should be empty', () {
    expect(movieDetailBloc.state,tMovieDetailState);
  });

  group("Get Detail Movie", () {
    blocTest<MovieDetailBloc, MovieDetailState>(
        "Should emit MovieDetailState with Loading and Loaded state when data is gotten successfully",
        build: () {
          when(mockGetMovieDetail.execute(tId))
              .thenAnswer((_) async => Right(testMovieDetail) );
          when(mockGetMovieRecomendation.execute(tId))
              .thenAnswer((_) async => Right(testMovieList));
          when(mockGetWatchListStatusMovie.execute(tId))
              .thenAnswer((realInvocation) async => true);

          return movieDetailBloc;
        },
        act: (bloc) {
          return bloc.add(FetchingDetailData(tId));
        },
        expect: () {
          return [
            tMovieDetailState.replace(state: RequestState.Loading),
            tMovieDetailState.replace(
                state: RequestState.Loaded,
                movie: testMovieDetail
            ),
            tMovieDetailState.replace(
                state: RequestState.Loading,
                movie: testMovieDetail
            ),
            tMovieDetailState.replace(
              state: RequestState.Loaded,
              movie: testMovieDetail,
              recommendations: testMovieList,
            ),
            tMovieDetailState.replace(
              state: RequestState.Loading,
              movie: testMovieDetail,
              recommendations: testMovieList,
            ),
            tMovieDetailState.replace(
                state: RequestState.Loaded,
                movie: testMovieDetail,
                recommendations: testMovieList,
                watchlistStatus: true
            ),
          ];
        },
        verify: (bloc) {
          verify(mockGetMovieDetail.execute(tId));
          verify(mockGetMovieRecomendation.execute(tId));
          verify(mockGetWatchListStatusMovie.execute(tId));
        }
    );

    blocTest(
        "Should emit MovieDetailState with Loading and Error state when data is unsuccessfully",
        build: () {
          when(mockGetMovieDetail.execute(tId))
              .thenAnswer((realInvocation) async => Left(ServerFailure("Error")));
          return movieDetailBloc;
        },
        act: (bloc) => bloc.add(FetchingDetailData(tId)),
        expect: () => [
          tMovieDetailState.replace(
              state: RequestState.Loading
          ),
          tMovieDetailState.replace(
              state: RequestState.Error,
              message: "Error"
          ),
        ]
    );
  });

  group("Add to Watchlist", () {

    blocTest<MovieDetailBloc, MovieDetailState>(
        "Should emit watchlistStatus is true and 'succes' message when success adding data to watchlist",
        build: () {
          when(mockSaveWatchlistMovie.execute(testMovieDetail))
              .thenAnswer((realInvocation) async => Right("Success"));
          return movieDetailBloc;
        },
      act: (bloc) => bloc.add(AddingToWatchlist(testMovieDetail)),
      expect: () => [
        tMovieDetailState.replace(
          watchlistStatus: true,
          message: "Success"
        ),
      ],
      verify: (bloc) {
          verify(mockSaveWatchlistMovie.execute(testMovieDetail));
      }
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
        "Should emit 'failure' message when failure to adding data to watchlist",
        build: () {
          when(mockSaveWatchlistMovie.execute(testMovieDetail))
              .thenAnswer((realInvocation) async => Left(DatabaseFailure("Failure")));
          return movieDetailBloc;
        },
        act: (bloc) => bloc.add(AddingToWatchlist(testMovieDetail)),
        expect: () => [
          tMovieDetailState.replace(
              message: "Failure"
          ),
        ],
        verify: (bloc) {
          verify(mockSaveWatchlistMovie.execute(testMovieDetail));
        }
    );

  });


  group("Remove from Watchlist", () {

    blocTest<MovieDetailBloc, MovieDetailState>(
        "Should emit watchlistStatus is false and 'succes' message when success removing data to watchlist",
        build: () {
          when(mockRemoveWatchlistMovie.execute(testMovieDetail))
              .thenAnswer((_) async => Right("Success"));
          return movieDetailBloc;
        },
        act: (bloc) => bloc.add(RemovingFromWatchlist(testMovieDetail)),
        expect: () => [
          tMovieDetailState.replace(
              watchlistStatus: false,
              message: "Success"
          ),
        ],
        verify: (bloc) {
          verify(mockRemoveWatchlistMovie.execute(testMovieDetail));
        }
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
        "Should emit 'failure' message when failed to add remove from watchlist",
        build: () {
          when(mockRemoveWatchlistMovie.execute(testMovieDetail))
              .thenAnswer((realInvocation) async => Left(DatabaseFailure("Failure")));
          return movieDetailBloc;
        },
        act: (bloc) {

          return bloc.add(RemovingFromWatchlist(testMovieDetail));
        },
        expect: () => [
          tMovieDetailState.replace(
            message: "Failure"
          )
        ],
        verify: (bloc) {
          verify(mockRemoveWatchlistMovie.execute(testMovieDetail));
        }
    );

  });

}