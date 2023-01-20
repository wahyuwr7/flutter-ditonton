import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/presentation/bloc/tv_event.dart';
import 'package:tv/presentation/bloc/tv_on_air_bloc/tv_on_air_bloc.dart';
import 'package:tv/presentation/bloc/tv_state.dart';
import '../../../dummy_data/dummy_objects.dart';
import '../../provider/tv_list_notifier_test.mocks.dart';

void main() {
  late MockGetTvOnAir mockGetTvOnAir;
  late OnAirBloc tvOnAirMock;

  setUp(() {
    mockGetTvOnAir = MockGetTvOnAir();
    tvOnAirMock = OnAirBloc(mockGetTvOnAir);
  });

  test("Should initial state is TvStateEmpty()", () {
    expect(tvOnAirMock.state, TvStateEmpty());
  });

  blocTest(
      "Should emit [Loading, HashListData] state when success get list data",
      build: () {
        when(mockGetTvOnAir.execute())
            .thenAnswer((realInvocation) async => Right(testTvList));
        return tvOnAirMock;
      },
    act: (bloc) => bloc.add(const GetOnAirEvent()),
    expect: () => [
      TvStateLoading(),
      TvStateHasData(testTvList)
    ],
    verify: (bloc) {
        verify(mockGetTvOnAir.execute());
    }
  );

  blocTest(
      "Should emit [Loading, Error] state when get list data unsuccessfull",
      build: () {
        when(mockGetTvOnAir.execute())
            .thenAnswer((realInvocation) async => Left(ServerFailure("Error")));
        return tvOnAirMock;
      },
      act: (bloc) => bloc.add(const GetOnAirEvent()),
      expect: () => [
        TvStateLoading(),
        TvStateError("Error"),
      ],
      verify: (bloc) {
        verify(mockGetTvOnAir.execute());
      }
  );
}