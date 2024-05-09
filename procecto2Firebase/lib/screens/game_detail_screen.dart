import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:intl/intl.dart';
import 'package:procecto2/model/game.dart';
//import 'package:procecto2/model/game_models/screenshot.dart';
import 'package:procecto2/model/item.dart';
import 'package:procecto2/repository/user_repository.dart';
import 'package:procecto2/style/theme.dart' as Style;
import 'package:provider/provider.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/providers.dart';
import 'dart:ui' as ui;

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
    Item(id: 1, name: "IMAGES") // Corregido de "SCREESHOTS" a "SCREENSHOTS"
  ];
  final customColors = CustomSliderColors(
    //dotColor: Colors.white.withOpacity(0.8),
    trackColor: Style.Colors.grey,
    progressBarColor: const Color.fromARGB(255, 79, 215, 84),
    hideShadow: true,
  );

  // Utiliza el constructor super para inicializar la clase base
  _GameDetailScreenState(this.game) : super();

  @override
  void dispose() {
    //_controller.dispose();
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
          autoPlay: false,
          loop: true,
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
    var date = DateTime.fromMillisecondsSinceEpoch(game.firstRelease * 1000);
    var formattedDate = DateFormat('dd/MM/yyyy').format(date);
    String userId = "";

    var favoriteGamesProvider = Provider.of<FavoriteGamesProvider>(context);
    LoginProvider().storageGetAuthData();

    //favoriteGamesProvider.loadFavoriteGames;
    List<String> favoriteGameNames =
        favoriteGamesProvider.favoriteGames.map((game) => game.name).toList();

    User? user = FirebaseAuth.instance.currentUser;

    print(user);

    // Verifica si hay un usuario autenticado
    if (user != null) {
      // El usuario está autenticado, puedes obtener su ID
      userId = user.email!;
      print('email: $userId');
    } else {
      // No hay usuario autenticado
      print('No user logged in');
    }

    return Scaffold(
        //backgroundColor: const Color(0xFF20232a),
        body: Stack(children: [
      Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
                "https://images.igdb.com/igdb/image/upload/t_cover_big/${game.cover!.imageId}.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: Container(
            color: Colors.black.withOpacity(0.5),
          ),
        ),
      ),
      Column(children: [
        Container(
          height: 50.0,
          //color: Theme.of(context).colorScheme.secondary,
        ),
        Stack(
          children: <Widget>[
            SizedBox(
              height: 230.0, //220
              child: YoutubePlayer(
                controller: _controller,
                showVideoProgressIndicator: true,
                progressIndicatorColor: Colors.red, //true
                thumbnail: Image.asset('assets/images/videoError.jpg'),
              ),
            ),
            Positioned(
              top: 0.0,
              left: 0.0,
              child: IconButton(
                  icon: const Icon(
                    EvaIcons.arrowBack,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    _controller.pause();
                    _controller.dispose();
                    Navigator.pop(context);
                  }),
            ),

            /*Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      stops: const [
                        0.0,
                        0.9
                      ],
                      colors: [
                        Color.fromARGB(255, 62, 112, 226).withOpacity(1.0),
                        Style.Colors.backgroundColor.withOpacity(0.0)
                      ]),
                ),
              ),*/
          ],
        ),
        Container(
          color: Theme.of(context)
              .colorScheme
              .secondary, // Color de fondo del TabBar
          child: TabBar(
            //Theme.of(context).colorScheme.primary,
            dividerColor: Color.fromARGB(0, 0, 0, 0),
            controller: _tabController,
            indicatorColor: Color.fromARGB(255, 83, 114, 188),
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorWeight: 3.0,
            unselectedLabelColor: Theme.of(context).colorScheme.primary,
            labelColor: Color.fromARGB(255, 83, 114, 188),
            isScrollable: false,
            tabs: tabs.map((Item genre) {
              return Container(
                padding: const EdgeInsets.only(bottom: 13.0, top: 13.0),
                child: Text(genre.name, style: const TextStyle(fontSize: 13.0)),
              );
            }).toList(),
          ),
        ),
        Expanded(
          child: TabBarView(
              controller: _tabController,
              //physics: const NeverScrollableScrollPhysics(),
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
                                    Visibility(
                                      visible: game.total_rating != null,
                                      child: Container(
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
                                          initialValue: game.total_rating,
                                          innerWidget: (double value) {
                                            return Column(
                                              children: <Widget>[
                                                Expanded(
                                                  child: Align(
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      (game.total_rating)
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
                                              ],
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible: game.total_rating == null,
                                      child: Container(
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
                                          initialValue: 0,
                                          innerWidget: (double value) {
                                            return Column(
                                              children: <Widget>[
                                                Expanded(
                                                  child: Align(
                                                    alignment: Alignment.center,
                                                    child: Hero(
                                                      tag: game.id,
                                                      child: const Text(
                                                        "N/A",
                                                        style: TextStyle(
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
                                    ),
                                    const SizedBox(width: 10.0),
                                    // Espacio entre la puntuación y el botón
                                    Column(
                                      children: [
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors
                                                .green, // Color de fondo del botón
                                            shape: RoundedRectangleBorder(
                                              // Forma del botón con bordes redondeados
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      20), // Radio de los bordes
                                            ),
                                            minimumSize: const Size(130, 40),
                                          ),
                                          onPressed: () async {
                                            String url =
                                                "https://www.amazon.es/s?k=${game.name}&__mk_es_ES=%C3%85M%C3%85%C5%BD%C3%95%C3%91&crid=3AS6SWL65PXHE&sprefix=stellar+blade%2Caps%2C155&ref=nb_sb_noss_1";

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
                                                      3), // Espacio entre el icono y el texto
                                              Text(
                                                "Buy Now",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Visibility(
                                          visible: favoriteGameNames
                                                  .contains(game.name) !=
                                              true,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              UserRepository().addGameToUser(
                                                  userId,
                                                  "https://images.igdb.com/igdb/image/upload/t_cover_big/${game.cover!.imageId}.jpg",
                                                  game.name,
                                                  game.total_rating,
                                                  game.id);

                                              favoriteGamesProvider
                                                  .addToFavorites(game);
                                              game.favorite = true;
                                              favoriteGameNames.add(game.name);
                                              print(favoriteGameNames);

                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                content: Text(
                                                    "${game.name} added to library"),
                                                duration: Duration(seconds: 1),
                                                action: SnackBarAction(
                                                  label: "Undo",
                                                  onPressed: () {
                                                    UserRepository()
                                                        .removeGameFromUser(
                                                            userId, game.id);
                                                    favoriteGamesProvider
                                                        .removeFavorite(game);
                                                    favoriteGameNames
                                                        .remove(game.name);
                                                    game.favorite = false;
                                                    print(favoriteGameNames);
                                                  },
                                                ),
                                              ));
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Color.fromARGB(
                                                  255, 83, 114, 188),
                                              shape: RoundedRectangleBorder(
                                                // Forma del botón con bordes redondeados
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        20), // Radio de los bordes
                                              ),
                                              minimumSize: const Size(130, 40),
                                            ),
                                            child: const Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(Icons.add_circle,
                                                    color: Colors
                                                        .white), // Icono de cesto de la compra
                                                SizedBox(
                                                    width:
                                                        3), // Espacio entre el icono y el texto
                                                Text(
                                                  "to library",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Visibility(
                                          visible: favoriteGameNames
                                              .contains(game.name),
                                          child: ElevatedButton(
                                            onPressed: () {
                                              UserRepository()
                                                  .removeGameFromUser(
                                                      userId, game.id);

                                              UserRepository().fetchUserData();

                                              favoriteGamesProvider
                                                  .removeFavorite(game);
                                              game.favorite = false;
                                              favoriteGamesProvider
                                                  .removeFavoriteByName(
                                                      game.name);

                                              // Remover el juego de la lista

                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                content: Text(
                                                    "${game.name} removed from library"),
                                                action: SnackBarAction(
                                                  label: "Undo",
                                                  onPressed: () {
                                                    UserRepository().addGameToUser(
                                                        userId,
                                                        "https://images.igdb.com/igdb/image/upload/t_cover_big/${game.cover!.imageId}.jpg",
                                                        game.name,
                                                        game.total_rating,
                                                        game.id);
                                                    favoriteGamesProvider
                                                        .addToFavorites(game);
                                                    game.favorite = true;
                                                    favoriteGameNames
                                                        .add(game.name);

                                                    // Agregar el juego a la lista
                                                  },
                                                ),
                                              ));
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red,
                                              shape: RoundedRectangleBorder(
                                                // Forma del botón con bordes redondeados
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                // Radio de los bordes
                                              ),
                                              minimumSize: const Size(130, 40),
                                            ),
                                            child: const Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(Icons.remove_circle,
                                                    color: Colors
                                                        .white), // Icono de cesto de la compra
                                                SizedBox(
                                                    width:
                                                        8), // Espacio entre el icono y el texto
                                                Text(
                                                  "Remove",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ],
                                            ),
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
                    //const SizedBox(height: 10.0),

                    Padding(
                      padding: const EdgeInsets.only(
                          left: 10.0, bottom: 10.0, top: 15.0),
                      child: Text(
                        "Socials".toUpperCase(),
                        style: const TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(
                                  255, 32, 50, 124), // Color de fondo del botón
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    20), // Radio de los bordes
                              ),
                              minimumSize: const Size(110, 40),
                            ),
                            onPressed: () async {
                              String url =
                                  "https://www.igdb.com/games/${game.slug}";
                              print(url);
                              if (await canLaunchUrl(Uri.parse(url))) {
                                await launchUrl(Uri.parse(url));
                              } else {
                                throw 'Could not launch $url';
                              }
                            },
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(SimpleLineIcons.game_controller,
                                    color: Colors.white),
                                SizedBox(width: 8),
                                Text(
                                  "IGDB",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0, right: 10),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors
                                  .purple[400], // Color de fondo del botón
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    20), // Radio de los bordes
                              ),
                              minimumSize: const Size(110, 40),
                            ),
                            onPressed: () async {
                              String url =
                                  "https://www.twitch.tv/directory/category/${game.slug}";
                              print(url);
                              if (await canLaunchUrl(Uri.parse(url))) {
                                await launchUrl(Uri.parse(url));
                              } else {
                                throw 'Could not launch $url';
                              }
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Reemplaza el icono con una imagen de tu elección
                                Image.asset(
                                  'assets/images/twitch_logo.png', // Ruta de la imagen local
                                  width: 20, // Ancho deseado de la imagen
                                  height: 20, // Altura deseada de la imagen
                                  color: Colors.white, // Color de la imagen
                                ),
                                const SizedBox(width: 6),
                                const Text(
                                  "Twitch",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 0.0,
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Colors.red, // Color de fondo del botón
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    20), // Radio de los bordes
                              ),
                              minimumSize: const Size(110, 40),
                            ),
                            onPressed: () async {
                              String url =
                                  "https://www.youtube.com/results?search_query=${game.name}";
                              print(url);
                              if (await canLaunchUrl(Uri.parse(url))) {
                                await launchUrl(Uri.parse(url));
                              } else {
                                throw 'Could not launch $url';
                              }
                            },
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.play_arrow, color: Colors.white),
                                SizedBox(width: 4),
                                Text(
                                  "Youtube",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    Visibility(
                      visible: game.summary != null,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          game.summary,
                          style: TextStyle(
                              height: 1.5,
                              color: Colors.white.withOpacity(0.7)),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: game.summary == null,
                      child: const Padding(
                        padding: EdgeInsets.only(left: 10.0, top: 5.0),
                        child: Text(
                          "No summary available",
                          style: TextStyle(
                            //color: Colors.grey,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    buildSection("Platforms", game.platforms,
                        emptyMessage: "No platforms available"),
                    buildSection("Genres", game.genres,
                        emptyMessage: "No genres available"),
                    buildSection("Game Modes", game.modes,
                        emptyMessage: "No game modes available"),

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
                    Visibility(
                      visible:
                          game.companies != null && game.companies!.isNotEmpty,
                      child: Container(
                        height: 30.0,
                        padding: const EdgeInsets.only(left: 10.0, top: 5.0),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: game.companies?.length ?? 0,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.only(right: 10.0),
                              child: Container(
                                padding: EdgeInsets.all(5.0),
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5.0)),
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
                    ),
                    Visibility(
                      visible:
                          game.companies == null || game.companies!.isEmpty,
                      child: const Padding(
                        padding: EdgeInsets.only(left: 10.0, top: 5.0),
                        child: Text(
                          "No companies available",
                          style: TextStyle(
                            color: Colors.grey,
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
                        "Languages".toUpperCase(),
                        style: const TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                    Visibility(
                      //Valida que si hay dos lenguajes iguales solo muestre uno
                      visible:
                          game.languages != null && game.languages!.isNotEmpty,
                      child: Container(
                        height: 30.0,
                        padding: const EdgeInsets.only(left: 10.0, top: 5.0),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: game.languages?.length ?? 0,
                          itemBuilder: (context, index) {
                            final languageName =
                                game.languages![index].language![0].name;
                            if (index == 0 ||
                                !game.languages!.sublist(0, index).any((lang) =>
                                    lang.language![0].name == languageName)) {
                              return Padding(
                                padding: EdgeInsets.only(right: 10.0),
                                child: Container(
                                  padding: EdgeInsets.all(5.0),
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(5.0)),
                                      border: Border.all(
                                          width: 1.0, color: Colors.white)),
                                  child: Text(
                                    languageName,
                                    maxLines: 2,
                                    style: const TextStyle(
                                        height: 1.4,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 9.0),
                                  ),
                                ),
                              );
                            } else {
                              return SizedBox
                                  .shrink(); // Ocultar si el lenguaje ya se ha mostrado antes
                            }
                          },
                        ),
                      ),
                    ),

                    Visibility(
                      visible:
                          game.languages == null || game.languages!.isEmpty,
                      child: const Padding(
                        padding: EdgeInsets.only(left: 10.0, top: 5.0),
                        child: Text(
                          "No languages available",
                          style: TextStyle(
                            color: Colors.grey,
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
                        height: 220.0,
                        padding: EdgeInsets.only(left: 10.0, top: 5.0),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: game.dlc?.length ?? 0,
                          itemBuilder: (context, index) {
                            final dlc = game.dlc![index];
                            return dlc.cover != null
                                ? Padding(
                                    padding: EdgeInsets.only(right: 10.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(5.0),
                                          child: Image.network(
                                            "https://images.igdb.com/igdb/image/upload/t_cover_big/${dlc.cover![0].imageId}.jpg",
                                            fit: BoxFit.cover,
                                            width: 120.0,
                                          ),
                                        ),
                                        const SizedBox(
                                            height:
                                                5.0), // Espaciado entre la imagen y el nombre
                                        Text(
                                          dlc.name ??
                                              'Unnamed DLC', // Mostrar el nombre del DLC, o 'Unnamed DLC' si el nombre es nulo
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 10.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Container(
                                    //color: Colors.amber,
                                    ); // No muestra el DLC si no tiene portada
                          },
                        ),
                      ),
                    ),
                    Visibility(
                      visible: game.dlc == null || game.dlc!.isEmpty,
                      child: const Padding(
                        padding: EdgeInsets.only(left: 10.0, top: 5.0),
                        child: Text(
                          "No DLCs available",
                          style: TextStyle(
                            color: Colors.grey,
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
                    Visibility(
                      visible: game.similar != null && game.similar!.isNotEmpty,
                      child: Container(
                        height: 200.0,
                        padding: EdgeInsets.only(left: 10.0, top: 5.0),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: game.similar?.length ?? 0,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.only(right: 20.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Image.network(
                                  "https://images.igdb.com/igdb/image/upload/t_cover_big/${game.similar![index].cover![0].imageId}.jpg",
                                  fit: BoxFit.fill,
                                  width: 140.0,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    Visibility(
                      visible: game.similar == null || game.similar!.isEmpty,
                      child: const Padding(
                        padding: EdgeInsets.only(left: 10.0, top: 5.0),
                        child: Text(
                          "No similar games available",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                  ],
                ),
                Column(
                  children: [
                    Expanded(
                      child: AnimationLimiter(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 10.0, left: 10.0, right: 10.0),
                          child: game.screenshots != null &&
                                  game.screenshots!.isNotEmpty
                              ? GridView.count(
                                  crossAxisSpacing: 10.0,
                                  mainAxisSpacing: 10.0,
                                  childAspectRatio: 1.33,
                                  crossAxisCount: 1,
                                  children: List.generate(
                                    game.screenshots!.length,
                                    (int index) {
                                      return AnimationConfiguration
                                          .staggeredGrid(
                                        position: index,
                                        duration:
                                            const Duration(milliseconds: 375),
                                        columnCount: 3,
                                        child: ScaleAnimation(
                                          child: FadeInAnimation(
                                            child: AspectRatio(
                                              aspectRatio: 4 / 3,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                5.0)),
                                                    image: DecorationImage(
                                                        image: NetworkImage(
                                                          "https://images.igdb.com/igdb/image/upload/t_screenshot_big/${game.screenshots![index].imageId}.jpg",
                                                        ),
                                                        fit: BoxFit.cover)),
                                                child: FadeInImage.assetNetwork(
                                                  placeholder:
                                                      'assets/images/loading_image.gif', // Ruta de la imagen de placeholder
                                                  image:
                                                      "https://images.igdb.com/igdb/image/upload/t_screenshot_big/${game.screenshots![index].imageId}.jpg",
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                )
                              : const Center(
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
        )
      ]),
    ]));
  }

  //widget para los listview

  Widget buildSection(String title, List<dynamic>? items,
      {String emptyMessage = "No available items"}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10.0, bottom: 10.0, top: 15.0),
          child: Text(
            title.toUpperCase(),
            style: const TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
        ),
        Visibility(
          visible: items != null && items.isNotEmpty,
          child: Container(
            height: 30.0,
            padding: EdgeInsets.only(left: 10.0, top: 5.0),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: items?.length ?? 0,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(right: 10.0),
                  child: Container(
                    padding: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        border: Border.all(width: 1.0, color: Colors.white)),
                    child: Text(
                      items![index].name,
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
        ),
        Visibility(
          visible: items == null || items.isEmpty,
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0, top: 5.0),
            child: Text(
              emptyMessage,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
