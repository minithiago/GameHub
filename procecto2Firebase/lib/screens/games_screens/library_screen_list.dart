import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:procecto2/bloc/get_games_bloc.dart';
import 'package:procecto2/elements/error_element.dart';
import 'package:procecto2/elements/loader_element.dart';
import 'package:procecto2/model/game.dart';
import 'package:procecto2/model/game_response.dart';
import 'package:procecto2/providers/favorite_provider.dart';
import 'package:procecto2/screens/game_detail_screen.dart';
import 'package:procecto2/style/theme.dart' as Style;
import 'package:provider/provider.dart';

class LibraryScreenList extends StatefulWidget {
  @override
  _LibraryScreenListState createState() => _LibraryScreenListState();
}

class _LibraryScreenListState extends State<LibraryScreenList> {
  @override
  void initState() {
    super.initState();
    getGamesBloc.getGames();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<GameResponse>(
      stream: getGamesBloc.subject.stream,
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
    var favoriteGamesProvider = Provider.of<FavoriteGamesProvider>(context);
    var favoriteGames = favoriteGamesProvider.favoriteGames;
    List<GameModel> games = favoriteGames;

    if (games.isEmpty) {
      return Container(
        width: MediaQuery.of(context).size.width,
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
              children: <Widget>[
                Text(
                  "No game to show",
                  style: TextStyle(color: Colors.black45),
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
                            final begin = Offset(1.0, 0.0);
                            final end = Offset.zero;
                            final curve = Curves.ease;

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
                      padding:
                          EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
                      height: 150.0,
                      child: Row(
                        children: [
                          Hero(
                            tag: games[index].id,
                            child: AspectRatio(
                              aspectRatio: 3 / 4,
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0)),
                                    image: DecorationImage(
                                        image: NetworkImage(
                                          "https://images.igdb.com/igdb/image/upload/t_cover_big/${games[index].cover!.imageId}.jpg",
                                        ),
                                        fit: BoxFit.cover)),
                              ),
                            ),
                          ),
                          SizedBox(
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
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 14.0),
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text(
                                      games[index].summary,
                                      maxLines: 4,
                                      style: TextStyle(
                                          color: Colors.white.withOpacity(0.2),
                                          fontSize: 12.0),
                                    )
                                  ],
                                ),
                                /*
                                Row(
                                  children: [
                                    RatingBar.builder(
                                      itemSize: 8.0,
                                      initialRating:
                                          games[index].total_rating / 20,
                                      minRating: 1,
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      itemPadding:
                                          EdgeInsets.symmetric(horizontal: 2.0),
                                      itemBuilder: (context, _) => Icon(
                                        EvaIcons.star,
                                        color: Style.Colors.starsColor,
                                      ),
                                      onRatingUpdate: (rating) {
                                        print(rating);
                                      },
                                    ),
                                    SizedBox(
                                      width: 3.0,
                                    ),
                                    Text(
                                      (games[index].total_rating / 20)
                                          .toString()
                                          .substring(0, 3),
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12.0),
                                    )
                                  ],
                                )*/
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
