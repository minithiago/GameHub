import 'dart:ui';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';
import 'package:procecto2/model/game.dart';
//import 'package:procecto2/model/game_models/screenshot.dart';
import 'package:procecto2/model/item.dart';
import 'package:procecto2/style/theme.dart' as Style;
import 'package:provider/provider.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../providers/providers.dart';

class GameDetailScreen extends StatefulWidget {
  final GameModel game;
  GameDetailScreen({required Key key, required this.game}) : super(key: key);
  @override
  _GameDetailScreenState createState() => _GameDetailScreenState(game);
}

class _GameDetailScreenState extends State<GameDetailScreen>
    with SingleTickerProviderStateMixin {
  late YoutubePlayerController _controller;
  PageController pageController =
      PageController(viewportFraction: 1, keepPage: true);
  late TabController _tabController;
  final GameModel game;
  final tabs = <Item>[
    Item(id: 0, name: "OVERVIEW"),
    Item(
        id: 1, name: "SCREENSHOTS") // Corregido de "SCREESHOTS" a "SCREENSHOTS"
  ];
  final customColors = CustomSliderColors(
    dotColor: Colors.white.withOpacity(0.8),
    trackColor: Style.Colors.grey,
    progressBarColor: const Color.fromARGB(255, 79, 215, 84),
    hideShadow: true,
  );

  // Utiliza el constructor super para inicializar la clase base
  _GameDetailScreenState(this.game) : super();

  @override
  void dispose() {
    _controller.dispose();
    pageController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: tabs.length);

    if (game.videos != null) {
      _controller = YoutubePlayerController(
        initialVideoId: game.videos!.isNotEmpty ? game.videos![0].videoId : '',
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
          hideThumbnail: true,
        ),
      );
    } else {
      // Usar una imagen estándar si no hay vídeos disponibles
      _controller = YoutubePlayerController(
        initialVideoId: '', // No hay vídeo
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: true,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var date =
        new DateTime.fromMillisecondsSinceEpoch(game.firstRelease * 1000);
    var formattedDate = DateFormat('dd/MM/yyyy').format(date);

    final now = DateTime.parse(DateTime.now().toString());
    var favoriteGamesProvider = Provider.of<FavoriteGamesProvider>(context);
    var favoriteGames = favoriteGamesProvider.favoriteGames;

    //var nowDate = now.millisecondsSinceEpoch;

    //print(now.millisecondsSinceEpoch);
    return Scaffold(
      backgroundColor: Color(0xFF20232a),
      body: Column(
        children: [
          Stack(
            children: <Widget>[
              Container(
                height: 220.0,
                child: YoutubePlayer(
                  controller: _controller,
                  showVideoProgressIndicator: true,
                  thumbnail: Image.asset('assets/images/videoError.jpg'),
                ),
              ),
              Positioned(
                top: 20.0,
                left: 0.0,
                child: IconButton(
                    icon: Icon(
                      EvaIcons.arrowBack,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      stops: const [
                        0.0,
                        0.9
                      ],
                      colors: [
                        Color(0xff20232a).withOpacity(1.0),
                        Style.Colors.backgroundColor.withOpacity(0.0)
                      ]),
                ),
              ),
            ],
          ),
          TabBar(
            controller: _tabController,
            indicatorColor: Colors.orange,
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorWeight: 2.0,
            unselectedLabelColor: Colors.white,
            labelColor: Colors.orange,
            isScrollable: false,
            tabs: tabs.map((Item genre) {
              return Container(
                  padding: const EdgeInsets.only(bottom: 15.0, top: 15.0),
                  child: Text(genre.name,
                      style: const TextStyle(
                          fontSize: 13.0, fontFamily: "SFPro-Medium")));
            }).toList(),
          ),
          Expanded(
            child: TabBarView(
                controller: _tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: <Widget>[
                  ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0, left: 10.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(5.0),
                              child: Image.network(
                                "https://images.igdb.com/igdb/image/upload/t_cover_big/${game.cover!.imageId}.jpg",
                                fit: BoxFit.cover,
                                width: 130.0,
                              ),
                            ),
                            const SizedBox(
                                width:
                                    16.0), // Espacio entre la imagen y el texto
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    game.name,
                                    style: const TextStyle(
                                      height: 1.5,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                  Text(
                                    formattedDate,
                                    style: TextStyle(
                                        height: 1.5,
                                        color: Colors.white.withOpacity(0.5)),
                                  ),
                                  const SizedBox(
                                      height:
                                          8.0), // Espacio entre el título y la puntuación
                                  Row(
                                    children: [
                                      Container(
                                        height: 85,
                                        width: 85,
                                        alignment: Alignment.centerLeft,
                                        child: SleekCircularSlider(
                                          appearance: CircularSliderAppearance(
                                            angleRange: 360,
                                            customColors: customColors,
                                            customWidths: CustomSliderWidths(
                                              progressBarWidth: 7,
                                              trackWidth: 4,
                                            ),
                                          ),
                                          min: 0,
                                          max: 100,
                                          initialValue: game.rating,
                                          innerWidget: (double value) {
                                            return Column(
                                              children: <Widget>[
                                                Expanded(
                                                  child: Align(
                                                    alignment: Alignment.center,
                                                    child: Hero(
                                                      tag: game.id,
                                                      child: Text(
                                                        (game.rating)
                                                            .toString()
                                                            .substring(0, 2),
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 35,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                      ),
                                      const SizedBox(
                                          width:
                                              5.0), // Espacio entre la puntuación y el botón
                                      Column(
                                        children: [
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors
                                                  .green, // Cambia este color al color deseado
                                            ),
                                            onPressed: () async {
                                              String url =
                                                  "https://www.igdb.com/games/${game.slug}";
                                              print(url);
                                              if (await canLaunchUrl(
                                                  Uri.parse(url))) {
                                                await launchUrl(Uri.parse(url));
                                              } else {
                                                throw 'Could not launch $url';
                                              }
                                            },
                                            child: const Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(Icons.shopping_cart,
                                                    color: Colors
                                                        .white), // Icono de cesto de la compra
                                                SizedBox(
                                                    width:
                                                        8), // Espacio entre el icono y el texto
                                                Text(
                                                  "Buy Now",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ],
                                            ),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              //print(DateTime.now());
                                              //print(now.millisecondsSinceEpoch);
                                              favoriteGamesProvider
                                                  .addToFavorites(game);
                                              //LoginProvider.setGames(favoriteGames);
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                content: Text("Added " +
                                                    game.name +
                                                    " to library"),
                                                action: SnackBarAction(
                                                  label: "Undo",
                                                  onPressed: () {
                                                    favoriteGamesProvider
                                                        .removeFavorite(game);
                                                  },
                                                ),
                                              ));
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors
                                                  .blue, // Cambia este color al color deseado
                                            ),
                                            child: const Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(Icons.add_circle,
                                                    color: Colors
                                                        .white), // Icono de cesto de la compra
                                                SizedBox(
                                                    width:
                                                        8), // Espacio entre el icono y el texto
                                                Text(
                                                  "to library",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          game.summary,
                          style: TextStyle(
                              height: 1.5,
                              color: Colors.white.withOpacity(0.5)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 10.0, bottom: 10.0, top: 15.0),
                        child: Text(
                          "Platforms".toUpperCase(),
                          style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      Container(
                        height: 30.0,
                        padding: EdgeInsets.only(left: 10.0, top: 5.0),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: game.platforms!.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.only(right: 10.0),
                              child: Container(
                                padding: EdgeInsets.all(5.0),
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0)),
                                    border: Border.all(
                                        width: 1.0, color: Colors.white)),
                                child: Text(
                                  game.platforms![index].name,
                                  maxLines: 2,
                                  style: TextStyle(
                                      height: 1.4,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 9.0),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 10.0, bottom: 10.0, top: 15.0),
                        child: Text(
                          "Genre".toUpperCase(),
                          style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      Container(
                        height: 30.0,
                        padding: EdgeInsets.only(left: 10.0, top: 5.0),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: game.genres!.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.only(right: 10.0),
                              child: Container(
                                padding: EdgeInsets.all(5.0),
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0)),
                                    border: Border.all(
                                        width: 1.0, color: Colors.white)),
                                child: Text(
                                  game.genres![index].name,
                                  maxLines: 2,
                                  style: TextStyle(
                                      height: 1.4,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 9.0),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 10.0, bottom: 10.0, top: 15.0),
                        child: Text(
                          "Companies".toUpperCase(),
                          style: const TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      Container(
                        height: 30.0,
                        padding: const EdgeInsets.only(left: 10.0, top: 5.0),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: game.companies!.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.only(right: 10.0),
                              child: Container(
                                padding: EdgeInsets.all(5.0),
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0)),
                                    border: Border.all(
                                        width: 1.0, color: Colors.white)),
                                child: Text(
                                  game.companies![index].company![0].name,
                                  maxLines: 2,
                                  style: const TextStyle(
                                      height: 1.4,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 9.0),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 10.0, bottom: 10.0, top: 15.0),
                        child: Text(
                          "Game modes".toUpperCase(),
                          style: const TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      Container(
                        height: 30.0,
                        padding: EdgeInsets.only(left: 10.0, top: 5.0),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: game.modes!.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.only(right: 10.0),
                              child: Container(
                                padding: EdgeInsets.all(5.0),
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0)),
                                    border: Border.all(
                                        width: 1.0, color: Colors.white)),
                                child: Text(
                                  game.modes![index].name,
                                  maxLines: 2,
                                  style: TextStyle(
                                      height: 1.4,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 9.0),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 10.0, bottom: 10.0, top: 15.0),
                        child: Text(
                          "DLCs".toUpperCase(),
                          style: const TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      Visibility(
  visible: game.dlc != null && game.dlc!.isNotEmpty,
  child: Container(
    height: 200.0,
    padding: EdgeInsets.only(left: 10.0, top: 5.0),
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: game.dlc?.length ?? 0,
      itemBuilder: (context, index) {
        final dlc = game.dlc![index];
        return dlc.cover != null
            ? Padding(
                padding: EdgeInsets.only(right: 10.0),
                child: Container(
                  padding: EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    border: Border.all(width: 1.0, color: Colors.white),
                  ),
                  child: Image.network(
                    "https://images.igdb.com/igdb/image/upload/t_cover_big/${dlc.cover![0].imageId}.jpg",
                    fit: BoxFit.cover,
                    width: 130.0,
                  ),
                ),
              )
            : Container(); // No muestra el DLC si no tiene portada
      },
    ),
  ),
),
Visibility(
  visible: game.dlc == null || game.dlc!.isEmpty,
  child: Padding(
    padding: const EdgeInsets.only(left: 10.0, top: 5.0),
    child: Text(
      "No DLCs available",
      style: TextStyle(
        color: Colors.white,
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
      ),
    ),
  ),
),

                      Padding(
                        padding: const EdgeInsets.only(
                            left: 10.0, bottom: 10.0, top: 15.0),
                        child: Text(
                          "Similar Games".toUpperCase(),
                          style: const TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      Container(
                        height: 200.0,
                        padding: EdgeInsets.only(left: 10.0, top: 5.0),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: game.similar!.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.only(right: 10.0),
                              child: Container(
                                padding: EdgeInsets.all(5.0),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                  border: Border.all(
                                      width: 1.0, color: Colors.white),
                                ),
                                child: Image.network(
                                  "https://images.igdb.com/igdb/image/upload/t_cover_big/${game.similar![index].cover![0].imageId/*game.dlc!.cover!.imageId*/}.jpg",
                                  fit: BoxFit.cover,  //game.companies![index].company![0].name,
                                  width: 130.0,
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                  Column(
  children: [
    Expanded(
      child: AnimationLimiter(
        child: Padding(
          padding: const EdgeInsets.only(
              top: 10.0, left: 10.0, right: 10.0),
          child: game.screenshots != null && game.screenshots!.isNotEmpty
              ? GridView.count(
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  childAspectRatio: 1.33,
                  crossAxisCount: 1,
                  children: List.generate(
                    game.screenshots!.length,
                    (int index) {
                      return AnimationConfiguration.staggeredGrid(
                        position: index,
                        duration: const Duration(milliseconds: 375),
                        columnCount: 3,
                        child: ScaleAnimation(
                          child: FadeInAnimation(
                            child: AspectRatio(
                              aspectRatio: 4 / 3,
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(5.0)),
                                    image: DecorationImage(
                                        image: NetworkImage(
                                          "https://images.igdb.com/igdb/image/upload/t_screenshot_big/${game.screenshots![index].imageId}.jpg",
                                        ),
                                        fit: BoxFit.cover)),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
              : Center(
                  child: Text(
                    "Screenshots not available",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
        ),
      ),
    )
  ],
)

                ]),
          ),
        ],
      ),
    );
  }
}
