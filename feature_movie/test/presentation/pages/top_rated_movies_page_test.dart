import 'package:bloc_test/bloc_test.dart';
import 'package:core/utils/state_enum.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:movie/presentation/bloc/movie_detail_bloc/movie_detail_bloc.dart';
import 'package:movie/presentation/bloc/movie_event.dart';
import 'package:movie/presentation/bloc/movie_state.dart';
import 'package:movie/presentation/pages/movie_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../dummy_data/dummy_objects.dart';

class MovieDetailEventFake extends Fake
    implements MovieEvent {}

class MovieDetailStateFake extends Fake
    implements MovieState {}

class MockMovieDetailBloc
    extends MockBloc<MovieDetailEvent, MovieDetailState>
    implements MovieDetailBloc {}

void main() {
  late MockMovieDetailBloc mockMovieDetailBloc;

  setUpAll(() {
    registerFallbackValue(MovieDetailEventFake());
    registerFallbackValue(MovieDetailStateFake());
  });

  setUp(() {
    mockMovieDetailBloc = MockMovieDetailBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<MovieDetailBloc>.value(
      value: mockMovieDetailBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }
  testWidgets(
      'Watchlist button should display add icon when movie not added to watchlist',
          (WidgetTester tester) async {
        when(() => mockMovieDetailBloc.state).thenReturn(
            MovieDetailState.init().replace(
                movie: testMovieDetail,
                recommendations: testMovieList,
                state: RequestState.Loaded,
                watchlistStatus: false
            )
        );

        final watchlistButtonIcon = find.byIcon(Icons.add);

        await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

        expect(watchlistButtonIcon, findsOneWidget);
      });

  testWidgets(
      'Watchlist button should dispay check icon when movie is added to wathclist',
          (WidgetTester tester) async {
        when(() => mockMovieDetailBloc.state).thenReturn(
            MovieDetailState.init().replace(
                movie: testMovieDetail,
                recommendations: testMovieList,
                state: RequestState.Loaded,
                watchlistStatus: true
            )
        );

        final watchlistButtonIcon = find.byIcon(Icons.check);

        await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

        expect(watchlistButtonIcon, findsOneWidget);
      });

  testWidgets(
      'Watchlist button should display Snackbar when added to watchlist',
          (WidgetTester tester) async {
        when(() => mockMovieDetailBloc.state).thenReturn(
            MovieDetailState.init().replace(
                movie: testMovieDetail,
                recommendations: testMovieList,
                state: RequestState.Loaded,
                watchlistStatus: true
            )
        );

        final watchlistButton = find.byType(ElevatedButton);

        await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

        await tester.tap(watchlistButton);
        await tester.pump();

        expect(find.byIcon(Icons.check), findsOneWidget);
      });

  testWidgets(
      'Watchlist button should display AlertDialog when add to watchlist failed',
          (WidgetTester tester) async {
        when(() => mockMovieDetailBloc.state).thenReturn(
            MovieDetailState.init().replace(
                movie: testMovieDetail,
                recommendations: testMovieList,
                state: RequestState.Loaded,
                watchlistStatus: false
            )
        );

        final watchlistButton = find.byType(ElevatedButton);

        await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

        expect(find.byIcon(Icons.add), findsOneWidget);

        await tester.tap(watchlistButton);
        await tester.pump();

        expect(find.byIcon(Icons.add), findsOneWidget);
      });
}
