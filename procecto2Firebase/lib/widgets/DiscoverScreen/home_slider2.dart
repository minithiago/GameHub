import 'package:flutter/material.dart';
import 'package:procecto2/bloc/get_slider2_bloc.dart';
import 'package:procecto2/elements/error_element.dart';
import 'package:procecto2/elements/loader_element.dart';
import 'package:procecto2/model/game.dart';
import 'package:procecto2/model/game_response.dart';
import 'package:procecto2/screens/game_detail_screen.dart';
import 'package:procecto2/style/theme.dart' as Style;
import 'package:page_indicator/page_indicator.dart';

class HomeSlider2 extends StatefulWidget {
  const HomeSlider2({super.key});

  @override
  _HomeSliderState2 createState() => _HomeSliderState2();
}

class _HomeSliderState2 extends State<HomeSlider2> {
  @override
  void initState() {
    getSliderBloc2.getSlider2();
    super.initState();
    // Inicia el temporizador para cambiar automáticamente las páginas cada 3 segundos
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<GameResponse>(
      stream: getSliderBloc2.subject.stream,
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
          return SizedBox(
            height: 250,
            child: buildLoadingWidget(),
          );
        }
      },
    );
  }

  Widget _buildHomeSliderWidget(GameResponse data) {
    List<GameModel> games = data.games;
    PageController pageController2 = PageController(
      viewportFraction: 1,
      keepPage: true,
    );

    return Container(
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(0.0), // Ajusta el radio según sea necesario
        // Color de fondo del contenedor
      ),
      height: 250,
      child: PageIndicatorContainer(
        align: IndicatorAlign.bottom,
        length: games.take(10).length,
        indicatorSpace: 8.0,
        padding: const EdgeInsets.all(10.0),
        indicatorColor: Colors.white,
        indicatorSelectorColor: const Color.fromRGBO(110, 182, 255, 1),
        shape: IndicatorShape.circle(size: 5.0),
        child: PageView.builder(
          controller: pageController2,
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          itemCount: games.take(10).length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        GameDetailScreen(
                      key: const Key("game_detail_screen_key"),
                      game: games[index],
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
              child: Stack(
                children: <Widget>[
                  Hero(
                    tag: games[index].id,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 250.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            0), // Ajusta el radio según sea necesario
                        //

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
                      borderRadius: BorderRadius.circular(0),
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        stops: const [0.0, 0.4],
                        colors: [
                          const Color(0xff20232a).withOpacity(1.0),
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
