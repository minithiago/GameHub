import 'package:flutter/material.dart';
import 'package:procecto2/bloc/switch_bloc.dart';

import 'package:procecto2/style/theme.dart' as Style;
//import 'package:procecto2/widgets/home_slider.dart';
import 'package:procecto2/widgets/home_slider2.dart';
import 'package:procecto2/widgets/searchGamesScroll.dart';

import 'package:procecto2/widgets/searchGame.dart';
import 'package:procecto2/widgets/search_slider.dart';
import 'package:procecto2/widgets/search_slider2.dart';
import 'package:procecto2/widgets/search_slider3.dart';

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
      backgroundColor: Style.Colors.backgroundColor,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            automaticallyImplyLeading: false,
             
            pinned: false, //que se mantenga fija
            floating: true,
            backgroundColor: Style.Colors.backgroundColor,
            // Color de fondo de la barra de búsqueda
            title: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                fillColor: Colors.grey,
                filled: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                hintText: "eg: Elden Ring",
                hintStyle: const TextStyle(color: Colors.white),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    print(_searchController.text);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DiscoverScreenWidget2(
                              SwitchBlocSearch(), _searchController.text)),
                    );
                  },
                  color: Colors.white,
                ),
              ),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "  Browse by genre",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
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
                              "  Incoming games",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                        HomeSlider2(),
                        const SizedBox(height: 10),
                        const Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "  Search by platform",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                          ],
                        ),
                        SearchSlider2(),
                        const SizedBox(height: 10),
                        const Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "  Popular franchises",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
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
                              "  Top rated games",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                          ],
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 600,
                          child: DiscoverScreenWidget5(SwitchBloc()),
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
