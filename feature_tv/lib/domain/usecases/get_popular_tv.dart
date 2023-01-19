import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:tv/domain/repositories/tv_repository.dart';

import '../entities/tv.dart';

class GetPopularTvs {
  final TvRepository repository;

  GetPopularTvs(this.repository);

  Future<Either<Failure, List<Tv>>> execute() {
    return repository.getPopularTv();
  }
}
