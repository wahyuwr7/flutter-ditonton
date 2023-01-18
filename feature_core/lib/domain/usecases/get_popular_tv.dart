import 'package:dartz/dartz.dart';
import 'package:core/domain/repositories/tv_repository.dart';

import '../../utils/failure.dart';
import '../entities/tv.dart';

class GetPopularTvs {
  final TvRepository repository;

  GetPopularTvs(this.repository);

  Future<Either<Failure, List<Tv>>> execute() {
    return repository.getPopularTv();
  }
}