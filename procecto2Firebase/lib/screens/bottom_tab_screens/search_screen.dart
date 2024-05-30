import 'package:flutter/material.dart';
import 'package:procecto2/bloc/switch_bloc.dart';
import 'package:procecto2/screens/games_screens/gamesSearch_screen.dart';
import 'package:procecto2/widgets/DiscoverScreen/home_slider2.dart';
import 'package:procecto2/widgets/DiscoverScreen/home_slider3.dart';
import 'package:procecto2/widgets/SearchScreen/searchGame.dart';
//import 'package:procecto2/widgets/SearchScreen/searchGamesGrid.dart';
import 'package:procecto2/widgets/SearchScreen/search_slider.dart';
import 'package:procecto2/widgets/SearchScreen/search_slider2.dart';
import 'package:procecto2/widgets/SearchScreen/search_slider3.dart';
import 'package:procecto2/widgets/SearchScreen/search_sliderCompanies.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenWidgetState createState() => _SearchScreenWidgetState();
}

class _SearchScreenWidgetState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            automaticallyImplyLeading: false,
            pinned: false, //que se mantenga fija
            floating: true, //que aparezca cuando se desliza hacia arriba
            backgroundColor:
                Colors.transparent, // Color de fondo de la barra de búsqueda

            title: TextField(
              controller: _searchController,
              style: const TextStyle(
                  //color: Colors.white
                  ),
              decoration: InputDecoration(
                fillColor: Colors.grey,
                filled: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 26),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                hintText: "Search games", //"eg: Elden Ring",
                hintStyle: const TextStyle(
                    //color: Colors.white
                    ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    // print(_searchController.text);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DiscoverScreenWidget2(
                              SwitchBlocSearch(), _searchController.text)),
                    );
                  },
                  //color: Colors.white,
                ),
              ),
              onSubmitted: (_) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DiscoverScreenWidget2(
                          SwitchBlocSearch(), _searchController.text)),
                );
              },
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  const SizedBox(height: 10),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    child: Column(
                      children: [
                        const Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "Popular developers",
                              style: TextStyle(
                                //color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                          ],
                        ),
                        const SearchSliderCompanies(),
                        const Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "Browse by genre",
                              style: TextStyle(
                                //color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                          ],
                        ),
                        SearchSlider(),
                        const SizedBox(height: 10),
                        const Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "Most Anticipated Games",
                              style: TextStyle(
                                //color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                        const HomeSlider2(),
                        const SizedBox(height: 10),
                        const Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "Search by platform",
                              style: TextStyle(
                                //color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                          ],
                        ),
                        SearchSlider2(),
                        /*
                        const Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "  Developers",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                          ],
                        ),
                        SearchSlider3(),*/
                        const Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "Incoming expansions",
                              style: TextStyle(
                                //color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                        const HomeSlider3(),
                        const SizedBox(height: 10),
                        const Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "Popular franchises",
                              style: TextStyle(
                                //color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                          ],
                        ),
                        SearchSlider3(),
                        const SizedBox(height: 10),
                        const Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "Top rated games",
                              style: TextStyle(
                                //color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                          ],
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 600, //600
                          //child: DiscoverScreenWidget5(SwitchBloc()),
                          child: SearchScreenScroll(),
                        )
                        //DiscoverScreenWidget2(SwitchBlocSearch(), "fifa")
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
