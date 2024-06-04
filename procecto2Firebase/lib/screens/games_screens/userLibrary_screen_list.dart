import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:procecto2/bloc/get_friendsLibraryGames_bloc.dart';
import 'package:procecto2/elements/error_element.dart';
import 'package:procecto2/elements/loader_element.dart';
import 'package:procecto2/model/game.dart';
import 'package:procecto2/model/game_response.dart';
import 'package:procecto2/providers/favorite_provider.dart';

import 'package:procecto2/services/switch_games.dart';
import 'package:provider/provider.dart';
import '../game_detail_screen.dart';

class LibraryScreenlistUser extends StatefulWidget {
  final String filtro;
  final String busqueda;
  final String usuario;

  const LibraryScreenlistUser(
      {Key? key,
      required this.filtro,
      required this.busqueda,
      required this.usuario})
      : super(key: key);

  @override
  _LibraryScreenlistState2 createState() => _LibraryScreenlistState2();
}

class _LibraryScreenlistState2 extends State<LibraryScreenlistUser> {
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
  void didUpdateWidget(covariant LibraryScreenlistUser oldWidget) {
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
    var favoriteGamess = data.games;
    var favoriteGamesProvider = Provider.of<FavoriteGamesProvider>(context);
    final List<int> allGameIds =
        favoriteGamesProvider.allGames.map((game) => game.id).toList();

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
      return AnimationLimiter(
        child: ListView.builder(
          itemCount: favoriteGamess.length,
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
                            game: favoriteGamess[index],
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
                                      favoriteGamess[index].name,
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
                                      favoriteGamess[index].summary,
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
                                                    favoriteGamess[index]
                                                            .total_rating /
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
                                                (favoriteGamess[index]
                                                            .total_rating /
                                                        20)
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
                                Positioned(
                                  top: 3,
                                  right: 5,
                                  child: Visibility(
                                    visible: allGameIds
                                        .contains(favoriteGamess[index].id),
                                    child: const Icon(
                                      Icons.check_circle,
                                      color: Color.fromRGBO(110, 182, 255, 1),
                                    ),
                                  ),
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
