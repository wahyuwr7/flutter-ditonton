import 'package:bloc_test/bloc_test.dart';
import 'package:core/utils/state_enum.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/presentation/bloc/tv_event.dart';
import 'package:tv/presentation/bloc/tv_state.dart';
import 'package:tv/presentation/bloc/tv_top_rated_bloc/tv_top_rated_bloc.dart';
import 'package:tv/presentation/pages/tv_top_rated_page.dart';
import 'package:tv/presentation/provider/top_rated_tv_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../dummy_data/dummy_objects.dart';

class TvEventFake extends Fake
    implements TvEvent {}

class TvStateFake extends Fake
    implements TvState {}

class MockTvTopRatedBloc
    extends MockBloc<TvEvent, TvState>
    implements TvTopRatedBloc {}

void main() {
  late MockTvTopRatedBloc mockTvTopRatedBloc;

  setUpAll(() {
    registerFallbackValue(TvEventFake());
    registerFallbackValue(TvStateFake());
  });

  setUp(() {
    mockTvTopRatedBloc = MockTvTopRatedBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<TvTopRatedBloc>.value(
      value: mockTvTopRatedBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display progress bar when loading',
      (WidgetTester tester) async {
    when(() => mockTvTopRatedBloc.state).thenReturn(TvStateLoading());

    final progressFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(TvTopRatedPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressFinder, findsOneWidget);
  });

  testWidgets('Page should display when data is loaded',
      (WidgetTester tester) async {
    when(() => mockTvTopRatedBloc.state).thenReturn(TvStateHasData(testTvList));

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(TvTopRatedPage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(()=> mockTvTopRatedBloc.state).thenReturn(TvStateError("error message"));

    final textFinder = find.byKey(Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget(TvTopRatedPage()));

    expect(textFinder, findsOneWidget);
  });
}
