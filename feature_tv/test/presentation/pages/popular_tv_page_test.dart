import 'package:bloc_test/bloc_test.dart';
import 'package:tv/presentation/bloc/tv_event.dart';
import 'package:tv/presentation/bloc/tv_popular_bloc/tv_popular_bloc.dart';
import 'package:tv/presentation/bloc/tv_state.dart';
import 'package:tv/presentation/pages/tv_popular_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../dummy_data/dummy_objects.dart';

class TvEventFake extends Fake
    implements TvEvent {}

class TvStateFake extends Fake
    implements TvState {}

class MockTvPopularBloc
    extends MockBloc<TvEvent, TvState>
    implements TvPopularBloc {}

void main() {
  late MockTvPopularBloc mockTvPopularBloc;

  setUpAll(() {
    registerFallbackValue(TvEventFake());
    registerFallbackValue(TvStateFake());
  });

  setUp(() {
    mockTvPopularBloc = MockTvPopularBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<TvPopularBloc>.value(
      value: mockTvPopularBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    when(() => mockTvPopularBloc.state).thenReturn(TvStateLoading());

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(TvPopularPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    when(() => mockTvPopularBloc.state).thenReturn(TvStateHasData(testTvList));

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(TvPopularPage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(() => mockTvPopularBloc.state).thenReturn(TvStateError("Error message"));

    final textFinder = find.byKey(Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget(TvPopularPage()));

    expect(textFinder, findsOneWidget);
  });
}
