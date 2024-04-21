import 'dart:async';

import 'package:flutter/material.dart';
import 'package:procecto2/bloc/get_slider_bloc.dart';
import 'package:procecto2/elements/error_element.dart';
import 'package:procecto2/elements/loader_element.dart';
import 'package:procecto2/model/game.dart';
import 'package:procecto2/model/game_response.dart';
import 'package:procecto2/screens/game_detail_screen.dart';
import 'package:procecto2/style/theme.dart' as Style;
import 'package:page_indicator/page_indicator.dart';

class HomeSlider extends StatefulWidget {
  @override
  _HomeSliderState createState() => _HomeSliderState();
}

class _HomeSliderState extends State<HomeSlider> {
  PageController pageController =
      PageController(viewportFraction: 1, keepPage: true);
  int currentPage = 0;

  @override
  void initState() {
    getSliderBloc.getSlider();
    super.initState();
    // Inicia el temporizador para cambiar automáticamente las páginas cada 3 segundos
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<GameResponse>(
      stream: getSliderBloc.subject.stream,
      builder: (context, AsyncSnapshot<GameResponse> snapshot) {
        if (snapshot.hasData) {
          GameResponse gameResponse =
              snapshot.data as GameResponse; //puede que sea fallo

          if (gameResponse.error.isNotEmpty) {
            return buildErrorWidget(gameResponse.error);
          }

          return _buildHomeSliderWidget(gameResponse);
        } else if (snapshot.hasError) {
          // Asegúrate de manejar la nulabilidad de snapshot.error
          String errorMessage = snapshot.error?.toString() ?? "Unknown error";
          return buildErrorWidget(errorMessage);
        } else {
          return buildLoadingWidget();
        }
      },
    );
  }

  Widget _buildHomeSliderWidget(GameResponse data) {
    List<GameModel> games = data.games;
    // Crear el PageController fuera del cuerpo de la función
    PageController pageController = PageController(
      viewportFraction: 1,
      keepPage: true,
    );

/* Iniciar el temporizador dentro de la función initState o dentro de un StatefulWidget
    Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (currentPage < games.take(10).length - 1) {
        currentPage++;
      } else {
        currentPage = 0;
      }
      // Cambia automáticamente la página
      pageController.animateToPage(
        currentPage,
        duration: const Duration(milliseconds: 2000),
        curve: Curves.ease,
      );
    });*/

    return SizedBox(
      height: 220,
      child: PageIndicatorContainer(
        align: IndicatorAlign.bottom,
        length: games.take(10).length,
        indicatorSpace: 8.0,
        padding: const EdgeInsets.all(10.0),
        indicatorColor: Colors.white,
        indicatorSelectorColor: Colors.orange,
        shape: IndicatorShape.circle(size: 5.0),
        child: PageView.builder(
          controller: pageController,
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          itemCount: games.take(10).length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GameDetailScreen(
                      key: const Key(
                          "game_detail_screen_key"), // Puedes proporcionar una clave única aquí
                      game: games[index],
                    ),
                  ),
                );
              },
              child: Stack(
                children: <Widget>[
                  Hero(
                    tag: games[index].id,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 220.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                            "https://images.igdb.com/igdb/image/upload/t_screenshot_huge/${games[index].screenshots![0].imageId}.jpg",
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        stops: [0.0, 0.4],
                        colors: [
                          Color(0xff20232a).withOpacity(1.0),
                          Style.Colors.backgroundColor.withOpacity(0.0),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 10.0,
                    bottom: 10.0,
                    child: SizedBox(
                      height: 90.0,
                      child: AspectRatio(
                        aspectRatio: 3 / 4,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5.0)),
                            image: DecorationImage(
                              image: NetworkImage(
                                "https://images.igdb.com/igdb/image/upload/t_cover_big/${games[index].cover!.imageId}.jpg",
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 30.0,
                    left: 80.0,
                    child: Container(
                      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                      width: 250.0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            games[index].name,
                            style: const TextStyle(
                              height: 1.5,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
