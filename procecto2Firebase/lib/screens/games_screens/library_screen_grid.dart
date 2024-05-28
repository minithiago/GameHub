import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:procecto2/model/game.dart';
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
    var favoriteGamesProvider = Provider.of<FavoriteGamesProvider>(context);
    String userId = FirebaseAuth.instance.currentUser!.email.toString();

    final List<int> favoriteGameIds =
        favoriteGamesProvider.favoriteGames.map((game) => game.id).toList();
    final List<int> wishlistGameIds =
        favoriteGamesProvider.wishlistGames.map((game) => game.id).toList();

    //var favoriteGamess = data.games;

    List<GameModel> favoriteGamess = favoriteGamesProvider.allGames;

    List<GameModel> sublist1 = favoriteGamesProvider.favoriteGames;
    //favoriteGamess.where((game) => game.wishlist == true).toList();
    List<GameModel> sublist2 = favoriteGamesProvider.wishlistGames;

    List<GameModel> gamesToShow;

    // Seleccionar la lista según el índice de _lista
    switch (_lista) {
      case 1:
        gamesToShow = sublist1;
        break;
      case 2:
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
                                  actions: <CupertinoActionSheetAction>[
                                    CupertinoActionSheetAction(
                                      onPressed: () {
                                        favoriteGamesProvider
                                            .removeWishlist(game);
                                        favoriteGamesProvider
                                            .removeFavorite(game);
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
                                              favoriteGamesProvider
                                                  .addToFavorites(game);
                                              favoriteGamesProvider
                                                  .addToWishlist(game);
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
                                        Navigator.pop(context);
                                        HapticFeedback.lightImpact();
                                        if (favoriteGameIds.contains(game.id)) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: Text(
                                                "${game.name} already in favorites"),
                                            duration:
                                                const Duration(seconds: 1),
                                          ));
                                        } else {
                                          favoriteGamesProvider
                                              .addToFavorites(game);
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
                                        if (wishlistGameIds.contains(game.id)) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: Text(
                                                "${game.name} already in wishlist"),
                                            duration:
                                                const Duration(seconds: 1),
                                          ));
                                        } else {
                                          favoriteGamesProvider
                                              .addToWishlist(game);
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
/*
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

    fetchUserGames();
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
        getlibraryGames.getlibraryGames([]);
      } else {
        // Si no está vacía, pasa la lista de juegos al método getlibraryGames.getlibraryGames
        getlibraryGames.getlibraryGames(userGames);
      }
    } catch (e) {
      // Maneja cualquier error que ocurra durante la obtención de los juegos del usuario
      print('Error fetching user games: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<GameResponse>(
      stream: getlibraryGames.subject.stream,
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
                style: TextStyle(
                    //color: Colors.white
                    ),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
      },
    );
  }


   Widget _build(GameResponse data) {

    var favoriteGamess = data.games;
*/