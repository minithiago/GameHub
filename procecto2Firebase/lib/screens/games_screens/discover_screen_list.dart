import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:procecto2/bloc/get_games_bloc.dart';
import 'package:procecto2/elements/error_element.dart';
import 'package:procecto2/elements/loader_element.dart';
import 'package:procecto2/model/game.dart';
import 'package:procecto2/model/game_response.dart';
import 'package:procecto2/screens/game_detail_screen.dart';
import 'package:procecto2/services/switch_games.dart';
import 'package:provider/provider.dart';

class DiscoverScreenList extends StatefulWidget {
  @override
  _DiscoverScreenListState createState() => _DiscoverScreenListState();
}

class _DiscoverScreenListState extends State<DiscoverScreenList> {
  @override
  void initState() {
    super.initState();
    getGamesBloc2.getGames2();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<GameResponse>(
      stream: getGamesBloc2.subject.stream,
      builder: (context, AsyncSnapshot<GameResponse> snapshot) {
        if (snapshot.hasData) {
          final gameResponse = snapshot.data;
          if (gameResponse != null && gameResponse.error.isNotEmpty) {
            return buildErrorWidget(gameResponse.error);
          } else {
            return _buildGameListWidget(gameResponse!);
          }
        } else if (snapshot.hasError) {
          return buildErrorWidget(snapshot.error.toString());
        } else {
          return buildLoadingWidget();
        }
      },
    );
  }

  Widget _buildGameListWidget(GameResponse data) {
    List<GameModel> games = data.games;
    if (games.isEmpty) {
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
              children: <Widget>[
                Text(
                  "No game to show",
                  style: TextStyle(
                      //color: Colors.black45
                      ),
                )
              ],
            )
          ],
        ),
      );
    } else {
      return AnimationLimiter(
        child: ListView.builder(
          itemCount: games.length,
          itemBuilder: (BuildContext context, int index) {
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 400),
              child: SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  GameDetailScreen(
                            key: const Key("game_detail_screen_key"),
                            game: games[index],
                          ),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            const begin = Offset(1.0, 0.0);
                            const end = Offset.zero;
                            const curve = Curves.ease;

                            var tween = Tween(begin: begin, end: end)
                                .chain(CurveTween(curve: curve));
                            var offsetAnimation = animation.drive(tween);

                            return SlideTransition(
                              position: offsetAnimation,
                              child: child,
                            );
                          },
                          transitionDuration: const Duration(milliseconds: 300),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.only(
                          top: 15.0, left: 10.0, right: 10.0),
                      height: 150.0,
                      child: Row(
                        children: [
                          Hero(
                            tag: games[index].id,
                            child: AspectRatio(
                              aspectRatio: 3 / 4,
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5.0)),
                                    image: DecorationImage(
                                        image: NetworkImage(
                                          "https://images.igdb.com/igdb/image/upload/t_cover_big/${games[index].cover!.imageId}.jpg",
                                        ),
                                        fit: BoxFit.cover)),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      games[index].name,
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: false,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          //color: Colors.white,
                                          fontSize: 14.0),
                                    ),
                                    const SizedBox(
                                      height: 5.0,
                                    ),
                                    Text(
                                      games[index].summary,
                                      maxLines: 4,
                                      style: const TextStyle(
                                          //color: Colors.white.withOpacity(0.4),
                                          fontSize: 12.0),
                                    )
                                  ],
                                ),
                                Consumer<SwitchState>(
                                  builder: (context, switchState, child) {
                                    if (switchState.isSwitchedOn) {
                                      return Stack(
                                        children: [
                                          Row(
                                            children: [
                                              RatingBar.builder(
                                                itemSize: 10.0,
                                                initialRating:
                                                    games[index].total_rating /
                                                        20,
                                                minRating: 1,
                                                direction: Axis.horizontal,
                                                allowHalfRating: true,
                                                //glow: true,

                                                itemCount: 5,
                                                itemPadding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 2.0),
                                                itemBuilder: (context, _) =>
                                                    const Icon(
                                                  EvaIcons.star,
                                                  color: Colors.yellow,
                                                  //size: 40,
                                                ),
                                                onRatingUpdate: (rating) {
                                                  //print(rating);
                                                },
                                              ),
                                              const SizedBox(
                                                width: 3.0,
                                              ),
                                              Text(
                                                (games[index].total_rating / 20)
                                                    .toString()
                                                    .substring(0, 3),
                                                style: const TextStyle(
                                                    //color: Colors.white,
                                                    fontSize: 12.0),
                                              )
                                            ],
                                          )
                                        ],
                                      );
                                    } else {
                                      return Container(); // O cualquier otro widget
                                    }
                                  },
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      );
    }
  }
}
