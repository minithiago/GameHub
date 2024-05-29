import 'package:flutter/material.dart';
import 'package:procecto2/bloc/switch_bloc.dart';
import 'package:procecto2/widgets/SearchScreen/searchCompany.dart';

class SearchSliderCompanies extends StatefulWidget {
  const SearchSliderCompanies({super.key});

  @override
  _SearchSliderCompanies createState() => _SearchSliderCompanies();
}

class _SearchSliderCompanies extends State<SearchSliderCompanies> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 250, // Ajusta la altura según el tamaño de los elementos
        child: GridView.builder(
            scrollDirection: Axis.horizontal,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Número de filas
              mainAxisSpacing: 0.0,
              crossAxisSpacing: 0.0,
              // Ajusta la relación de aspecto según tus necesidades
            ),
            itemCount: gameData.length, // Número total de elementos
            itemBuilder: (context, index) {
              return _buildGameContainer(
                gameName: gameData[index]['name'],
                imageUrl: gameData[index]['imageUrl'],
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DiscoverScreenWidget7(
                        SwitchBlocSearch(),
                        gameData[index]['id'].toString(),
                      ),
                    ),
                  );
                },
              );
            }));
  }

  List<Map<String, dynamic>> gameData = [
    {
      'name': 'Ubisoft',
      'imageUrl': 'assets/images/companies_images/ubi.png',
      'id': "Ubisoft Entertainment", //45
    },
    {
      'name': 'EA',
      'imageUrl': 'assets/images/companies_images/ea.webp',
      'id': 'Electronic Arts',
    },
    {
      'name': 'Blizzard',
      'imageUrl': 'assets/images/companies_images/blizzard.jpg',
      'id': 'Blizzard Entertainment',
    },
    {
      'name': 'Capcom',
      'imageUrl': 'assets/images/companies_images/capcom.webp',
      'id': 'Capcom',
    },
    {
      'name': 'Rockstar',
      'imageUrl': 'assets/images/companies_images/rockstar.png',
      'id': 'Rockstar Games',
    },
    {
      'name': 'Nintendo',
      'imageUrl': 'assets/images/companies_images/nintendo.png',
      'id': 'Nintendo',
    },
    {
      'name': 'Riot Games',
      'imageUrl': 'assets/images/companies_images/riot.jpg',
      'id': 'Riot Games',
    },
    {
      'name': 'Epic games',
      'imageUrl': 'assets/images/companies_images/epic.png',
      'id': 'Epic Games',
    },
    {
      'name': 'Konami',
      'imageUrl': 'assets/images/companies_images/konami.png',
      'id': 'Konami',
    },
    {
      'name': 'Sega',
      'imageUrl': 'assets/images/companies_images/sega.png',
      'id': 'Sega',
    },
    {
      'name': 'Sony',
      'imageUrl': 'assets/images/companies_images/sony.jpg',
      'id': 'Sony Computer Entertainment',
    },
    {
      'name': 'Take Two',
      'imageUrl': 'assets/images/companies_images/takeTwo.png',
      'id': 'Take-Two Interactive',
    },
    {
      'name': 'Tencent',
      'imageUrl': 'assets/images/companies_images/tencent.jpg',
      'id': 'Tencent Games',
    },
    {
      'name': 'Valve',
      'imageUrl': 'assets/images/companies_images/valve.webp',
      'id': 'Valve',
    },
    {
      'name': 'Bandai Namco',
      'imageUrl': 'assets/images/companies_images/bandai.jpg',
      'id': 'Bandai Namco Entertainment',
    },
    {
      'name': 'Square Enix',
      'imageUrl': 'assets/images/companies_images/square.png',
      'id': 'Square Enix',
    },
    {
      'name': 'Activision',
      'imageUrl': 'assets/images/companies_images/activision.png',
      'id': 'Activision',
    },
    {
      'name': 'Bethesda',
      'imageUrl': 'assets/images/companies_images/Bethesda.png',
      'id': 'Bethesda Game Studios',
    },
    {
      'name': 'FromSoftware',
      'imageUrl': 'assets/images/companies_images/from.webp',
      'id': 'FromSoftware',
    },
    {
      'name': 'Naugthy Dog',
      'imageUrl': 'assets/images/companies_images/dog.jpg',
      'id': 'Naughty Dog',
    },
  ];

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
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(
                    imageUrl,
                  ),
                ),
              ),
              /*
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
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
              */
            ),
            /*
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
            ),*/
          ],
        ),
      ),
    );
  }
}
