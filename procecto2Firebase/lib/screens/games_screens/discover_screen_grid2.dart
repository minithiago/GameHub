import 'dart:async';

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

class DiscoverScreenGrid2 extends StatefulWidget {
  const DiscoverScreenGrid2({super.key});

  @override
  _DiscoverScreenGridState2 createState() => _DiscoverScreenGridState2();
}

class _DiscoverScreenGridState2 extends State<DiscoverScreenGrid2> {
  late ScrollController _scrollController;
  ScrollPhysics _scrollPhysics = const AlwaysScrollableScrollPhysics();
  @override
  void initState() {
    super.initState();
    getGamesBloc2.getGames2();
    FavoriteGamesProvider();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.minScrollExtent) {
      setState(() {
        _scrollPhysics = const NeverScrollableScrollPhysics();
      });
      print('minimo');
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          _scrollPhysics = const BouncingScrollPhysics();
        });
      }); // Método para solicitar más juegos
    } else {
      setState(() {
        _scrollPhysics = const AlwaysScrollableScrollPhysics();
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<GameResponse>(
      stream: getGamesBloc2.subject,
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
          return SizedBox(
            height: 300,
            child: buildLoadingWidget(),
          );
        }
      },
    );
  }

  Widget _buildGameGridWidget(GameResponse data) {
    List<GameModel> games = data.games;
    //String userId = FirebaseAuth.instance.currentUser!.email.toString();

    var favoriteGamesProvider = Provider.of<FavoriteGamesProvider>(context);

    final List<int> allGameIds =
        favoriteGamesProvider.allGames.map((game) => game.id).toList();

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
          child: Stack(
            children: [
              AnimationLimiter(
                child: GridView.builder(
                  controller: _scrollController,
                  physics: _scrollPhysics,
                  //physics: NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: 7.0,
                    mainAxisSpacing: 7.0,
                    childAspectRatio: 0.75,
                    crossAxisCount: 3,
                  ),
                  itemCount: games.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == games.length - 1) {
                      getGamesBloc2.getMoreGames2();
                      return StreamBuilder<bool>(
                        stream: getGamesBloc2.loadingStream,
                        builder:
                            (context, AsyncSnapshot<bool> loadingSnapshot) {
                          if (loadingSnapshot.hasData &&
                              loadingSnapshot.data!) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        },
                      );
                      // Solicitar más juegos cuando se alcanza el último
                    }
                    GameModel game = games[index];
                    return AnimationConfiguration.staggeredGrid(
                        columnCount: 3,
                        position: index,
                        duration: const Duration(milliseconds: 400),
                        child: SlideAnimation(
                            verticalOffset: 50.0,
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
                                        actions: <CupertinoActionSheetAction>[
                                          CupertinoActionSheetAction(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              HapticFeedback.lightImpact();
                                              if (allGameIds
                                                  .contains(game.id)) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "${game.name} already in library"),
                                                  duration: const Duration(
                                                      seconds: 1),
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
                                              if (allGameIds
                                                  .contains(game.id)) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "${game.name} already in library"),
                                                  duration: const Duration(
                                                      seconds: 1),
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
                                              if (allGameIds
                                                  .contains(game.id)) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "${game.name} already in library"),
                                                  duration: const Duration(
                                                      seconds: 1),
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
                                } else {
                                  return null;
                                }
                              },
                              onTap: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation,
                                            secondaryAnimation) =>
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
                                      var offsetAnimation =
                                          animation.drive(tween);

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
                                            borderRadius:
                                                const BorderRadius.all(
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
                                                    begin:
                                                        Alignment.bottomCenter,
                                                    end: Alignment.topCenter,
                                                    colors: [
                                                      Colors.black
                                                          .withOpacity(0.8),
                                                      Colors.black
                                                          .withOpacity(0.0)
                                                    ],
                                                    stops: const [0.0, 0.5],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              bottom: 20.0,
                                              left: 5.0,
                                              child: Container(
                                                width: 90.0,
                                                child: Text(
                                                  game.name, // Cambia esto por el nombre del juego
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
                                                        const EdgeInsets
                                                            .symmetric(
                                                            horizontal: 2.0),
                                                    itemBuilder: (context, _) =>
                                                        const Icon(
                                                      EvaIcons.star,
                                                      color: Colors.yellow,
                                                    ),
                                                    onRatingUpdate: (rating) {
                                                      print(rating);
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
                                                      fontWeight:
                                                          FontWeight.bold,
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
              )
            ],
          ));
    }
  }
}
