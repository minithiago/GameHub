import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:procecto2/bloc/get_libraryGames_bloc.dart';
import 'package:procecto2/elements/error_element.dart';
import 'package:procecto2/elements/loader_element.dart';
import 'package:procecto2/model/game.dart';
import 'package:procecto2/model/game_response.dart';
import 'package:procecto2/providers/favorite_provider.dart';
import 'package:procecto2/repository/user_repository.dart';
import 'package:procecto2/services/switch_games.dart';
import 'package:provider/provider.dart';
import '../game_detail_screen.dart';

class LibraryScreenGrid extends StatefulWidget {
  final String filtro;
  final String busqueda;
  final String usuario;
  final int lista;

  const LibraryScreenGrid(
      {Key? key,
      required this.filtro,
      required this.busqueda,
      required this.usuario,
      required this.lista})
      : super(key: key);

  @override
  _LibraryScreenGridState createState() => _LibraryScreenGridState();
}

class _LibraryScreenGridState extends State<LibraryScreenGrid> {
  String _currentFilter = '';
  int _lista = 0;

  @override
  void initState() {
    super.initState();
    _currentFilter = widget.filtro;
    _lista = widget.lista;
    FavoriteGamesProvider();
  }

  @override
  void didUpdateWidget(covariant LibraryScreenGrid oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.filtro != widget.filtro) {
      setState(() {
        _currentFilter = widget.filtro;
        print(widget.filtro);
      });
    }
    if (oldWidget.lista != widget.lista) {
      setState(() {
        _lista = widget.lista;
        print(widget.lista);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //Widget _build(GameResponse data) {
    var favoriteGamesProvider = Provider.of<FavoriteGamesProvider>(context);
    String userId = FirebaseAuth.instance.currentUser!.email.toString();

    final List<int> favoriteGameIds =
        favoriteGamesProvider.favoriteGames.map((game) => game.id).toList();
    final List<int> wishlistGameIds =
        favoriteGamesProvider.wishlistGames.map((game) => game.id).toList();
    final List<int> beatenGameIds =
        favoriteGamesProvider.beatenGames.map((game) => game.id).toList();

    //var favoriteGamess = data.games;

    List<GameModel> favoriteGamess = favoriteGamesProvider.allGames;

    List<GameModel> sublist1 = favoriteGamesProvider.favoriteGames; // Playing

    List<GameModel> sublist2 = favoriteGamesProvider.wishlistGames; // Want

    List<GameModel> sublist3 = favoriteGamesProvider.beatenGames; // Beaten

    List<GameModel> gamesToShow;

    // Seleccionar la lista según el índice de _lista
    switch (_lista) {
      case 1:
        gamesToShow = sublist1;
        break;
      case 2:
        gamesToShow = sublist3;
        break;
      case 3:
        gamesToShow = sublist2;
        break;
      default:
        gamesToShow = favoriteGamess;
    }

    switch (_currentFilter) {
      case "Name":
        gamesToShow.sort((b, a) => b.name.compareTo(a.name));
        break;
      case "Rating":
        gamesToShow.sort((a, b) => b.total_rating.compareTo(a.total_rating));
        break;
      case "Release date":
        gamesToShow.sort((a, b) => b.firstRelease.compareTo(a.firstRelease));
        break;
      default:
        gamesToShow =
            gamesToShow; //data.games; //  favoriteGamesProvider.favoriteGames;
    }

    if (favoriteGamess.isEmpty) {
      favoriteGamess = [];
    }

    // Ordenar los juegos por rating (en orden descendente)

    if (gamesToShow.isEmpty) {
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
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 7.0,
                mainAxisSpacing: 7.0,
                childAspectRatio: 0.75,
                crossAxisCount: 3,
              ),
              itemCount: gamesToShow.length,
              itemBuilder: (BuildContext context, int index) {
                GameModel game = gamesToShow[index];
                return AnimationConfiguration.staggeredGrid(
                    columnCount: 3,
                    position: index,
                    duration: const Duration(milliseconds: 400),
                    child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                            child: GestureDetector(
                          onLongPress: () {
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
                                        setState(() {
                                          // Cambia el estado del modo cada vez que se pulsa
                                        });

                                        favoriteGamesProvider
                                            .removeFromAllGames(game);

                                        HapticFeedback.lightImpact();
                                        UserRepository().removeGameFromUser(
                                            userId, game.id);

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text(
                                              "${game.name} removed from library"),
                                          action: SnackBarAction(
                                            label: "Undo",
                                            onPressed: () {
                                              favoriteGamesProvider
                                                  .addToAllGames(game);

                                              UserRepository().addGameToUser(
                                                userId,
                                                "https://images.igdb.com/igdb/image/upload/t_cover_big/${game.cover!.imageId}.jpg",
                                                game.name,
                                                game.total_rating,
                                                game.id,
                                              );
                                            },
                                          ),
                                          duration: const Duration(seconds: 1),
                                        ));
                                        Navigator.pop(context);
                                      },
                                      child: const Row(
                                        children: [
                                          Icon(
                                            Icons.remove_circle_outline,
                                            color:
                                                Colors.red, // Color del icono
                                          ),
                                          SizedBox(
                                              width:
                                                  8), // Espacio entre el icono y el texto
                                          Text(
                                            "Remove from library",
                                            style: TextStyle(
                                              color:
                                                  Colors.red, // Color del texto
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    CupertinoActionSheetAction(
                                      onPressed: () {
                                        setState(() {
                                          // Cambia el estado del modo cada vez que se pulsa
                                        });
                                        Navigator.pop(context);
                                        HapticFeedback.lightImpact();
                                        if (favoriteGameIds.contains(game.id)) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: Text(
                                                "${game.name} already in playing list"),
                                            duration:
                                                const Duration(seconds: 1),
                                          ));
                                        } else {
                                          favoriteGamesProvider
                                              .addToFavorites(game);
                                          UserRepository().addGamePlayingToUser(
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
                                            Icons.gamepad_rounded,
                                            //color: Colors.black, // Color del icono
                                          ),
                                          SizedBox(
                                              width:
                                                  8), // Espacio entre el icono y el texto
                                          Text(
                                            "Add to Playing",
                                            style: TextStyle(
                                                //color: Colors.black,
                                                ),
                                          )
                                        ],
                                      ),
                                    ),
                                    CupertinoActionSheetAction(
                                      onPressed: () {
                                        setState(() {
                                          // Cambia el estado del modo cada vez que se pulsa
                                        });
                                        Navigator.pop(context);
                                        HapticFeedback.lightImpact();
                                        if (beatenGameIds.contains(game.id)) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: Text(
                                                "${game.name} already in beaten list"),
                                            duration:
                                                const Duration(seconds: 1),
                                          ));
                                        } else {
                                          favoriteGamesProvider
                                              .addToBeaten(game);
                                          UserRepository().addGameBeatenToUser(
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
                                            Icons.task_alt,
                                            //color: Colors.black, // Color del icono
                                          ),
                                          SizedBox(
                                              width:
                                                  8), // Espacio entre el icono y el texto
                                          Text(
                                            "Add to Beaten",
                                            style: TextStyle(
                                                //color: Colors.black,
                                                ),
                                          )
                                        ],
                                      ),
                                    ),
                                    CupertinoActionSheetAction(
                                      onPressed: () {
                                        setState(() {
                                          // Cambia el estado del modo cada vez que se pulsa
                                        });
                                        Navigator.pop(context);
                                        HapticFeedback.lightImpact();
                                        if (wishlistGameIds.contains(game.id)) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: Text(
                                                "${game.name} already in want list"),
                                            duration:
                                                const Duration(seconds: 1),
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
                            //setState(() => fetchUserGames());
                          },
                          child: Stack(
                            children: [
                              Hero(
                                tag: gamesToShow[index].id,
                                child: AspectRatio(
                                  aspectRatio: 3 / 4,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10.0)),
                                        image: DecorationImage(
                                            image: NetworkImage(
                                              "https://images.igdb.com/igdb/image/upload/t_cover_big/${gamesToShow[index].cover!.imageId}.jpg",
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
                                                initialRating: game
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
                              /*
                              */
                            ],
                          ),
                        ))));
              },
            ),
          ));
    }
  }
}
