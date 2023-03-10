import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:tv/domain/entities/tv_detail.dart';
import '../entities/tv.dart';

abstract class TvRepository {
  Future<Either<Failure, List<Tv>>> getTvOnAir();
  Future<Either<Failure, List<Tv>>> getPopularTv();
  Future<Either<Failure, List<Tv>>> getTopRatedTv();
  Future<Either<Failure, TvDetail>> getTvDetail(int id);
  Future<Either<Failure, List<Tv>>> getTvRecommendations(int id);
  Future<Either<Failure, List<Tv>>> searchTv(String query);
  Future<Either<Failure, String>> saveWatchlist(TvDetail tv);
  Future<Either<Failure, String>> removeWatchlist(TvDetail tv);
  Future<bool> isAddedToWatchlist(int id);
  Future<Either<Failure, List<Tv>>> getWatchlistTv();
}