import 'package:bloc_test/bloc_test.dart';
import 'package:core/utils/state_enum.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:movie/presentation/bloc/movie_event.dart';
import 'package:movie/presentation/bloc/movie_state.dart';
import 'package:movie/presentation/bloc/movie_top_rated_bloc/movie_top_rated_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/presentation/pages/top_rated_movies_page.dart';

import '../../dummy_data/dummy_objects.dart';

class MovieEventFake extends Fake
    implements MovieEvent {}

class MovieStateFake extends Fake
    implements MovieState {}

class MockMovieTopRatedBloc
    extends MockBloc<MovieEvent, MovieState>
    implements MovieTopRatedBloc {}

void main() {
  late MockMovieTopRatedBloc mockMovieTopRatedBloc;

  setUpAll(() {
    registerFallbackValue(MovieEventFake());
    registerFallbackValue(MovieStateFake());
  });

  setUp(() {
    mockMovieTopRatedBloc = MockMovieTopRatedBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<MovieTopRatedBloc>.value(
      value: mockMovieTopRatedBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display progress bar when loading',
          (WidgetTester tester) async {
        when(() => mockMovieTopRatedBloc.state).thenReturn(MovieStateLoading());

        final progressFinder = find.byType(CircularProgressIndicator);
        final centerFinder = find.byType(Center);

        await tester.pumpWidget(_makeTestableWidget(TopRatedMoviesPage()));

        expect(centerFinder, findsOneWidget);
        expect(progressFinder, findsOneWidget);
      });

  testWidgets('Page should display when data is loaded',
          (WidgetTester tester) async {
        when(() => mockMovieTopRatedBloc.state).thenReturn(MovieStateHasData(testMovieList));

        final listViewFinder = find.byType(ListView);

        await tester.pumpWidget(_makeTestableWidget(TopRatedMoviesPage()));

        expect(listViewFinder, findsOneWidget);
      });

  testWidgets('Page should display text with message when Error',
          (WidgetTester tester) async {
        when(()=> mockMovieTopRatedBloc.state).thenReturn(MovieStateError("error message"));

        final textFinder = find.byKey(Key('error_message'));

        await tester.pumpWidget(_makeTestableWidget(TopRatedMoviesPage()));

        expect(textFinder, findsOneWidget);
      });
}
