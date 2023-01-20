import 'package:flutter/material.dart';
import 'package:tv/presentation/bloc/tv_on_air_bloc/tv_on_air_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/tv_event.dart';
import '../bloc/tv_state.dart';
import '../widgets/tv_card_list.dart';

class TvOnAirPage extends StatefulWidget {
  static const ROUTE_NAME = '/tv/on-the-air';

  @override
  _TvOnAirPageState createState() => _TvOnAirPageState();
}

class _TvOnAirPageState extends State<TvOnAirPage> {
  @override
  void initState() {
    super.initState();
    context.read<OnAirBloc>().add(const GetOnAirEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TV Show On the Air'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<OnAirBloc, TvState>(
          builder: (context, state) {
            if (state is TvStateLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is TvStateHasData) {
              final data = state.result;
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tv = data[index];
                  return TvChard(tv);
                },
                itemCount: data.length,
              );
            } else if (state is TvStateError) {
              return Center(
                key: const Key('error_message'),
                child: Text(state.message),
              );
            } else {
              return const Center(
                child:  Text("Unknown Problem :("),
              );
            }
          },
        ),
      ),
    );
  }
}
