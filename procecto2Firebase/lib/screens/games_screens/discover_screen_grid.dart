import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:procecto2/bloc/get_games_bloc.dart';
import 'package:procecto2/elements/error_element.dart';
import 'package:procecto2/elements/loader_element.dart';
import 'package:procecto2/model/game.dart';
import 'package:procecto2/model/game_response.dart';
import 'package:procecto2/providers/favorite_provider.dart';
import 'package:procecto2/style/theme.dart' as Style;
import 'package:provider/provider.dart';

import '../game_detail_screen.dart';

class DiscoverScreenGrid extends StatefulWidget {
  DiscoverScreenGrid({super.key});

  @override
  _DiscoverScreenGridState createState() => _DiscoverScreenGridState();
}

class _DiscoverScreenGridState extends State<DiscoverScreenGrid> {
  @override
  void initState() {
    getGamesBloc.getGames();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<GameResponse>(
      stream: getGamesBloc.subject.stream,
      builder: (context, AsyncSnapshot<GameResponse> snapshot) {
        if (snapshot.hasData) {
          final gameResponse = snapshot.data!;
          if (gameResponse.error.isNotEmpty) {
            return buildErrorWidget(gameResponse.error);
          } else {
            return _buildGameGridWidget(gameResponse);
          }
        } else if (snapshot.hasError) {
          return buildErrorWidget(snapshot.error.toString());
        } else {
          return buildLoadingWidget(
            //color: Colors.orange,
            //size: 6.0,
            //message:  'Loading...', 
          );
        }
      },
    );
  }

  Widget _buildGameGridWidget(GameResponse data) {
    var favoriteGamesProvider = Provider.of<FavoriteGamesProvider>(context);

    final List<String> favoriteGameNames =
        favoriteGamesProvider.favoriteGames.map((game) => game.name).toList();

    List<GameModel> games = data.games;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: 7.0,
          mainAxisSpacing: 7.0,
          childAspectRatio: 0.75,
          crossAxisCount: 3,
        ),
        itemCount: games.length,
        itemBuilder: (BuildContext context, int index) {
          GameModel game = games[index];
          return GestureDetector(
            onLongPress: () {
              HapticFeedback.lightImpact();
              showCupertinoModalPopup(
                context: context,
                builder: (context) {
                  return CupertinoActionSheet(
                    actions: <CupertinoActionSheetAction>[
                      CupertinoActionSheetAction(
                        onPressed: () {
                          //Navigator.pop(context);
                          HapticFeedback.lightImpact();
                          if (favoriteGameNames.contains(game.name)) {
                            // El juego ya está en la lista de favoritos
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Game already in library"),
                                duration: Duration(
                                    seconds: 1), // Duración del SnackBar
                              ),
                            );
                            Navigator.of(context).pop();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text("${game.name} added to the library"),
                                duration: Duration(
                                    seconds: 1), // Duración del SnackBar
                              ),
                            );
                            // El juego no está en la lista de favoritos, así que lo añadimos
                            game.favorite = true;
                            favoriteGamesProvider.addToFavorites(game);
                            Navigator.of(context).pop();
                          }
                        },
                        child: const Row(
                          children: [
                            Icon(Icons.add_circle, color: Colors.black),
                            SizedBox(
                                width: 8), // Espacio entre el icono y el texto
                            Text(
                              "Add to library",
                              style: TextStyle(
                                color: Colors.black, // Color del texto
                              ),
                            ),
                          ],
                        ),
                      ),
                      CupertinoActionSheetAction(
                        onPressed: () {
                          Navigator.pop(context);
                          HapticFeedback.lightImpact();
                          favoriteGamesProvider.addToFavorites(game);
                          game.favorite = true;
                        },
                        child: const Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.black, // Color del icono
                            ),
                            SizedBox(
                                width: 8), // Espacio entre el icono y el texto
                            Text(
                              "Add to favorites",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  );
                },
              );
            },
            onTap: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      GameDetailScreen(
                    key: const Key("game_detail_screen_key"),
                    game: game,
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
            child: Stack(
              children: [
                Hero(
                  tag: games[index].id,
                  child: AspectRatio(
                    aspectRatio: 3 / 4,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5.0)),
                          image: DecorationImage(
                              image: NetworkImage(
                                "https://images.igdb.com/igdb/image/upload/t_cover_big/${games[index].cover!.imageId}.jpg",
                              ),
                              fit: BoxFit.cover)),
                    ),
                  ),
                ),
                /*
                AspectRatio(
                  aspectRatio: 3 / 4,
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5.0)),
                        gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withOpacity(0.7),
                              Colors.black.withOpacity(0.0)
                            ],
                            stops: const [
                              0.0,
                              0.5
                            ])),
                  ),
                ),
                Positioned(
                  bottom: 10.0,
                  left: 5.0,
                  child: Container(
                    width: 90.0,
                    child: Text(
                      game.name,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10.0,
                        fontWeight: FontWeight.bold,
                      ),
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
                        initialRating: game.total_rating / 20,
                        minRating: 0,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemPadding:
                            const EdgeInsets.symmetric(horizontal: 2.0),
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
                        (game.total_rating / 20).toStringAsFixed(2),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),*/
              ],
            ),
          );
        },
      ),
    );
  }
}
