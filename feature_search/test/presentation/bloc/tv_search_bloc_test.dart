import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:search/domain/usecases/search_tv.dart';
import 'package:search/presentation/bloc/tv_search_bloc.dart';

import '../provider/tv_search_notifier_test.mocks.dart';

@GenerateMocks([SearchTv])
void main() {
  late TvSearchBloc searchBloc;
  late MockSearchTv mockSearchTv;

  setUp(() {
    mockSearchTv = MockSearchTv();
    searchBloc = TvSearchBloc(mockSearchTv);
  });

  final tTvModel = Tv(
    backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
    genreIds: const [14, 28],
    id: 557,
    overview:
    'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
    popularity: 60.441,
    posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
    voteAverage: 7.2,
    voteCount: 13507,
    firstAirDate: '2022-10-10',
    name: 'name',
    originCountry: const ['EN'],
    originalLanguage: 'language',
    originalName: 'name',
  );

  final tTvList = <Tv>[tTvModel];

  const tQuery = 'wednesday';

  test('initial state should be empty', () {
    expect(searchBloc.state, SearchEmpty());
  });

  blocTest<TvSearchBloc, TvSearchState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockSearchTv.execute(tQuery))
          .thenAnswer((_) async => Right(tTvList));
      return searchBloc;
    },
    act: (bloc) => bloc.add(const OnQueryChanged(tQuery)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      SearchLoading(),
      SearchHasData(tTvList),
    ],
    verify: (bloc) {
      verify(mockSearchTv.execute(tQuery));
    },
  );

  blocTest<TvSearchBloc, TvSearchState>(
    'Should emit [Loading, Error] when get search is unsuccessful',
    build: () {
      when(mockSearchTv.execute(tQuery))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return searchBloc;
    },
    act: (bloc) => bloc.add(const OnQueryChanged(tQuery)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      SearchLoading(),
      const SearchError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockSearchTv.execute(tQuery));
    },
  );
}