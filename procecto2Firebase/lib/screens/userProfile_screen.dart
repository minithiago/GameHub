import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:procecto2/bloc/switch_bloc.dart';
import 'package:procecto2/elements/loader_element.dart';
import 'package:procecto2/repository/user_repository.dart';
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
  var userData2;
  int games = 0;
  int friends = 0;
  int contieneAmigo = 0;
  int requestSent = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getUserData();
    getUserData2();
  }

  getUserData() async {
    try {
      var snap = await FirebaseFirestore.instance
          .collection('Users')
          .where('email', isEqualTo: widget.uid)
          .get();
      userData = snap.docs.first.data();

      if (snap.docs.isNotEmpty) {
        String userId2 = snap.docs.first.id;
        QuerySnapshot email2Snapshot = await FirebaseFirestore.instance
            .collection('Users')
            .doc(userId2)
            .collection('Requests')
            .where('email', isEqualTo: userData2['email'])
            .get();
        requestSent = email2Snapshot.size;
        if (requestSent >= 1) {
          contieneAmigo == 3;
        }
      } else {
        print(
            'No se encontró ningún usuario con el correo electrónico ${widget.uid}.');
      }
      await getUserContainsEmailFriend();
      await getUserGamesCountByEmail();
      await getUserFriendsCountByEmail();

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

  getUserData2() async {
    try {
      var snap = await FirebaseFirestore.instance
          .collection('Users')
          .where('email',
              isEqualTo: FirebaseAuth.instance.currentUser!.email.toString())
          .get();
      userData2 = snap.docs.first.data();

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

  getUserFriendsCountByEmail() async {
    try {
      QuerySnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where('email', isEqualTo: widget.uid)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        String userId = userSnapshot.docs.first.id;
        QuerySnapshot friendsSnapshot = await FirebaseFirestore.instance
            .collection('Users')
            .doc(userId)
            .collection('Friends')
            .get();
        friends = friendsSnapshot.size;
      } else {
        print(
            'No se encontró ningún usuario con el correo electrónico ${widget.uid}.');
      }
    } catch (e) {
      print('Error obteniendo la cantidad de juegos del usuario: $e');
    }
  }

  getUserContainsEmailFriend() async {
    try {
      QuerySnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where('email', isEqualTo: userData2['email'])
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        String userId = userSnapshot.docs.first.id;
        QuerySnapshot emailSnapshot = await FirebaseFirestore.instance
            .collection('Users')
            .doc(userId)
            .collection('Friends')
            .where('email', isEqualTo: userData['email'])
            .get();

        contieneAmigo = emailSnapshot.size;

        if (requestSent >= 1) {
          contieneAmigo = 3;
        } else {
          contieneAmigo = contieneAmigo;
        }
      } else {
        print(
            'No se encontró ningún usuario con el correo electrónico ${widget.uid}.');
      }
    } catch (e) {
      print('Error obteniendo la cantidad de juegos del usuario: $e');
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

  Widget buildFriendButton({
    required bool isFriend,
    required VoidCallback onPressed,
    required Color backgroundColor,
    required Icon icon,
    required String text,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor, // Color de fondo del botón
        shape: RoundedRectangleBorder(
          // Forma del botón con bordes redondeados
          borderRadius: BorderRadius.circular(20), // Radio de los bordes
        ),
        minimumSize: const Size(130, 40),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon, // Icono
          const SizedBox(width: 3), // Espacio entre el icono y el texto
          Text(
            text,
            style: const TextStyle(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          color: Theme.of(context).colorScheme.primary,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          userData != null ? userData['nickname'] : 'Loading...',
          style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
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
                            radius: 60,
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
                                  //color: Colors.white,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  '$games Games',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                const Icon(
                                  SimpleLineIcons.people,
                                  size: 60,
                                  //color: Colors.white,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  '$friends Friends',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Visibility(
                        visible: contieneAmigo == 3,
                        child: buildFriendButton(
                          isFriend: true,
                          onPressed: () async {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Request already sent")),
                            );
                          },
                          backgroundColor: Colors.orange,
                          icon: const Icon(Icons.schedule_send_rounded),
                          text: "  Request sent",
                        ),
                      ),
                      Visibility(
                        visible: contieneAmigo == 1,
                        child: buildFriendButton(
                          isFriend: true,
                          onPressed: () async {
                            await UserRepository().removeFriend(
                              FirebaseAuth.instance.currentUser!.email
                                  .toString(),
                              userData['email'],
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Friend removed successfully")),
                            );
                          },
                          backgroundColor: Colors.red,
                          icon: const Icon(Icons.group_remove_rounded),
                          text: "  Remove friend",
                        ),
                      ),
                      Visibility(
                        visible: contieneAmigo == 0,
                        child: buildFriendButton(
                          isFriend: false,
                          onPressed: () async {
                            await UserRepository().sendFriendRequest(
                              FirebaseAuth.instance.currentUser!.email
                                  .toString(),
                              userData2['nickname'],
                              userData2['avatar'],
                              userData['email'],
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Friend Request sent")),
                            );
                          },
                          backgroundColor:
                              const Color.fromRGBO(110, 182, 255, 1),
                          icon: const Icon(Icons.group_add_rounded),
                          text: "  Add as friend",
                        ),
                      ),

                      Expanded(
                        child: SizedBox(
                          //MediaQuery.of(context).size.height - 280, // Altura del contenedor hasta abajo de la pantalla
                          child: UserLibraryScreenWidget(
                            switchBloc,
                            userData['email'],
                          ),
                        ),
                      ) // Añade un espacio entre los widgets existentes y el contenedor
                    ],
                  ),
                )
              : const Center(
                  child: Text("Can't load the user information :( "),
                ),
    );
  }
}
