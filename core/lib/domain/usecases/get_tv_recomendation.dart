import 'package:dartz/dartz.dart';
import 'package:core/domain/repositories/tv_repository.dart';

import '../../utils/failure.dart';
import '../entities/tv.dart';

class GetTvRecomendation {
  final TvRepository repository;

  GetTvRecomendation(this.repository);

  Future<Either<Failure, List<Tv>>> execute(int id) {
    return repository.getTvRecommendations(id);
  }
}
