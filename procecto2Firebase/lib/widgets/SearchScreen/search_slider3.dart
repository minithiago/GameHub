import 'package:flutter/material.dart';
import 'package:procecto2/bloc/switch_bloc.dart';
import 'package:procecto2/style/theme.dart' as Style;
import 'package:procecto2/widgets/SearchScreen/searchGame.dart';

class SearchSlider3 extends StatefulWidget {
  @override
  _SearchSliderState3 createState() => _SearchSliderState3();
}

class _SearchSliderState3 extends State<SearchSlider3> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildGameContainer(
            gameName: "Assassin's Creed",
            imageUrl: "assets/images/franchise_images/ass.webp",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DiscoverScreenWidget2(
                        SwitchBlocSearch(), "assassins creed")),
              );
            },
          ),
          _buildGameContainer(
            gameName: "Fifa",
            imageUrl: "assets/images/franchise_images/fifa.jpg",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        DiscoverScreenWidget2(SwitchBlocSearch(), "fifa")),
              );
            },
          ),
          _buildGameContainer(
            gameName: "Fallout",
            imageUrl: "assets/images/franchise_images/fallout.jpg",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        DiscoverScreenWidget2(SwitchBlocSearch(), "fallout")),
              );
            },
          ),
          _buildGameContainer(
            gameName: "Resident Evil",
            imageUrl: "assets/images/franchise_images/res.jpg",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DiscoverScreenWidget2(
                        SwitchBlocSearch(), "resident evil")),
              );
            },
          ),
          _buildGameContainer(
            gameName: "Final Fantasy",
            imageUrl: "assets/images/franchise_images/final.webp",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DiscoverScreenWidget2(
                        SwitchBlocSearch(), "final fantasy")),
              );
            },
          ),
          _buildGameContainer(
            gameName: "Grand Theft Auto",
            imageUrl: "assets/images/franchise_images/gta5.jpg",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DiscoverScreenWidget2(
                        SwitchBlocSearch(), "grand theft auto")),
              );
            },
          ),
          _buildGameContainer(
            gameName: "Zelda",
            imageUrl: "assets/images/franchise_images/zelda.jpeg",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        DiscoverScreenWidget2(SwitchBlocSearch(), "zelda")),
              );
            },
          ),
          _buildGameContainer(
            gameName: "Call of duty",
            imageUrl: "assets/images/franchise_images/call.jpg",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DiscoverScreenWidget2(
                        SwitchBlocSearch(), "call of duty")),
              );
            },
          ),
          _buildGameContainer(
            gameName: "Silent Hill",
            imageUrl: "assets/images/franchise_images/silent.jpg",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DiscoverScreenWidget2(
                        SwitchBlocSearch(), "silent hill")),
              );
            },
          ),
          _buildGameContainer(
            gameName: "Mario Bros",
            imageUrl: "assets/images/franchise_images/mario.webp",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        DiscoverScreenWidget2(SwitchBlocSearch(), "mario")),
              );
            },
          ),
          _buildGameContainer(
            gameName: "The Sims",
            imageUrl: "assets/images/franchise_images/sims.jpg",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        DiscoverScreenWidget2(SwitchBlocSearch(), "sims")),
              );
            },
          ),
          _buildGameContainer(
            gameName: "Tomb raider",
            imageUrl: "assets/images/franchise_images/tomb.avif",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DiscoverScreenWidget2(
                        SwitchBlocSearch(), "tomb raider")),
              );
            },
          ),
          _buildGameContainer(
            gameName: "NBA 2k",
            imageUrl: "assets/images/franchise_images/nba.jpg",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        DiscoverScreenWidget2(SwitchBlocSearch(), "nba")),
              );
            },
          ),
          _buildGameContainer(
            gameName: "Star Wars",
            imageUrl: "assets/images/franchise_images/star.jpg",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DiscoverScreenWidget2(
                        SwitchBlocSearch(), "star wars jedi")),
              );
            },
          ),
          _buildGameContainer(
            gameName: "Gran Turismo",
            imageUrl: "assets/images/franchise_images/gt.jpg",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DiscoverScreenWidget2(
                        SwitchBlocSearch(), "gran turismo")),
              );
            },
          ),
          _buildGameContainer(
            gameName: "Monster Hunter",
            imageUrl: "assets/images/franchise_images/monster.jpg",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DiscoverScreenWidget2(
                        SwitchBlocSearch(), "monster hunter")),
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
