import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/presentation/bloc/tv_event.dart';
import 'package:tv/presentation/bloc/tv_on_air_bloc/tv_on_air_bloc.dart';
import 'package:tv/presentation/bloc/tv_popular_bloc/tv_popular_bloc.dart';
import 'package:tv/presentation/bloc/tv_state.dart';
import 'package:tv/presentation/bloc/tv_top_rated_bloc/tv_top_rated_bloc.dart';
import '../../../dummy_data/dummy_objects.dart';
import '../../provider/tv_list_notifier_test.mocks.dart';

void main() {
  late MockGetTopRatedTv mockGetTvTopRated;
  late TvTopRatedBloc tvTopRatedMock;

  setUp(() {
    mockGetTvTopRated = MockGetTopRatedTv();
    tvTopRatedMock = TvTopRatedBloc(mockGetTvTopRated);
  });

  test("Should initial state is TvStateEmpty()", () {
    expect(tvTopRatedMock.state, TvStateEmpty());
  });

  blocTest(
      "Should emit [Loading, HashListData] state when success get list data",
      build: () {
        when(mockGetTvTopRated.execute())
            .thenAnswer((realInvocation) async => Right(testTvList));
        return tvTopRatedMock;
      },
    act: (bloc) => bloc.add(const GetTvTopRatedEvent()),
    expect: () => [
      TvStateLoading(),
      TvStateHasData(testTvList)
    ],
    verify: (bloc) {
        verify(mockGetTvTopRated.execute());
    }
  );

  blocTest(
      "Should emit [Loading, Error] state when get list data unsuccessfull",
      build: () {
        when(mockGetTvTopRated.execute())
            .thenAnswer((realInvocation) async => Left(ServerFailure("Error")));
        return tvTopRatedMock;
      },
      act: (bloc) => bloc.add(const GetTvTopRatedEvent()),
      expect: () => [
        TvStateLoading(),
        TvStateError("Error"),
      ],
      verify: (bloc) {
        verify(mockGetTvTopRated.execute());
      }
  );
}