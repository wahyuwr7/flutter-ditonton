import 'package:dartz/dartz.dart';
import 'package:core/utils/failure.dart';
import 'package:tv/domain/repositories/tv_repository.dart';

import '../entities/tv.dart';

class GetWatchlistTv {
  final TvRepository _repository;

  GetWatchlistTv(this._repository);

  Future<Either<Failure, List<Tv>>> execute() {
    return _repository.getWatchlistTv();
  }
}
