import 'package:core/style/text_styles.dart';
import 'package:movie/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../bloc/movie_search_bloc.dart';
import '../provider/tv_search_notifier.dart';

class SearchTvPage extends StatelessWidget {
  static const ROUTE_NAME = '/tv/search';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onChanged: (query) {
                context.read<MovieSearchBloc>().add(OnQueryChanged(query));
              },
              decoration: InputDecoration(
                hintText: 'Search name',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.search,
            ),
            SizedBox(height: 16),
            Text(
              'Search Result',
              style: kHeading6,
            ),
            BlocBuilder<MovieSearchBloc, MovieSearchState>(
                builder: (context, state) {
                  if(state is SearchLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if(state is SearchHasData) {
                    final result = state.result;
                    return Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemBuilder: (context, index) {
                          final movie = result[index];
                          return MovieCard(movie);
                        },
                        itemCount: result.length,
                      ),
                    );
                  } else if (state is SearchError) {
                    return Expanded(
                      child: Center(
                        child: Text(state.message),
                      ),
                    );
                  } else {
                    return Expanded(
                      child: Container(),
                    );
                  }
                }
            ),
          ],
        ),
      ),
    );
  }
}
