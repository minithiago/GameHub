import 'package:flutter/material.dart';
import 'package:procecto2/bloc/switch_bloc.dart';
import 'package:procecto2/style/theme.dart' as Style;
import 'package:procecto2/widgets/SearchScreen/searchPlatform.dart';

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
      height: 130,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildGameContainer(
            gameName: "PS5",
            imageUrl: "assets/images/platform_images/ps5.webp",
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
            imageUrl: "assets/images/platform_images/xbox.jpg",
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
            imageUrl: "assets/images/platform_images/pc.jpg",
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
            imageUrl: "assets/images/platform_images/switch.avif",
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
            imageUrl: "assets/images/platform_images/ps4.webp",
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
            imageUrl: "assets/images/platform_images/psp.jpg",
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
            imageUrl: "assets/images/platform_images/wii.webp",
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
            imageUrl: "assets/images/platform_images/ps3.jpg",
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
            gameName: "Nintendo 64",
            imageUrl: "assets/images/platform_images/n64.webp",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DiscoverScreenWidget3(
                        SwitchBlocSearch(), 4.toString())),
              );
            },
          ),
          _buildGameContainer(
            gameName: "PS2",
            imageUrl: "assets/images/platform_images/ps2.png",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DiscoverScreenWidget3(
                        SwitchBlocSearch(), 8.toString())),
              );
            },
          ),
          _buildGameContainer(
            gameName: "XBOX 360",
            imageUrl: "assets/images/platform_images/xbox360.webp",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DiscoverScreenWidget3(
                        SwitchBlocSearch(), 12.toString())),
              );
            },
          ),
          _buildGameContainer(
            gameName: "Nintendo DS",
            imageUrl: "assets/images/platform_images/ds.jpg",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DiscoverScreenWidget3(
                        SwitchBlocSearch(), 20.toString())),
              );
            },
          ),
          _buildGameContainer(
            gameName: "PlayStation",
            imageUrl: "assets/images/platform_images/ps1.webp",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DiscoverScreenWidget3(
                        SwitchBlocSearch(), 7.toString())),
              );
            },
          ),
          _buildGameContainer(
            gameName: "Nintendo 3DS",
            imageUrl: "assets/images/platform_images/3ds.jpg",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DiscoverScreenWidget3(
                        SwitchBlocSearch(), 37.toString())),
              );
            },
          ),
          _buildGameContainer(
            gameName: "Mobile",
            imageUrl: "assets/images/platform_images/mobile.jpg",
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
              width: 130,
              //height: 130,
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
