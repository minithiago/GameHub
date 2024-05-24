import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:procecto2/bloc/get_games_bloc.dart';
import 'package:procecto2/elements/error_element.dart';
import 'package:procecto2/elements/loader_element.dart';
import 'package:procecto2/model/game.dart';
import 'package:procecto2/model/game_response.dart';
import 'package:procecto2/providers/favorite_provider.dart';
import 'package:procecto2/repository/user_repository.dart';
import 'package:procecto2/services/switch_games.dart';

import 'package:provider/provider.dart';

import '../game_detail_screen.dart';

class DiscoverScreenGrid3 extends StatefulWidget {
  DiscoverScreenGrid3({super.key});

  @override
  _DiscoverScreenGridState3 createState() => _DiscoverScreenGridState3();
}

class _DiscoverScreenGridState3 extends State<DiscoverScreenGrid3> {
  @override
  void initState() {
    getGamesBloc3.getGames3();
    super.initState();
    FavoriteGamesProvider();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<GameResponse>(
      stream: getGamesBloc3.subject.stream,
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
          return buildLoadingWidget();
        }
      },
    );
  }

  Widget _buildGameGridWidget(GameResponse data) {
    String userId = FirebaseAuth.instance.currentUser!.email.toString();

    var favoriteGamesProvider = Provider.of<FavoriteGamesProvider>(context);

    final List<int> allGameIds =
        favoriteGamesProvider.allGames.map((game) => game.id).toList();

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
      return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: AnimationLimiter(
            child: GridView.builder(
              scrollDirection: Axis.horizontal,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 7.0,
                mainAxisSpacing: 7.0,
                childAspectRatio: 1.3,
                crossAxisCount: 2,
              ),
              itemCount: games.length,
              itemBuilder: (BuildContext context, int index) {
                GameModel game = games[index];
                return AnimationConfiguration.staggeredList(
                    //columnCount: 2,
                    position: index,
                    duration: const Duration(milliseconds: 400),
                    child: SlideAnimation(
                        horizontalOffset: 50.0,
                        child: FadeInAnimation(
                            child: GestureDetector(
                          onLongPress: () {
                            HapticFeedback.lightImpact();
                            showCupertinoModalPopup(
                              context: context,
                              builder: (context) {
                                return CupertinoActionSheet(
                                  actions: <CupertinoActionSheetAction>[
                                    CupertinoActionSheetAction(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        HapticFeedback.lightImpact();
                                        if (allGameIds.contains(game.id)) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: Text(
                                                "${game.name} already in library"),
                                            duration:
                                                const Duration(seconds: 1),
                                          ));
                                        } else {
                                          UserRepository().addGameToUser(
                                            userId,
                                            "https://images.igdb.com/igdb/image/upload/t_cover_big/${game.cover!.imageId}.jpg",
                                            game.name,
                                            game.total_rating,
                                            game.id,
                                          );
                                          favoriteGamesProvider
                                              .addToAllGames(game);
                                        }
                                      },
                                      child: const Row(
                                        children: [
                                          Icon(
                                            Icons
                                                .add_circle, //color: Colors.black
                                          ),
                                          SizedBox(
                                              width:
                                                  8), // Espacio entre el icono y el texto
                                          Text(
                                            "Add to library",
                                            style: TextStyle(
                                                //color: Colors.black, // Color del texto
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    /*
                                    */
                                    CupertinoActionSheetAction(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        HapticFeedback.lightImpact();
                                        if (allGameIds.contains(game.id)) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: Text(
                                                "${game.name} already in library"),
                                            duration:
                                                const Duration(seconds: 1),
                                          ));
                                        } else {
                                          UserRepository().addGameToUser(
                                            userId,
                                            "https://images.igdb.com/igdb/image/upload/t_cover_big/${game.cover!.imageId}.jpg",
                                            game.name,
                                            game.total_rating,
                                            game.id,
                                          );
                                          favoriteGamesProvider
                                              .addToFavorites(game);
                                          favoriteGamesProvider
                                              .addToAllGames(game);
                                        }
                                      },
                                      child: const Row(
                                        children: [
                                          Icon(
                                            Icons.favorite_rounded,
                                            //color: Colors.black, // Color del icono
                                          ),
                                          SizedBox(
                                              width:
                                                  8), // Espacio entre el icono y el texto
                                          Text(
                                            "Add to favorites",
                                            style: TextStyle(
                                                //color: Colors.black,
                                                ),
                                          )
                                        ],
                                      ),
                                    ),
                                    CupertinoActionSheetAction(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        HapticFeedback.lightImpact();
                                        if (allGameIds.contains(game.id)) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: Text(
                                                "${game.name} already in library"),
                                            duration:
                                                const Duration(seconds: 1),
                                          ));
                                        } else {
                                          UserRepository().addGameToUser(
                                            userId,
                                            "https://images.igdb.com/igdb/image/upload/t_cover_big/${game.cover!.imageId}.jpg",
                                            game.name,
                                            game.total_rating,
                                            game.id,
                                          );
                                          favoriteGamesProvider
                                              .addToWishlist(game);
                                          favoriteGamesProvider
                                              .addToAllGames(game);
                                        }
                                      },
                                      child: const Row(
                                        children: [
                                          Icon(
                                            Icons.list_alt_rounded,
                                            //color: Colors.black, // Color del icono
                                          ),
                                          SizedBox(
                                              width:
                                                  8), // Espacio entre el icono y el texto
                                          Text(
                                            "Add to Wishlist",
                                            style: TextStyle(
                                                //color: Colors.black,
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
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        GameDetailScreen(
                                  key: const Key("game_detail_screen_key"),
                                  game: game,
                                ),
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
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
                                transitionDuration:
                                    const Duration(milliseconds: 300),
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
                              Consumer<SwitchState>(
                                builder: (context, switchState, child) {
                                  if (switchState.isSwitchedOn) {
                                    return Stack(
                                      children: [
                                        AspectRatio(
                                          aspectRatio: 3 / 4,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(5.0)),
                                              gradient: LinearGradient(
                                                begin: Alignment.bottomCenter,
                                                end: Alignment.topCenter,
                                                colors: [
                                                  Colors.black.withOpacity(0.8),
                                                  Colors.black.withOpacity(0.0)
                                                ],
                                                stops: const [0.0, 0.5],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 10.0,
                                          left: 5.0,
                                          child: Container(
                                            width: 90.0,
                                            child: Text(
                                              game.name, // Cambia esto por el nombre del juego
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 10.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  } else {
                                    return Container(); // O cualquier otro widget
                                  }
                                },
                              ),
                            ],
                          ),
                        ))));
              },
            ),
          ));
    }
  }
}
