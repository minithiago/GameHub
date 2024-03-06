import 'package:flutter/material.dart';
import 'package:procecto2/bloc/get_slider_bloc.dart';
import 'package:procecto2/elements/error_element.dart';
import 'package:procecto2/elements/loader_element.dart';
import 'package:procecto2/model/game.dart';
import 'package:procecto2/model/game_response.dart';
import 'package:procecto2/style/theme.dart' as Style;
import 'package:page_indicator/page_indicator.dart';

class HomeSlider extends StatefulWidget {
  @override
  _HomeSliderState createState() => _HomeSliderState();
}

class _HomeSliderState extends State<HomeSlider> {
  PageController pageController =
      PageController(viewportFraction: 1, keepPage: true);

  @override
  void initState() {
    getSliderBloc.getSlider();
    super.initState();
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
    PageController pageController =
        PageController(viewportFraction: 1, keepPage: true);

    List<GameModel> games = data.games;
    if (games.length == 0) {
      return Container(
        width: MediaQuery.of(context).size.width,
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
              children: <Widget>[
                Text(
                  "No More Games",
                  style: TextStyle(color: Colors.black45),
                )
              ],
            )
          ],
        ),
      );
    } else
      return Container(
        height: 180,
        child: PageIndicatorContainer(
          align: IndicatorAlign.bottom,
          length: games.take(5).length,
          indicatorSpace: 8.0,
          padding: const EdgeInsets.all(5.0),
          indicatorColor: Style.Colors.mainColor,
          indicatorSelectorColor: Style.Colors.secondaryColor,
          shape: IndicatorShape.circle(size: 5.0),
          child: PageView.builder(
            controller: pageController,
            scrollDirection: Axis.horizontal,
            itemCount: games.take(5).length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {},
                child: Stack(
                  children: <Widget>[
                    Hero(
                      tag: games[index].id,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 180.0,
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
                          stops: [0.0, 0.9],
                          colors: [
                            Color(0xff20232a).withOpacity(1.0),
                            Style.Colors.backgroundColor.withOpacity(0.0),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 10.0,
                      bottom: 0.0,
                      child: Container(
                        height: 90.0,
                        child: AspectRatio(
                          aspectRatio: 3 / 4,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
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
                        padding: EdgeInsets.only(left: 10.0, right: 10.0),
                        width: 250.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              games[index].name,
                              style: TextStyle(
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
