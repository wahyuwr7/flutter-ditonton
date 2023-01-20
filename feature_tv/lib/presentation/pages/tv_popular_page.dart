import 'package:core/utils/state_enum.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tv/presentation/bloc/tv_event.dart';
import 'package:tv/presentation/bloc/tv_popular_bloc/tv_popular_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/presentation/bloc/tv_state.dart';
import '../provider/popular_tv_notifier.dart';
import '../widgets/tv_card_list.dart';

class TvPopularPage extends StatefulWidget {
  static const ROUTE_NAME = '/tv/popular';

  @override
  _TvPopularPageState createState() => _TvPopularPageState();
}

class _TvPopularPageState extends State<TvPopularPage> {
  @override
  void initState() {
    super.initState();
    context.read<TvPopularBloc>().add(const GetTvPopularEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TV Show Popular'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TvPopularBloc, TvState>(
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
            } else if(state is TvStateError){
              return Center(
                key: const Key('error_message'),
                child: Text(state.message),
              );
            } else {
              return const Center(
                child: Text("Unknown Error"),
              );
            }
          },
        ),
      ),
    );
  }
}
