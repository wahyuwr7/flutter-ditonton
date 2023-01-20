import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/domain/usecases/get_tv_detail.dart';
import 'package:tv/domain/usecases/get_tv_recomendation.dart';
import 'package:tv/domain/usecases/get_watchlist_status_tv.dart';
import 'package:tv/domain/usecases/remove_watchlist_tv.dart';
import 'package:tv/domain/usecases/save_watchlist_tv.dart';
import 'package:tv/presentation/bloc/tv_detail_bloc/tv_detail_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import '../../../dummy_data/dummy_objects.dart';
import 'tv_detail_bloc_test.mocks.dart';

@GenerateMocks([
  GetTvDetail,
  GetTvRecomendation,
  GetWatchListStatusTv,
  SaveWatchlistTv,
  RemoveWatchlistTv,
])

void main() {
  late MockGetTvDetail mockGetTvDetail;
  late MockGetTvRecomendation mockGetTvRecomendation;
  late MockGetWatchListStatusTv mockGetWatchListStatusTv;
  late MockSaveWatchlistTv mockSaveWatchlistTv;
  late MockRemoveWatchlistTv mockRemoveWatchlistTv;
  late TvDetailBloc tvDetailBloc;


  setUp(() {
    mockGetTvDetail = MockGetTvDetail();
    mockGetTvRecomendation = MockGetTvRecomendation();
    mockGetWatchListStatusTv = MockGetWatchListStatusTv();
    mockSaveWatchlistTv = MockSaveWatchlistTv();
    mockRemoveWatchlistTv = MockRemoveWatchlistTv();

    tvDetailBloc = TvDetailBloc(
        mockGetTvDetail,
        mockGetTvRecomendation,
        mockGetWatchListStatusTv,
        mockSaveWatchlistTv,
        mockRemoveWatchlistTv
    );

  });
  
  const tId = 1;
  final tTvDetailState = TvDetailState.init();

  test('initial state should be empty', () {
    expect(tvDetailBloc.state,tTvDetailState);
  });

  group("Get Detail Tv", () {
    blocTest<TvDetailBloc, TvDetailState>(
        "Should emit TvDetailState with Loading and Loaded state when data is gotten successfully",
        build: () {
          when(mockGetTvDetail.execute(tId))
              .thenAnswer((_) async => Right(testTvDetail) );
          when(mockGetTvRecomendation.execute(tId))
              .thenAnswer((_) async => Right(testTvList));
          when(mockGetWatchListStatusTv.execute(tId))
              .thenAnswer((realInvocation) async => true);

          return tvDetailBloc;
        },
        act: (bloc) {
          return bloc.add(FetchingDetailData(tId));
        },
        expect: () {
          return [
            tTvDetailState.replace(state: RequestState.Loading),
            tTvDetailState.replace(
                state: RequestState.Loaded,
                tv: testTvDetail
            ),
            tTvDetailState.replace(
                state: RequestState.Loading,
                tv: testTvDetail
            ),
            tTvDetailState.replace(
              state: RequestState.Loaded,
              tv: testTvDetail,
              recommendations: testTvList,
            ),
            tTvDetailState.replace(
              state: RequestState.Loading,
              tv: testTvDetail,
              recommendations: testTvList,
            ),
            tTvDetailState.replace(
                state: RequestState.Loaded,
                tv: testTvDetail,
                recommendations: testTvList,
                watchlistStatus: true
            ),
          ];
        },
        verify: (bloc) {
          verify(mockGetTvDetail.execute(tId));
          verify(mockGetTvRecomendation.execute(tId));
          verify(mockGetWatchListStatusTv.execute(tId));
        }
    );

    blocTest(
        "Should emit TvDetailState with Loading and Error state when data is unsuccessfully",
        build: () {
          when(mockGetTvDetail.execute(tId))
              .thenAnswer((realInvocation) async => Left(ServerFailure("Error")));
          return tvDetailBloc;
        },
        act: (bloc) => bloc.add(FetchingDetailData(tId)),
        expect: () => [
          tTvDetailState.replace(
              state: RequestState.Loading
          ),
          tTvDetailState.replace(
              state: RequestState.Error,
              message: "Error"
          ),
        ]
    );
  });

  group("Add to Watchlist", () {

    blocTest<TvDetailBloc, TvDetailState>(
        "Should emit watchlistStatus is true and 'succes' message when success adding data to watchlist",
        build: () {
          when(mockSaveWatchlistTv.execute(testTvDetail))
              .thenAnswer((realInvocation) async => Right("Success"));
          return tvDetailBloc;
        },
      act: (bloc) => bloc.add(AddingToWatchlist(testTvDetail)),
      expect: () => [
        tTvDetailState.replace(
          watchlistStatus: true,
          message: "Success"
        ),
      ],
      verify: (bloc) {
          verify(mockSaveWatchlistTv.execute(testTvDetail));
      }
    );

    blocTest<TvDetailBloc, TvDetailState>(
        "Should emit 'failure' message when failure to adding data to watchlist",
        build: () {
          when(mockSaveWatchlistTv.execute(testTvDetail))
              .thenAnswer((realInvocation) async => Left(DatabaseFailure("Failure")));
          return tvDetailBloc;
        },
        act: (bloc) => bloc.add(AddingToWatchlist(testTvDetail)),
        expect: () => [
          tTvDetailState.replace(
              message: "Failure"
          ),
        ],
        verify: (bloc) {
          verify(mockSaveWatchlistTv.execute(testTvDetail));
        }
    );

  });


  group("Remove from Watchlist", () {

    blocTest<TvDetailBloc, TvDetailState>(
        "Should emit watchlistStatus is false and 'succes' message when success removing data to watchlist",
        build: () {
          when(mockRemoveWatchlistTv.execute(testTvDetail))
              .thenAnswer((_) async => Right("Success"));
          return tvDetailBloc;
        },
        act: (bloc) => bloc.add(RemovingFromWatchlist(testTvDetail)),
        expect: () => [
          tTvDetailState.replace(
              watchlistStatus: false,
              message: "Success"
          ),
        ],
        verify: (bloc) {
          verify(mockRemoveWatchlistTv.execute(testTvDetail));
        }
    );

    blocTest<TvDetailBloc, TvDetailState>(
        "Should emit 'failure' message when failed to add remove from watchlist",
        build: () {
          when(mockRemoveWatchlistTv.execute(testTvDetail))
              .thenAnswer((realInvocation) async => Left(DatabaseFailure("Failure")));
          return tvDetailBloc;
        },
        act: (bloc) {

          return bloc.add(RemovingFromWatchlist(testTvDetail));
        },
        expect: () => [
          tTvDetailState.replace(
            message: "Failure"
          )
        ],
        verify: (bloc) {
          verify(mockRemoveWatchlistTv.execute(testTvDetail));
        }
    );

  });

}