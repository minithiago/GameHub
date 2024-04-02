import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:procecto2/bloc/get_games_bloc.dart';
import 'package:procecto2/elements/error_element.dart';
import 'package:procecto2/elements/loader_element.dart';
import 'package:procecto2/model/game.dart';
import 'package:procecto2/model/game_response.dart';
import 'package:procecto2/style/theme.dart' as Style;

import '../game_detail_screen.dart';

class SearchScreenGrid extends StatefulWidget {
  String query = "";

  SearchScreenGrid(this.query);

  @override
  _SearchScreenGridState createState() => _SearchScreenGridState();
}

class _SearchScreenGridState extends State<SearchScreenGrid> {
  @override
  void initState() {
    getGamesBloc.getSearchedGames(widget.query);
    super.initState();
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
            return _buildGameGridWidget(gameResponse!);
          }
        } else if (snapshot.hasError) {
          return buildErrorWidget(snapshot.error.toString());
        } else {
          return buildLoadingWidget();
        }
      },
    );
  }

  Widget _buildGameGridWidget(GameResponse data) {
    List<GameModel> games = data.games;

    return AnimationLimiter(
      child: AnimationLimiter(
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
          child: GridView.count(
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
            childAspectRatio: 0.75,
            crossAxisCount: 3, //columnas
            children: List.generate(
              games.length,
              (int index) {
                return AnimationConfiguration.staggeredGrid(
                  position: index,
                  duration: const Duration(milliseconds: 375),
                  columnCount: 3,
                  child: ScaleAnimation(
                    child: FadeInAnimation(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GameDetailScreen(
                                key: const Key(
                                    "game_detail_screen_key"), // Puedes proporcionar una clave única aquí
                                game: games[index],
                              ),
                            ),
                          );
                        },
                        child: Stack(
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
                            AspectRatio(
                              aspectRatio: 3 / 4,
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5.0)),
                                    gradient: LinearGradient(
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                        colors: [
                                          Colors.black.withOpacity(0.8),
                                          Colors.black.withOpacity(0.0)
                                        ],
                                        stops: const [
                                          0.0,
                                          0.5
                                        ])),
                              ),
                            ),
                            Positioned(
                              bottom: 20.0,
                              left: 5.0,
                              child: Container(
                                width: 90.0,
                                child: Text(
                                  games[index].name,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 5.0,
                              left: 5.0,
                              child: Row(
                                children: [
                                  RatingBar.builder(
                                    itemSize: 8.0,
                                    initialRating: games[index].rating / 20,
                                    minRating: 0,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    itemCount: 5,
                                    itemPadding: const EdgeInsets.symmetric(
                                        horizontal: 2.0),
                                    itemBuilder: (context, _) => const Icon(
                                      EvaIcons.star,
                                      color: Style.Colors.starsColor,
                                    ),
                                    onRatingUpdate: (rating) {
                                      print(rating);
                                    },
                                  ),
                                  const SizedBox(
                                    width: 3.0,
                                  ),
                                  Text(
                                    (games[index].rating / 20)
                                        .toString()
                                        .substring(0, 3),
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10.0,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
