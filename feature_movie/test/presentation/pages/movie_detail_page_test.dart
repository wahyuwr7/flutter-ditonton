import 'package:bloc_test/bloc_test.dart';
import 'package:movie/presentation/bloc/movie_event.dart';
import 'package:movie/presentation/bloc/movie_popular_bloc/movie_popular_bloc.dart';
import 'package:movie/presentation/bloc/movie_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/presentation/pages/popular_movies_page.dart';

import '../../dummy_data/dummy_objects.dart';

class MovieEventFake extends Fake
    implements MovieEvent {}

class MovieStateFake extends Fake
    implements MovieState {}

class MockMoviePopularBloc
    extends MockBloc<MovieEvent, MovieState>
    implements MoviePopularBloc {}

void main() {
  late MockMoviePopularBloc mockMoviePopularBloc;

  setUpAll(() {
    registerFallbackValue(MovieEventFake());
    registerFallbackValue(MovieStateFake());
  });

  setUp(() {
    mockMoviePopularBloc = MockMoviePopularBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<MoviePopularBloc>.value(
      value: mockMoviePopularBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading',
          (WidgetTester tester) async {
        when(() => mockMoviePopularBloc.state).thenReturn(MovieStateLoading());

        final progressBarFinder = find.byType(CircularProgressIndicator);
        final centerFinder = find.byType(Center);

        await tester.pumpWidget(_makeTestableWidget(PopularMoviesPage()));

        expect(centerFinder, findsOneWidget);
        expect(progressBarFinder, findsOneWidget);
      });

  testWidgets('Page should display ListView when data is loaded',
          (WidgetTester tester) async {
        when(() => mockMoviePopularBloc.state).thenReturn(MovieStateHasData(testMovieList));

        final listViewFinder = find.byType(ListView);

        await tester.pumpWidget(_makeTestableWidget(PopularMoviesPage()));

        expect(listViewFinder, findsOneWidget);
      });

  testWidgets('Page should display text with message when Error',
          (WidgetTester tester) async {
        when(() => mockMoviePopularBloc.state).thenReturn(MovieStateError("Error message"));

        final textFinder = find.byKey(Key('error_message'));

        await tester.pumpWidget(_makeTestableWidget(PopularMoviesPage()));

        expect(textFinder, findsOneWidget);
      });
}
