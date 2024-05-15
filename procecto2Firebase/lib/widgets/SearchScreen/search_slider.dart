import 'package:flutter/material.dart';
import 'package:procecto2/bloc/switch_bloc.dart';
import 'package:procecto2/style/theme.dart' as Style;
import 'package:procecto2/widgets/SearchScreen/searchGenre.dart';

class SearchSlider extends StatefulWidget {
  @override
  _SearchSliderState createState() => _SearchSliderState();
}

class _SearchSliderState extends State<SearchSlider> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 170,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildGameContainer(
            gameName: "RPG",
            imageUrl: "assets/images/game_images/rpg.jpg",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DiscoverScreenWidget4(
                        SwitchBlocSearch(), 12.toString())),
              );
            },
          ),
          _buildGameContainer(
            gameName: "Adventure",
            imageUrl: "assets/images/game_images/adventure.jpeg",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DiscoverScreenWidget4(
                        SwitchBlocSearch(), 31.toString())),
              );
            },
          ),
          _buildGameContainer(
            gameName: "Fighting",
            imageUrl: "assets/images/game_images/fighting.jpg",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DiscoverScreenWidget4(
                        SwitchBlocSearch(), 4.toString())),
              );
            },
          ),
          _buildGameContainer(
            gameName: "Indie",
            imageUrl: "assets/images/game_images/indie.webp",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DiscoverScreenWidget4(
                        SwitchBlocSearch(), 32.toString())),
              );
            },
          ),
          _buildGameContainer(
            gameName: "Racing",
            imageUrl: "assets/images/game_images/racing.jpg",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DiscoverScreenWidget4(
                        SwitchBlocSearch(), 10.toString())),
              );
            },
          ),
          _buildGameContainer(
            gameName: "Sports",
            imageUrl: "assets/images/game_images/sports.jpeg",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DiscoverScreenWidget4(
                        SwitchBlocSearch(), 14.toString())),
              );
            },
          ),
          _buildGameContainer(
            gameName: "Shooter",
            imageUrl: "assets/images/game_images/shooter.jpg",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DiscoverScreenWidget4(
                        SwitchBlocSearch(), 5.toString())),
              );
            },
          ),
          _buildGameContainer(
            gameName: "Arcade",
            imageUrl: "assets/images/game_images/arcade.avif",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DiscoverScreenWidget4(
                        SwitchBlocSearch(), 33.toString())),
              );
            },
          ),
          _buildGameContainer(
            gameName: "Simulation",
            imageUrl: "assets/images/game_images/simulation.png",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DiscoverScreenWidget4(
                        SwitchBlocSearch(), 13.toString())),
              );
            },
          ),
          _buildGameContainer(
            gameName: "Music",
            imageUrl: "assets/images/game_images/music.png",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DiscoverScreenWidget4(
                        SwitchBlocSearch(), 7.toString())),
              );
            },
          ),
          _buildGameContainer(
            gameName: "Puzzle",
            imageUrl: "assets/images/game_images/puzzle.jpg",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DiscoverScreenWidget4(
                        SwitchBlocSearch(), 9.toString())),
              );
            },
          ),
          _buildGameContainer(
            gameName: "Platformer",
            imageUrl: "assets/images/game_images/platformer.jpg",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DiscoverScreenWidget4(
                        SwitchBlocSearch(), 8.toString())),
              );
            },
          ),
          _buildGameContainer(
            gameName: "Visual Novel",
            imageUrl: "assets/images/game_images/visual.png",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DiscoverScreenWidget4(
                        SwitchBlocSearch(), 34.toString())),
              );
            },
          ),
          _buildGameContainer(
            gameName: "Strategy",
            imageUrl: "assets/images/game_images/strategy.webp",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DiscoverScreenWidget4(
                        SwitchBlocSearch(), 15.toString())),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGameContainer({
    required String gameName,
    required String imageUrl,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: InkWell(
        onTap: onTap,
        child: Stack(
          children: [
            Container(
              width: 160,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(
                    imageUrl,
                  ),
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    stops: const [0.0, 0.3],
                    colors: [
                      const Color(0xff20232a).withOpacity(1.0),
                      Style.Colors.backgroundColor.withOpacity(0.0),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(8),
                alignment: Alignment.bottomCenter,
                child: Text(
                  gameName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
