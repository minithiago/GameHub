import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import 'package:procecto2/model/game.dart';
import 'package:procecto2/providers/favorite_provider.dart';
import 'package:procecto2/screens/game_detail_screen.dart';
import 'package:procecto2/services/switch_games.dart';
import 'package:provider/provider.dart';

class LibraryScreenList extends StatefulWidget {
  final String filtro;
  final String busqueda;
  final String usuario;
  final int lista;

  const LibraryScreenList(
      {Key? key,
      required this.filtro,
      required this.busqueda,
      required this.usuario,
      required this.lista})
      : super(key: key);

  @override
  _LibraryScreenListState createState() => _LibraryScreenListState();
}

class _LibraryScreenListState extends State<LibraryScreenList> {
  String _currentFilter = '';
  String _nameFilter = '';
  String _usuario = '';
  int _lista = 0;

  @override
  void initState() {
    super.initState();
    _currentFilter = widget.filtro;
    _nameFilter = widget.busqueda;
    _usuario = widget.usuario;
    _lista = widget.lista;
    FavoriteGamesProvider();
  }

  @override
  void didUpdateWidget(covariant LibraryScreenList oldWidget) {
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
        favoriteGamess.sort((b, a) => b.name.compareTo(a.name));
        break;
      case "Rating":
        favoriteGamess.sort((a, b) => b.total_rating.compareTo(a.total_rating));
        break;
      case "Release date":
        favoriteGamess.sort((a, b) => b.firstRelease.compareTo(a.firstRelease));
        break;
      default:
        favoriteGamess =
            favoriteGamess; //data.games; //  favoriteGamesProvider.favoriteGames;
    }

    if (favoriteGamess.isEmpty) {
      favoriteGamess = [];
    }
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
      return AnimationLimiter(
        child: ListView.builder(
          itemCount: gamesToShow.length,
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
                            game: gamesToShow[index],
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
                            tag: gamesToShow[index].id,
                            child: AspectRatio(
                              aspectRatio: 3 / 4,
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5.0)),
                                    image: DecorationImage(
                                        image: NetworkImage(
                                          "https://images.igdb.com/igdb/image/upload/t_cover_big/${gamesToShow[index].cover!.imageId}.jpg",
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
                                      gamesToShow[index].name,
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
                                      gamesToShow[index].summary,
                                      maxLines: 4,
                                      style: const TextStyle(
                                          //color: Colors.white.withOpacity(0.2),
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
                                                    gamesToShow[index]
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
                                                (gamesToShow[index]
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
