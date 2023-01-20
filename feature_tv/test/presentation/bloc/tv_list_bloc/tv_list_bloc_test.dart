import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/domain/usecases/get_popular_tv.dart';
import 'package:tv/domain/usecases/get_top_rated_tv.dart';
import 'package:tv/domain/usecases/get_tv_on_air.dart';
import 'package:tv/presentation/bloc/tv_event.dart';
import 'package:tv/presentation/bloc/tv_list_bloc/tv_list_bloc.dart';
import 'package:tv/presentation/bloc/tv_state.dart';
import '../../../dummy_data/dummy_objects.dart';
import '../../provider/tv_list_notifier_test.mocks.dart';

@GenerateMocks([
  GetTvOnAir,
  GetTopRatedTv,
  GetPopularTvs
])
void main() {
  late MockGetTvOnAir mockGetTvOnAir;
  late MockGetTopRatedTv mockGetTopRatedTv;
  late MockGetPopularTvs mockGetPopularTvs;
  late TvListBloc tvListBloc;

  setUp(() {
    mockGetPopularTvs = MockGetPopularTvs();
    mockGetTopRatedTv = MockGetTopRatedTv();
    mockGetTvOnAir = MockGetTvOnAir();
    tvListBloc = TvListBloc(mockGetTopRatedTv, mockGetTvOnAir, mockGetPopularTvs);
  });

  test("Should initial state is TvStateEmpty()", () {
    expect(tvListBloc.state, TvStateEmpty());
  });

  blocTest(
      "Should emit [Loading, HashListData] state when success get list data",
      build: () {
        when(mockGetPopularTvs.execute())
            .thenAnswer((realInvocation) async => Right(testTvList));
        when(mockGetTopRatedTv.execute())
            .thenAnswer((realInvocation) async => Right(testTvList));
        when(mockGetTvOnAir.execute())
            .thenAnswer((realInvocation) async => Right(testTvList));
        return tvListBloc;
      },
    act: (bloc) => bloc.add(const GetTvListEvent()),
    expect: () => [
      TvStateLoading(),
      TvStateHasListData(testTvList, testTvList, testTvList)
    ],
    verify: (bloc) {
        verify(mockGetPopularTvs.execute());
        verify(mockGetTopRatedTv.execute());
        verify(mockGetTvOnAir.execute());
    }
  );

  blocTest(
      "Should emit [Loading, Error] state when get list data unsuccessfull",
      build: () {
        when(mockGetPopularTvs.execute())
            .thenAnswer((realInvocation) async => Left(ServerFailure("Error")));
        when(mockGetTopRatedTv.execute())
            .thenAnswer((realInvocation) async => Left(ServerFailure("Error")));
        when(mockGetTvOnAir.execute())
            .thenAnswer((realInvocation) async => Left(ServerFailure("Error")));
        return tvListBloc;
      },
      act: (bloc) => bloc.add(const GetTvListEvent()),
      expect: () => [
        TvStateLoading(),
        TvStateError("Error"),
      ],
      verify: (bloc) {
        verify(mockGetPopularTvs.execute());
        verify(mockGetTopRatedTv.execute());
        verify(mockGetTvOnAir.execute());
      }
  );
}