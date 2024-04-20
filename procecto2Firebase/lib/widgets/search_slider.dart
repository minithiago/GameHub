import 'package:flutter/material.dart';
import 'package:procecto2/bloc/switch_bloc.dart';
import 'package:procecto2/style/theme.dart' as Style;
import 'package:procecto2/widgets/searchGenre.dart';
import 'package:procecto2/widgets/searchGame.dart';

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
      height: 200,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildGameContainer(
            gameName: "RPG",
            imageUrl:
                "https://m.economictimes.com/thumb/msid-106052010,width-1600,height-900,resizemode-4,imgsize-59110/elden-ring-2-all-you-may-want-to-know-about-the-upcoming-game.jpg",
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
            imageUrl:
                "https://www.lavanguardia.com/files/og_thumbnail/uploads/2016/05/05/5fa2d332040f7.jpeg",
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
            imageUrl:
                "https://assets-prd.ignimgs.com/2022/08/10/virtua-fighter-5-1622044370501-1660101100598.jpg",
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
            imageUrl:
                "https://assetsio.gnwcdn.com/ar89t.jpg?width=1200&height=1200&fit=bounds&quality=70&format=jpg&auto=webp",
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
            imageUrl:
                "https://cdn.mos.cms.futurecdn.net/XCBwkemeV66dQ49r7CQbJP.jpg",
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
            imageUrl:
                "https://xxboxnews.blob.core.windows.net/prod/sites/2/genres_sports_hero.jpg",
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
            imageUrl: "https://i.ytimg.com/vi/vKlsja5s0rw/maxresdefault.jpg",
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
            imageUrl:
                "https://img.redbull.com/images/q_auto,f_auto/redbullcom/2013/09/16/1331611589333_2/las-cosas-que-no-sab%C3%ADas-sobre-el-pac-man.jpg",
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
            imageUrl:
                "https://miro.medium.com/v2/resize:fit:1120/0*znmTHTVBkCHtzulW.png",
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
            imageUrl:
                "https://upload.wikimedia.org/wikipedia/commons/thumb/9/9e/Fretsonfire4.png/220px-Fretsonfire4.png",
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
            imageUrl:
                "https://static.eldiario.es/clip/979dc556-5e26-458e-9ebd-fd2ce0766703_16-9-aspect-ratio_default_0.jpg",
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
            imageUrl:
                "https://cdn.wccftech.com/wp-content/uploads/2017/12/Platform-Games.jpg",
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
            imageUrl:
                "https://cdn.techinasia.com/wp-content/uploads/2014/04/018.png",
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
            imageUrl:
                "https://play-lh.googleusercontent.com/Ol5li8ELSxLQ2sPlnJd7rJIY1iOYHHUwiop7E5CwctozVQXimF1QwI1zQhdzzyIiYw=w526-h296-rw",
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
                    fontSize: 20,
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
