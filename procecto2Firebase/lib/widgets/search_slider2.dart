import 'package:flutter/material.dart';
import 'package:procecto2/bloc/switch_bloc.dart';
import 'package:procecto2/style/theme.dart' as Style;
import 'package:procecto2/widgets/searchPlatform.dart';
import 'package:procecto2/widgets/searchGame.dart';

class SearchSlider2 extends StatefulWidget {
  @override
  _SearchSliderState2 createState() => _SearchSliderState2();
}

class _SearchSliderState2 extends State<SearchSlider2> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildGameContainer(
            gameName: "PS5",
            imageUrl:
                "https://images.stockx.com/360/Sony-PS5-Playstation-5-Blu-Ray-Edition-Console-White/Images/Sony-PS5-Playstation-5-Blu-Ray-Edition-Console-White/Lv2/img01.jpg?fm=webp&auto=compress&w=480&dpr=2&updated_at=1635746961&h=320&q=60",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DiscoverScreenWidget3(
                        SwitchBlocSearch(), 167.toString())),
              );
            },
          ),
          _buildGameContainer(
            gameName: "XBOX",
            imageUrl:
                "https://www.esdorado.com/3821-large_default/consolas-xbox-de-la-serie-x-de-microsoft.jpg",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DiscoverScreenWidget3(
                        SwitchBlocSearch(), 49.toString())),
              );
            },
          ),
          _buildGameContainer(
            gameName: "PC",
            imageUrl:
                "https://www.neobyte.es/107280-home_default/pc-neo-powered-by-asus-i5-14600k-rtx-4060ti-ssd-2tb-32gb.jpg",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DiscoverScreenWidget3(
                        SwitchBlocSearch(), 6.toString())),
              );
            },
          ),
          _buildGameContainer(
            gameName: "Nintendo Switch",
            imageUrl:
                "https://cdn1.coppel.com/images/catalog/mkp/7532/3000/75321008-1.jpg",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DiscoverScreenWidget3(
                        SwitchBlocSearch(), 130.toString())),
              );
            },
          ),
          _buildGameContainer(
            gameName: "PS4",
            imageUrl:
                "https://upload.wikimedia.org/wikipedia/commons/thumb/7/71/Sony-PlayStation-4-PS4-wDualShock-4.jpg/640px-Sony-PlayStation-4-PS4-wDualShock-4.jpg",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DiscoverScreenWidget3(
                        SwitchBlocSearch(), 48.toString())),
              );
            },
          ),
          _buildGameContainer(
            gameName: "PSP",
            imageUrl: "https://m.media-amazon.com/images/I/51OozvqUYpS.jpg",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DiscoverScreenWidget3(
                        SwitchBlocSearch(), 38.toString())),
              );
            },
          ),
          _buildGameContainer(
            gameName: "Wii",
            imageUrl:
                "https://www.backmarket.es/cdn-cgi/image/format%3Dauto%2Cquality%3D75%2Cwidth%3D260/https://d2e6ccujb3mkqf.cloudfront.net/9d8040aa-3cc5-4d84-8a3f-dac513264d55-1_c429371b-6867-46a0-a2a5-c4cc65465f77.jpg",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DiscoverScreenWidget3(
                        SwitchBlocSearch(), 5.toString())),
              );
            },
          ),
          _buildGameContainer(
            gameName: "PS3",
            imageUrl:
                "https://i5.walmartimages.com/asr/7348e500-9536-4ee6-9117-1bc0949fe008.4d224836742f0cc1d9529023d521e2cf.jpeg",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DiscoverScreenWidget3(
                        SwitchBlocSearch(), 9.toString())),
              );
            },
          ),
          _buildGameContainer(
            gameName: "Mobile",
            imageUrl:
                "https://cdndailyexcelsior.b-cdn.net/wp-content/uploads/2021/11/Best-Free-Android-Games.jpg",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DiscoverScreenWidget3(
                        SwitchBlocSearch(), 34.toString())),
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
              width: 150,
              height: 150,
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
