import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/domain/usecases/get_watchlist_tv.dart';
import 'package:tv/presentation/bloc/tv_watchlist_bloc/tv_watchlist_bloc.dart';
import '../../../dummy_data/dummy_objects.dart';
import 'tv_watchlist_bloc_test.mocks.dart';

@GenerateMocks([
  GetWatchlistTv
])
void main() {
  late MockGetWatchlistTv mockGetWatchlistTv;
  late TvWatchlistBloc tvWatchlistBloc;

  setUp(() {
    mockGetWatchlistTv = MockGetWatchlistTv();
    tvWatchlistBloc = TvWatchlistBloc(mockGetWatchlistTv);
  });

  test(
    "initial state should be TvWatchListStateEmpty",
      () {
        expect(tvWatchlistBloc.state, TvWatchlistStateEmpty());
      }
  );

  blocTest(
      "Should emit [Loading, HasData] state when get data from databases is successfull",
      build: () {
        when(mockGetWatchlistTv.execute())
            .thenAnswer((realInvocation) async => Right(testTvList));
        return tvWatchlistBloc;
      },
    act: (bloc) => bloc.add(FetchingWatchlistData()),
    expect: () => [
      TvWatchlistStateLoading(),
      TvWatchlistStateHasData(testTvList)
    ],
    verify: (bloc) {
        verify(mockGetWatchlistTv.execute());
    }
  );

  blocTest(
      "Should emit [Loading, HasData] state when get data from databases is successfull",
      build: () {
        when(mockGetWatchlistTv.execute())
            .thenAnswer((realInvocation) async => Left(DatabaseFailure("Error")));
        return tvWatchlistBloc;
      },
      act: (bloc) => bloc.add(FetchingWatchlistData()),
      expect: () => [
        TvWatchlistStateLoading(),
        TvWatchlistStateError("Error")
      ],
      verify: (bloc) {
        verify(mockGetWatchlistTv.execute());
      }
  );
}

