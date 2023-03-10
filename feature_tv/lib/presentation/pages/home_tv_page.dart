import 'package:cached_network_image/cached_network_image.dart';
import 'package:about/about.dart';
import 'package:core/core.dart';
import 'package:core/utils/routes.dart';
import 'package:tv/presentation/bloc/tv_event.dart';
import 'package:tv/presentation/pages/tv_detail_page.dart';
import 'package:tv/presentation/pages/tv_on_air_page.dart';
import 'package:tv/presentation/pages/tv_popular_page.dart';
import 'package:tv/presentation/pages/tv_top_rated_page.dart';
import 'package:tv/presentation/pages/watchlist_tv_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/tv.dart';
import '../bloc/tv_list_bloc/tv_list_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/tv_state.dart';

class HomeTvPage extends StatefulWidget {
  static const ROUTE_NAME = '/tv/home';
  @override
  _HomeTvPageState createState() => _HomeTvPageState();
}

class _HomeTvPageState extends State<HomeTvPage> {
  @override
  void initState() {
    super.initState();
    context.read<TvListBloc>().add(const GetTvListEvent());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            const UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/circle-g.png'),
              ),
              accountName: Text('Ditonton'),
              accountEmail: Text('tv@dicoding.com'),
            ),
            ListTile(
              leading: Icon(Icons.movie),
              title: Text('Movies'),
              onTap: () {
                Navigator.pushReplacementNamed(context, MOVIE_ROUTE + HOME_ROUTE);
              },
            ),
            ListTile(
              leading: Icon(Icons.tv),
              title: Text('Tv Show'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.save_alt),
              title: Text('Watchlist Movie'),
              onTap: () {
                Navigator.pushNamed(context, MOVIE_ROUTE + WATCHLIST_ROUTE);
              },
            ),
            ListTile(
              leading: Icon(Icons.save_alt),
              title: Text('Watchlist Tv Show'),
              onTap: () {
                Navigator.pushNamed(context, WatchlistTvsPage.ROUTE_NAME);
              },
            ),
            ListTile(
              onTap: () {
                Navigator.pushNamed(context, AboutPage.ROUTE_NAME);
              },
              leading: Icon(Icons.info_outline),
              title: Text('About'),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Tv Show'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, TV_ROUTE + SEARCH_ROUTE);
            },
            icon: Icon(Icons.search),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSubHeading(
                title: 'On The Air',
                onTap: () =>
                    Navigator.pushNamed(context, TvOnAirPage.ROUTE_NAME),
              ),
              BlocBuilder<TvListBloc, TvState>(
                  builder: (context, state) {
                if (state is TvStateLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is TvStateHasListData) {
                  final data = state.onAir;
                  return TvList(data);
                } else {
                  return const Text('Failed');
                }
              }),
              _buildSubHeading(
                title: 'Popular',
                onTap: () =>
                    Navigator.pushNamed(context, TvPopularPage.ROUTE_NAME),
              ),
              BlocBuilder<TvListBloc, TvState>(
                  builder: (context, state) {
                    if (state is TvStateLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (state is TvStateHasListData) {
                      final data = state.popular;
                      return TvList(data);
                    } else {
                      return const Text('Failed');
                    }
                  }),
              _buildSubHeading(
                title: 'Top Rated',
                onTap: () =>
                    Navigator.pushNamed(context, TvTopRatedPage.ROUTE_NAME),
              ),
              BlocBuilder<TvListBloc, TvState>(
                  builder: (context, state) {
                    if (state is TvStateLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (state is TvStateHasListData) {
                      final data = state.topRated;
                      return TvList(data);
                    } else {
                      return const Text('Failed');
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Row _buildSubHeading({required String title, required Function() onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: kHeading6,
        ),
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [Text('See More'), Icon(Icons.arrow_forward_ios)],
            ),
          ),
        ),
      ],
    );
  }
}

class TvList extends StatelessWidget {
  final List<Tv> tvs;

  TvList(this.tvs);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final movie = tvs[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  TvDetailPage.ROUTE_NAME,
                  arguments: movie.id,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${movie.posterPath}',
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: tvs.length,
      ),
    );
  }
}
