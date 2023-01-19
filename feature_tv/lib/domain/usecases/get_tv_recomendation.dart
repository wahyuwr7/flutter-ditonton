import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:tv/domain/repositories/tv_repository.dart';
import '../entities/tv.dart';

class GetTvRecomendation {
  final TvRepository repository;

  GetTvRecomendation(this.repository);

  Future<Either<Failure, List<Tv>>> execute(int id) {
    return repository.getTvRecommendations(id);
  }
}
