import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:procecto2/bloc/switch_bloc.dart';
import 'package:procecto2/elements/loader_element.dart';
import 'package:procecto2/style/theme.dart' as Style;
import 'package:procecto2/widgets/LibraryScreen/librarygames.dart';
import 'package:procecto2/widgets/LibraryScreen/userLibraryGames.dart';

class UserProfilePage extends StatefulWidget {
  final String uid;
  const UserProfilePage({Key? key, required this.uid}) : super(key: key);

  @override
  State<UserProfilePage> createState() => _UserProfilePage();
}

class _UserProfilePage extends State<UserProfilePage> {
  var userData;
  int games = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  getUserData() async {
    try {
      var snap = await FirebaseFirestore.instance
          .collection('Users')
          .where('email', isEqualTo: widget.uid)
          .get();
      userData = snap.docs.first.data();
      await getUserGamesCountByEmail();
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  getUserGamesCountByEmail() async {
    try {
      QuerySnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where('email', isEqualTo: widget.uid)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        String userId = userSnapshot.docs.first.id;
        QuerySnapshot gamesSnapshot = await FirebaseFirestore.instance
            .collection('Users')
            .doc(userId)
            .collection('Games')
            .get();
        games = gamesSnapshot.size;
      } else {
        print(
            'No se encontró ningún usuario con el correo electrónico ${widget.uid}.');
      }
    } catch (e) {
      print('Error obteniendo la cantidad de juegos del usuario: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Style.Colors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Style.Colors.introGrey,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          userData != null ? userData['nickname'] : 'Loading...',
          style: const TextStyle(color: Colors.white),
        ),
        
        
        centerTitle: false,
      ),
      body: isLoading
          ? Center(
              child: buildLoadingWidget(),
            )
          : userData != null
              ? Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            //backgroundColor: Colors.grey,
                            backgroundImage: userData['avatar'] != ""
                              ? NetworkImage(userData['avatar'])
                              : const NetworkImage(
                                  'https://www.shutterstock.com/image-vector/blank-avatar-photo-place-holder-600nw-1095249842.jpg'),
                            radius: 64,
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                const Icon(
                                  SimpleLineIcons.game_controller,
                                  size: 60,
                                  color: Colors.white,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  '$games Games',
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          const Expanded(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                Icon(
                                  SimpleLineIcons.people,
                                  size: 60,
                                  color: Colors.white,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  '3 friends',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                          height:
                              20), // Añade un espacio entre los widgets existentes y el contenedor
                      SizedBox(
                        // Aquí puedes personalizar el contenedor según tus necesidades
                        height: 523,
                        width: double.infinity,
                        //color: Colors.blue,
                        child: SizedBox(
                          //MediaQuery.of(context).size.height - 280, // Altura del contenedor hasta abajo de la pantalla
                          child: UserLibraryScreenWidget(
                            switchBloc,
                            userData['email'],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : const Center(
                  child: Text("Can't load the user information :( "),
                ),
    );
  }
}
