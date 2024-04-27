import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:procecto2/bloc/get_gamesSearch_bloc.dart';
import 'package:procecto2/elements/error_element.dart';
import 'package:procecto2/elements/loader_element.dart';
import 'package:procecto2/model/game.dart';
import 'package:procecto2/model/game_response.dart';
import 'package:procecto2/providers/favorite_provider.dart';
import 'package:procecto2/style/theme.dart' as Style;
import 'package:provider/provider.dart';

import '../game_detail_screen.dart';

class LibrarySearchScreenGrid extends StatefulWidget {
  String query = "";

  LibrarySearchScreenGrid(this.query);

  @override
  _LibrarySearchScreenGridState createState() =>
      _LibrarySearchScreenGridState();
}

class _LibrarySearchScreenGridState extends State<LibrarySearchScreenGrid> {
  String _nameFilter = '';
  @override
  void initState() {
    getGamesBlocSearch.getSearchedGames(widget.query);
    super.initState();
    _nameFilter = widget.query;
  }

  Widget build(BuildContext context) {
    return StreamBuilder<GameResponse>(
      stream: getGamesBlocSearch.subject.stream,
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
    var favoriteGamesProvider = Provider.of<FavoriteGamesProvider>(context);
    var favoriteGames = favoriteGamesProvider.favoriteGames;
    final List<String> favoriteGameNames =
        favoriteGamesProvider.favoriteGames.map((game) => game.name).toList();
    print(favoriteGames);

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

    return AnimationLimiter(
      child: AnimationLimiter(
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
          child: GridView.count(
            crossAxisSpacing: 7.0,
            mainAxisSpacing: 7.0,
            childAspectRatio: 0.75,
            crossAxisCount: 3, //columnas
            children: List.generate(
              _filterGamesByName(favoriteGames).length,
              (int index) {
                GameModel game = _filterGamesByName(favoriteGames)[index];
                return AnimationConfiguration.staggeredGrid(
                  position: index,
                  duration: const Duration(milliseconds: 375),
                  columnCount: 3,
                  child: ScaleAnimation(
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
                                      game.favorite = false;
                                      favoriteGamesProvider
                                          .removeFavorite(game);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                            "${game.name} removed from library"),
                                        action: SnackBarAction(
                                          label: "Undo",
                                          onPressed: () {
                                            favoriteGamesProvider
                                                .addToFavorites(game);
                                            game.favorite = true;
                                          },
                                        ),
                                      ));
                                    },
                                    child: const Row(
                                      children: [
                                        Icon(
                                          Icons.remove_circle_outline,
                                          color:
                                              Colors.black, // Color del icono
                                        ),
                                        SizedBox(
                                            width:
                                                8), // Espacio entre el icono y el texto
                                        Text(
                                          "Remove from library",
                                          style: TextStyle(
                                            color:
                                                Colors.black, // Color del texto
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  CupertinoActionSheetAction(
                                    onPressed: () {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                            "${game.name} added to library"),
                                        action: SnackBarAction(
                                          label: "Undo",
                                          onPressed: () {
                                            favoriteGamesProvider
                                                .removeFavorite(game);
                                          },
                                        ),
                                      ));
                                      Navigator.pop(context);
                                      HapticFeedback.lightImpact();
                                      favoriteGamesProvider
                                          .addToFavorites(game);
                                    },
                                    child: const Row(
                                      children: [
                                        Icon(
                                          Icons.star,
                                          color:
                                              Colors.black, // Color del icono
                                        ),
                                        SizedBox(
                                            width:
                                                8), // Espacio entre el icono y el texto
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
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      GameDetailScreen(
                                key: const Key("game_detail_screen_key"),
                                game: _filterGamesByName(favoriteGames)[index],
                              ),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
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
                              transitionDuration:
                                  const Duration(milliseconds: 300),
                            ),
                          );
                        },
                        child: Stack(
                          children: [
                            Hero(
                              tag: _filterGamesByName(favoriteGames)[index].id,
                              child: AspectRatio(
                                aspectRatio: 3 / 4,
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(5.0)),
                                      image: DecorationImage(
                                          image: NetworkImage(
                                            "https://images.igdb.com/igdb/image/upload/t_cover_big/${_filterGamesByName(favoriteGames)[index].cover!.imageId}.jpg",
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
                              bottom: 7.0,
                              left: 7.0,
                              child: Container(
                                width: 90.0,
                                child: Text(
                                  _filterGamesByName(favoriteGames)[index].name,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            /*
                            Positioned(
                              bottom: 5.0,
                              left: 5.0,
                              child: Row(
                                children: [
                                  RatingBar.builder(
                                    itemSize: 8.0,
                                    initialRating:
                                        _filterGamesByName(favoriteGames)[index]
                                                .total_rating /
                                            20,
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
                                    (_filterGamesByName(favoriteGames)[index]
                                                .total_rating /
                                            20)
                                        .toString()
                                        .substring(0, 3),
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10.0,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            )*/
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
