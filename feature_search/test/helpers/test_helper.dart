import 'package:movie/domain/repositories/movie_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:tv/domain/repositories/tv_repository.dart';

@GenerateMocks([
  MovieRepository,
  TvRepository
])
void main() {}
