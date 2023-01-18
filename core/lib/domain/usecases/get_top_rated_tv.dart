import 'package:dartz/dartz.dart';
import 'package:core/domain/repositories/tv_repository.dart';

import '../../utils/failure.dart';
import '../entities/tv.dart';

class GetTopRatedTv {
  final TvRepository repository;

  GetTopRatedTv(this.repository);

  Future<Either<Failure, List<Tv>>> execute() {
    return repository.getTopRatedTv();
  }
}
