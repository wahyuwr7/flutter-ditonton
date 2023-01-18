import 'package:dartz/dartz.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/usecases/get_tv_recomendation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetTvRecomendation usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = GetTvRecomendation(mockTvRepository);
  });

  final tId = 1;
  final tTvs = <Tv>[];

  test('should get list of tv recommendations from the repository',
      () async {
    // arrange
    when(mockTvRepository.getTvRecommendations(tId))
        .thenAnswer((_) async => Right(tTvs));
    // act
    final result = await usecase.execute(tId);
    // assert
    expect(result, Right(tTvs));
  });
}