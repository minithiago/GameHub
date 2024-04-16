import 'package:flutter/material.dart';
import 'package:procecto2/bloc/switch_bloc.dart';
import 'package:procecto2/style/theme.dart' as Style;

import 'package:procecto2/widgets/searchGame.dart';

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
      height: 200,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildGameContainer(
            gameName: "Assassin's Creed",
            imageUrl:
                "https://cdn.hobbyconsolas.com/sites/navi.axelspringer.es/public/media/image/2023/10/assassins-creed-3191212.jpg",
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
            imageUrl:
                "https://www.fifa-infinity.com/wp-content/uploads/2022/05/ea-sports-fc-cover.jpg",
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
            imageUrl:
                "https://static1.thegamerimages.com/wordpress/wp-content/uploads/2023/07/what-year-does-every-fallout-game-take-place.jpg",
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
            imageUrl:
                "https://clan.akamai.steamstatic.com/images/33273264/0b977c32c1266e74151b97e7e5f621c4df2858c5.jpg",
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
            imageUrl:
                "https://venturebeat.com/wp-content/uploads/2016/12/ffstorylogo.jpg?fit=1280%2C786&strip=all",
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
            imageUrl:
                "https://www.gamespot.com/a/uploads/scale_medium/1552/15524586/3305407-the-evolution-of-grand-theft-auto-promo-1-2.jpg",
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
            imageUrl:
                "https://static1.cbrimages.com/wordpress/wp-content/uploads/2020/11/Legend-of-Zelda-25th-Anniversary-Image.jpg",
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
            imageUrl: "https://hd2.tudocdn.net/913234?w=824&h=494",
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
            imageUrl:
                "https://deadtalknews.com/wp-content/uploads/Town-of-Silent-Hill-930x620.jpg",
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
            gameName: "The Sims",
            imageUrl:
                "https://media.vandal.net/i/640x360/10-2023/18/2023101822291723_1.jpg",
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
            gameName: "NBA 2k",
            imageUrl:
                "https://esportsbureau.com/wp-content/uploads/2017/03/NB2keLeague.jpg",
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
            imageUrl:
                "https://qph.cf2.quoracdn.net/main-qimg-f32362ea23333c00d1c01224e15273a1-lq",
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
            imageUrl:
                "https://image.api.playstation.com/vulcan/ap/rnd/202109/1321/3GEdKTGktTBsZ8Sj9yIWnr2f.jpg",
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
            imageUrl: "https://i.redd.it/xw204obxwxb91.jpg",
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
              width: 170,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
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
                    fontSize: 24,
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
