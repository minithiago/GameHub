import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:procecto2/bloc/get_friendsLibraryGames_bloc.dart';
import 'package:procecto2/elements/error_element.dart';
import 'package:procecto2/elements/loader_element.dart';
import 'package:procecto2/model/game.dart';
import 'package:procecto2/model/game_response.dart';
import 'package:procecto2/providers/favorite_provider.dart';
import 'package:procecto2/repository/user_repository.dart';
import 'package:procecto2/services/switch_games.dart';
import 'package:provider/provider.dart';
import '../game_detail_screen.dart';

class LibraryScreenGridUser extends StatefulWidget {
  final String filtro;
  final String busqueda;
  final String usuario;

  const LibraryScreenGridUser(
      {Key? key,
      required this.filtro,
      required this.busqueda,
      required this.usuario})
      : super(key: key);

  @override
  _LibraryScreenGridState2 createState() => _LibraryScreenGridState2();
}

class _LibraryScreenGridState2 extends State<LibraryScreenGridUser> {
  String _currentFilter = '';
  String _nameFilter = '';
  String _usuario = '';

  Future<List<String>> getGamesForUserEmail(String userEmail) async {
    try {
      // Obtener la referencia al documento del usuario en Firestore utilizando su email
      QuerySnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where('email', isEqualTo: userEmail)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        String userId = userSnapshot.docs.first.id;
        // Obtener la referencia a la subcolección "Games" del usuario
        QuerySnapshot gamesSnapshot = await FirebaseFirestore.instance
            .collection('Users')
            .doc(userId)
            .collection('Games')
            .get();

        // Extraer los IDs de los juegos
        List<String> gameIds = gamesSnapshot.docs.map((doc) {
          // Obtener el campo "id" de cada documento en la subcolección "Games"
          return doc['id']
              .toString(); // Ajusta esto según la estructura de tus documentos
        }).toList();

        return gameIds;
      } else {
        print(
            'No se encontró ningún usuario con el correo electrónico $userEmail.');
        return [];
      }
    } catch (e) {
      print('Error getting games for user: $e');
      return [];
    }
  }

  @override
  void initState() {
    super.initState();
    _currentFilter = widget.filtro;
    _nameFilter = widget.busqueda;
    _usuario = widget.usuario;

    fetchUserGames();
    FavoriteGamesProvider();
  }

  Future<void> fetchUserGames() async {
    //ponerlo en game-details y en añadri un setState() 'alomejor'
    try {
      // Obtiene la lista de juegos para el usuario
      List<String> userGames = await getGamesForUserEmail(
          //FirebaseAuth.instance.currentUser!.email.toString()
          _usuario);

      // Verifica si la lista de juegos para el usuario está vacía
      if (userGames.isEmpty) {
        // Si está vacía, pasa una lista vacía al método getlibraryGames.getlibraryGames
        getlibraryGames2.getlibraryGames2([]);
      } else {
        // Si no está vacía, pasa la lista de juegos al método getlibraryGames.getlibraryGames
        getlibraryGames2.getlibraryGames2(userGames);
      }
    } catch (e) {
      // Maneja cualquier error que ocurra durante la obtención de los juegos del usuario
      print('Error fetching user games: $e');
    }
  }

  @override
  void didUpdateWidget(covariant LibraryScreenGridUser oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.filtro != widget.filtro) {
      setState(() {
        _currentFilter = widget.filtro;
        print(widget.filtro);
      });
    }
  }

  //List<GameModel> favoriteGamess = [];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<GameResponse>(
      stream: getlibraryGames2.subject.stream,
      builder: (context, AsyncSnapshot<GameResponse> snapshot) {
        if (snapshot.hasData) {
          final gameResponse = snapshot.data;
          if (gameResponse != null && gameResponse.error.isNotEmpty) {
            return buildErrorWidget(gameResponse.error);
          } else {
            //favoriteGamess = gameResponse!.games;
            return _build(gameResponse!);
          }
        } else if (snapshot.hasError) {
          return buildErrorWidget(snapshot.error.toString());
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return buildLoadingWidget();
        } else {
          // Devolvemos un widget vacío que no ocupa espacio en la pantalla
          return const SizedBox(
            child: Center(
              child: Text(
                "Search for games",
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
      },
    );
  }

  //@override
  Widget _build(GameResponse data) {
    String userId = FirebaseAuth.instance.currentUser!.email.toString();

    var favoriteGamesProvider = Provider.of<FavoriteGamesProvider>(context);

    final List<int> allGameIds =
        favoriteGamesProvider.allGames.map((game) => game.id).toList();
    final List<int> playingGameIds =
        favoriteGamesProvider.favoriteGames.map((game) => game.id).toList();

    final List<int> wantGameIds =
        favoriteGamesProvider.wishlistGames.map((game) => game.id).toList();

    final List<int> beatenGameIds =
        favoriteGamesProvider.beatenGames.map((game) => game.id).toList();

    var favoriteGamess = data.games;

    List<GameModel> _filterGamesByName(List<GameModel> games) {
      if (_nameFilter.isEmpty) {
        return games;
      } else {
        return games
            .where((game) =>
                game.name.toLowerCase().contains(_nameFilter.toLowerCase()))
            .toList();
      }
    }

    switch (_currentFilter) {
      case "Name":
        favoriteGamess.sort((b, a) => b.name.compareTo(a.name));
        break;
      case "Rating":
        favoriteGamess.sort((a, b) => b.total_rating.compareTo(a.total_rating));
        break;
      case "Release date":
        favoriteGamess.sort((a, b) => b.firstRelease.compareTo(a.firstRelease));
        break;
      default:
        favoriteGamess = data.games;
    }

    if (favoriteGamess.isEmpty) {
      favoriteGamess = [];
    }

    // Ordenar los juegos por rating (en orden descendente)
    if (favoriteGamess.isEmpty) {
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
              itemCount: favoriteGamess.length,
              itemBuilder: (BuildContext context, int index) {
                GameModel game = favoriteGamess[index];
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
                                        if (playingGameIds.contains(game.id)) {
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
                                          UserRepository().addGamePlayingToUser(
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
                                          UserRepository().addGameBeatenToUser(
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
                                tag: favoriteGamess[index].id,
                                child: AspectRatio(
                                  aspectRatio: 3 / 4,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(5.0)),
                                        image: DecorationImage(
                                            image: NetworkImage(
                                              "https://images.igdb.com/igdb/image/upload/t_cover_big/${favoriteGamess[index].cover!.imageId}.jpg",
                                            ),
                                            fit: BoxFit.cover)),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 3,
                                right: 5,
                                child: Visibility(
                                  visible: allGameIds.contains(game.id),
                                  child: const Icon(
                                    Icons.check_circle,
                                    color: Color.fromRGBO(110, 182, 255, 1),
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
                            ],
                          ),
                        ))));
              },
            ),
          ));
    }
  }
}
