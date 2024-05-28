import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:procecto2/bloc/switch_bloc.dart';
import 'package:procecto2/elements/loader_element.dart';
import 'package:procecto2/repository/user_repository.dart';
import 'package:procecto2/widgets/LibraryScreen/userLibraryGames.dart';

class UserProfilePage extends StatefulWidget {
  final String uid;
  const UserProfilePage({Key? key, required this.uid}) : super(key: key);

  @override
  State<UserProfilePage> createState() => _UserProfilePage();
}

class _UserProfilePage extends State<UserProfilePage> {
  var userData; //perfil que visito
  var userData2; //usuario logueado
  int games = 0;
  int friends = 0;
  int contieneAmigo = 0; //5
  int requestSent = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    await fetchCurrentUserData();
    await fetchUserData();
    await Future.wait([
      fetchUserFriendsCount(),
      fetchUserGamesCount(),
      fetchContainsEmailFriend()
    ]);

    setState(() {
      isLoading = false;
    });
  }

  Future<void> fetchUserData() async {
    try {
      var snap = await getUserByEmail(widget.uid);
      if (snap.docs.isNotEmpty) {
        userData = snap.docs.first.data();
        String userId2 = snap.docs.first.id;
        var email2Snapshot = await getUserRequests(userId2, userData2['email']);
        requestSent = email2Snapshot.size;
        if (requestSent >= 1) {
          contieneAmigo = 3;
        }
      } else {
        print(
            'No se encontró ningún usuario con el correo electrónico ${widget.uid}.');
      }
    } catch (e) {
      print('Error obteniendo datos del usuario: $e');
    }
  }

  Future<void> fetchCurrentUserData() async {
    try {
      var snap2 = await getUserByEmail(
          FirebaseAuth.instance.currentUser!.email.toString());
      if (snap2.docs.isNotEmpty) {
        userData2 = snap2.docs.first.data();
      } else {
        print(
            'No se encontró ningún usuario con el correo electrónico actual.');
      }
    } catch (e) {
      print('Error obteniendo datos del usuario actual: $e');
    }
  }

  Future<void> fetchUserFriendsCount() async {
    try {
      var userSnapshot = await getUserByEmail(widget.uid);
      if (userSnapshot.docs.isNotEmpty) {
        String userId = userSnapshot.docs.first.id;
        var friendsSnapshot = await getUserCollectionSize(userId, 'Friends');
        friends = friendsSnapshot.size;
      } else {
        print(
            'No se encontró ningún usuario con el correo electrónico ${widget.uid}.');
      }
    } catch (e) {
      print('Error obteniendo la cantidad de amigos del usuario: $e');
    }
  }

  Future<void> fetchUserGamesCount() async {
    try {
      var userSnapshot = await getUserByEmail(widget.uid);
      if (userSnapshot.docs.isNotEmpty) {
        String userId = userSnapshot.docs.first.id;
        var gamesSnapshot = await getUserCollectionSize(userId, 'Games');
        games = gamesSnapshot.size;
      } else {
        print(
            'No se encontró ningún usuario con el correo electrónico ${widget.uid}.');
      }
    } catch (e) {
      print('Error obteniendo la cantidad de juegos del usuario: $e');
    }
  }

  Future<void> fetchContainsEmailFriend() async {
    try {
      String? currentUserEmail = FirebaseAuth.instance.currentUser?.email;
      if (currentUserEmail == null) {
        print('No se encontró ningún correo electrónico de usuario actual.');
        return;
      }

      var userSnapshot = await getUserByEmail(currentUserEmail);
      if (userSnapshot.docs.isEmpty) {
        print(
            'No se encontró ningún usuario con el correo electrónico actual.');
        return;
      }

      String userId = userSnapshot.docs.first.id;

      // Asegurarse de que userData no sea nulo
      if (userData == null) {
        print('userData no está inicializado .');
        return;
      }
      if (!userData.containsKey('email')) {
        print('userData no contiene la clave "email".');
        return;
      }

      var emailSnapshot = await getUserCollectionWhere(
          userId, 'Friends', 'email', userData['email']);
      print('Tamaño de emailSnapshot: ${emailSnapshot.size}');

      setState(() {
        contieneAmigo = (requestSent >= 1) ? 3 : emailSnapshot.size;
      });
    } catch (e) {
      print('Error obteniendo si el email contiene al amigo del usuario: $e');
    }
  }

  Future<QuerySnapshot> getUserByEmail(String email) {
    return FirebaseFirestore.instance
        .collection('Users')
        .where('email', isEqualTo: email)
        .get();
  }

  Future<QuerySnapshot> getUserRequests(String userId, String email) {
    return FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .collection('Requests')
        .where('email', isEqualTo: email)
        .get();
  }

  Future<QuerySnapshot> getUserCollectionSize(
      String userId, String collection) {
    return FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .collection(collection)
        .get();
  }

  Future<QuerySnapshot> getUserCollectionWhere(
      String userId, String collection, String field, String value) {
    return FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .collection(collection)
        .where(field, isEqualTo: value)
        .get();
  }

  Widget buildActionButton() {
    if (contieneAmigo == 3) {
      return ElevatedButton(
        onPressed: () async {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Request already sent")),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange, // Color de fondo del botón
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // Radio de los bordes
          ),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.schedule_send), // El icono del botón
            SizedBox(width: 8), // Espacio entre el icono y el texto
            Text('  Request sent'),
          ],
        ),
      );
    } else if (contieneAmigo > 0) {
      return ElevatedButton(
        onPressed: () async {
          await UserRepository().removeFriend(
            FirebaseAuth.instance.currentUser!.email.toString(),
            userData['email'],
          );
          await UserRepository().removeFriend(userData['email'],
              FirebaseAuth.instance.currentUser!.email.toString());
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Friend removed successfully")),
          );
          setState(() {
            contieneAmigo = 0;
            print(contieneAmigo);
            print(requestSent);
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red, // Color de fondo del botón
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // Radio de los bordes
          ),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.group_remove_rounded), // El icono del botón
            SizedBox(width: 8), // Espacio entre el icono y el texto
            Text('  Remove friend'),
          ],
        ),
      );
    } else {
      return ElevatedButton(
        onPressed: () async {
          await UserRepository().sendFriendRequest(
            FirebaseAuth.instance.currentUser!.email.toString(),
            userData2['nickname'],
            userData2['avatar'],
            userData['email'],
          );
          setState(() {
            contieneAmigo = 3;
            print(contieneAmigo);
            print(requestSent);
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Friend Request sent")),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromRGBO(
              110, 182, 255, 1), // Color de fondo del botón
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // Radio de los bordes
          ),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.group_add_rounded), // El icono del botón
            SizedBox(width: 8), // Espacio entre el icono y el texto
            Text('  Add as friend'),
          ],
        ),
      );
    }
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
                  padding: const EdgeInsets.only(top: 16, left: 0, right: 0),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            width: 15,
                          ),
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
                      buildActionButton(),

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
