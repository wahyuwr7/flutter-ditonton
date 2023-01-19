import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/style/colors.dart';
import 'package:core/style/text_styles.dart';
import 'package:core/utils/state_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:tv/presentation/bloc/tv_detail_bloc/tv_detail_bloc.dart';
import 'package:tv/presentation/bloc/tv_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/presentation/bloc/tv_state.dart';
import '../../domain/entities/tv.dart';
import '../../domain/entities/tv_detail.dart';
import '../provider/tv_detail_notifier.dart';


class TvDetailPage extends StatefulWidget {
  static const ROUTE_NAME = '/tv/detail';

  final int id;
  TvDetailPage({required this.id});

  @override
  _TvDetailPageState createState() => _TvDetailPageState();
}

class _TvDetailPageState extends State<TvDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<TvDetailBloc>().add(FetchingDetailData(widget.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<TvDetailBloc, TvDetailState>(
        builder: (context, state) {
          if (state.state == RequestState.Loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state.state == RequestState.Loaded) {
            final tv = state.tv;
            return SafeArea(
              child: DetailContent(
                tv!,
                state.recommendations,
                state.watchlistStatus,
                state.message
              ),
            );
          } else if(state.state == RequestState.Error) {
            return Text(state.message);
          } else {
            return const Text("Unknown Error");
          }
        },
      ),
    );
  }
}

class DetailContent extends StatefulWidget {
  final TvDetail tv;
  final List<Tv> recommendations;
  final bool isAddedWatchlist;
  final message;

  DetailContent(this.tv, this.recommendations, this.isAddedWatchlist, this.message);

  @override
  State<DetailContent> createState() => _DetailContentState();
}

class _DetailContentState extends State<DetailContent> {

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: 'https://image.tmdb.org/t/p/w500${widget.tv.posterPath}',
          width: screenWidth,
          placeholder: (context, url) => Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
        Container(
          margin: const EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: kRichBlack,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                padding: const EdgeInsets.only(
                  left: 16,
                  top: 16,
                  right: 16,
                ),
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.tv.name,
                              style: kHeading5,
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                if (!widget.isAddedWatchlist) {
                                  context.read<TvDetailBloc>().add(AddingToWatchlist(widget.tv));
                                } else {
                                  context.read<TvDetailBloc>().add(RemovingFromWatchlist(widget.tv));
                                }
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  widget.isAddedWatchlist
                                      ? Icon(Icons.check)
                                      : Icon(Icons.add),
                                  Text('Watchlist'),
                                ],
                              ),
                            ),
                            Text(
                              _showGenres(widget.tv.genres),
                            ),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: widget.tv.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${widget.tv.voteAverage}')
                              ],
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Overview',
                              style: kHeading6,
                            ),
                            Text(
                              widget.tv.overview,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Recommendations',
                              style: kHeading6,
                            ),
                        widget.recommendations.length == 0
                        ? Container()
                        : Container(
                          height: 150,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              final tv = widget.recommendations[index];
                              return Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pushReplacementNamed(
                                      context,
                                      TvDetailPage.ROUTE_NAME,
                                      arguments: tv.id,
                                    );
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8),
                                    ),
                                    child: CachedNetworkImage(
                                      imageUrl:
                                      'https://image.tmdb.org/t/p/w500${tv.posterPath}',
                                      placeholder: (context, url) =>
                                          Center(
                                            child:
                                            CircularProgressIndicator(),
                                          ),
                                      errorWidget:
                                          (context, url, error) =>
                                          Icon(Icons.error),
                                    ),
                                  ),
                                ),
                              );
                            },
                            itemCount: widget.recommendations.length,
                          ),
                        )
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        color: Colors.white,
                        height: 4,
                        width: 48,
                      ),
                    ),
                  ],
                ),
              );
            },
            // initialChildSize: 0.5,
            minChildSize: 0.25,
            // maxChildSize: 1.0,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: kRichBlack,
            foregroundColor: Colors.white,
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        )
      ],
    );
  }

  String _showGenres(List<TvGenre> genres) {
    String result = '';
    for (var genre in genres) {
      result += genre.name + ', ';
    }

    if (result.isEmpty) {
      return result;
    }

    return result.substring(0, result.length - 2);
  }

  String _showDuration(int runtime) {
    final int hours = runtime ~/ 60;
    final int minutes = runtime % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }
}
