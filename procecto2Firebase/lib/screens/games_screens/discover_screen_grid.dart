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

class DiscoverScreenGrid extends StatefulWidget {
  const DiscoverScreenGrid({super.key});

  @override
  DiscoverScreenGridState createState() => DiscoverScreenGridState();
}

class DiscoverScreenGridState extends State<DiscoverScreenGrid> {
  late ScrollController _scrollController;
  @override
  void initState() {
    getGamesBloc.getGames();
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    FavoriteGamesProvider();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      getGamesBloc2.getMoreGames2();
      print('tope'); // Método para solicitar más juegos
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<GameResponse>(
      stream: getGamesBloc.subject,
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
    //String userId = FirebaseAuth.instance.currentUser!.email.toString();

    var favoriteGamesProvider = Provider.of<FavoriteGamesProvider>(context);

    final List<int> allGameIds =
        favoriteGamesProvider.allGames.map((game) => game.id).toList();

    final List<int> playingGameIds =
        favoriteGamesProvider.favoriteGames.map((game) => game.id).toList();

    final List<int> wantGameIds =
        favoriteGamesProvider.wishlistGames.map((game) => game.id).toList();

    final List<int> beatenGameIds =
        favoriteGamesProvider.beatenGames.map((game) => game.id).toList();

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
                if (index == games.length - 1) {
                  getGamesBloc.getMoreGames();
                  return StreamBuilder<bool>(
                    stream: getGamesBloc.loadingStream,
                    builder: (context, AsyncSnapshot<bool> loadingSnapshot) {
                      if (loadingSnapshot.hasData && loadingSnapshot.data!) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return SizedBox.shrink();
                      }
                    },
                  );
                  // Solicitar más juegos cuando se alcanza el último
                }
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
                            if (FirebaseAuth.instance.currentUser?.email
                                    .toString() !=
                                null) {
                              String userId = FirebaseAuth
                                  .instance.currentUser!.email
                                  .toString();
                              HapticFeedback.lightImpact();

                              showCupertinoModalPopup(
                                context: context,
                                builder: (context) {
                                  return CupertinoActionSheet(
                                    title: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Image.network(
                                              'https://images.igdb.com/igdb/image/upload/t_cover_big/${game.cover!.imageId}.jpg',
                                              height:
                                                  100.0, // Ajusta el tamaño de la imagen según sea necesario
                                              width: 100.0,
                                            ),
                                            const SizedBox(
                                                width:
                                                    10), // Espacio entre la imagen y el texto
                                            Expanded(
                                              child: Text(
                                                game.name,
                                                style: TextStyle(
                                                  fontSize: 16.0,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                  // Ajusta el tamaño del texto según sea necesario
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                            height:
                                                10), // Espacio entre el Row y el CupertinoActionSheet
                                      ],
                                    ),
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
                                                  const Duration(seconds: 2),
                                            ));
                                          } else {
                                            favoriteGamesProvider
                                                .addToAllGames(game);
                                            UserRepository().addGameToUser(
                                              userId,
                                              "https://images.igdb.com/igdb/image/upload/t_cover_big/${game.cover!.imageId}.jpg",
                                              game.name,
                                              game.total_rating,
                                              game.id,
                                            );
                                          }
                                        },
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons
                                                  .add_circle_outline_rounded, //color: Colors.black
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
                                          if (playingGameIds
                                              .contains(game.id)) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                              content: Text(
                                                  "${game.name} already in playing list"),
                                              duration:
                                                  const Duration(seconds: 2),
                                            ));
                                          } else {
                                            favoriteGamesProvider
                                                .addToFavorites(game);
                                            UserRepository()
                                                .addGamePlayingToUser(
                                              userId,
                                              "https://images.igdb.com/igdb/image/upload/t_cover_big/${game.cover!.imageId}.jpg",
                                              game.name,
                                              game.total_rating,
                                              game.id,
                                            );
                                            if (!allGameIds.contains(game.id)) {
                                              favoriteGamesProvider
                                                  .addToAllGames(game);
                                              UserRepository().addGameToUser(
                                                userId,
                                                "https://images.igdb.com/igdb/image/upload/t_cover_big/${game.cover!.imageId}.jpg",
                                                game.name,
                                                game.total_rating,
                                                game.id,
                                              );
                                            }
                                          }
                                        },
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.gamepad_rounded,
                                              //color: Colors.black, // Color del icono
                                            ),
                                            SizedBox(
                                                width:
                                                    8), // Espacio entre el icono y el texto
                                            Text(
                                              "Add to playing",
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
                                          if (beatenGameIds.contains(game.id)) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                              content: Text(
                                                  "${game.name} already in beaten list"),
                                              duration:
                                                  const Duration(seconds: 2),
                                            ));
                                          } else {
                                            favoriteGamesProvider
                                                .addToBeaten(game);
                                            UserRepository()
                                                .addGameBeatenToUser(
                                              userId,
                                              "https://images.igdb.com/igdb/image/upload/t_cover_big/${game.cover!.imageId}.jpg",
                                              game.name,
                                              game.total_rating,
                                              game.id,
                                            );
                                            if (!allGameIds.contains(game.id)) {
                                              favoriteGamesProvider
                                                  .addToAllGames(game);
                                              UserRepository().addGameToUser(
                                                userId,
                                                "https://images.igdb.com/igdb/image/upload/t_cover_big/${game.cover!.imageId}.jpg",
                                                game.name,
                                                game.total_rating,
                                                game.id,
                                              );
                                            }
                                          }
                                        },
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.task_alt,
                                              //color: Colors.black, // Color del icono
                                            ),
                                            SizedBox(
                                                width:
                                                    8), // Espacio entre el icono y el texto
                                            Text(
                                              "Add to beaten",
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
                                          if (wantGameIds.contains(game.id)) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                              content: Text(
                                                  "${game.name} already in want list"),
                                              duration:
                                                  const Duration(seconds: 2),
                                            ));
                                          } else {
                                            favoriteGamesProvider
                                                .addToWishlist(game);
                                            UserRepository().addGameWantToUser(
                                              userId,
                                              "https://images.igdb.com/igdb/image/upload/t_cover_big/${game.cover!.imageId}.jpg",
                                              game.name,
                                              game.total_rating,
                                              game.id,
                                            );
                                            if (!allGameIds.contains(game.id)) {
                                              favoriteGamesProvider
                                                  .addToAllGames(game);
                                              UserRepository().addGameToUser(
                                                userId,
                                                "https://images.igdb.com/igdb/image/upload/t_cover_big/${game.cover!.imageId}.jpg",
                                                game.name,
                                                game.total_rating,
                                                game.id,
                                              );
                                            }
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
                                              "Add to Want",
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
                              ); //*/
                            } else {
                              return;
                            }
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
                            ); /*
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => GameDetailScreen(
                                  key: const Key("game_detail_screen_key"),
                                  game: game,
                                ),
                              ),
                            );*/
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
                                                  Colors.black.withOpacity(0.7),
                                                  Colors.black.withOpacity(0.0)
                                                ],
                                                stops: const [0.0, 0.5],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 20.0,
                                          left: 5.0,
                                          child: SizedBox(
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
                                        Positioned(
                                          bottom: 5.0,
                                          left: 5.0,
                                          child: Row(
                                            children: [
                                              RatingBar.builder(
                                                itemSize: 8.0,
                                                initialRating: games[index]
                                                        .total_rating /
                                                    20, // Ajusta esto a tu calificación
                                                minRating: 0,
                                                direction: Axis.horizontal,
                                                allowHalfRating: true,
                                                itemCount: 5,
                                                itemPadding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 2.0),
                                                itemBuilder: (context, _) =>
                                                    const Icon(
                                                  EvaIcons.star,
                                                  color: Colors.yellow,
                                                ),
                                                onRatingUpdate: (rating) {
                                                  //print(rating);
                                                },
                                              ),
                                              const SizedBox(
                                                width: 3.0,
                                              ),
                                              Text(
                                                (game.total_rating / 20)
                                                    .toStringAsFixed(2),
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
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
