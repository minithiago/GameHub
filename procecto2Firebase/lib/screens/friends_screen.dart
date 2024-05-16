import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:procecto2/elements/loader_element.dart';
import 'package:procecto2/repository/user_repository.dart';
import 'package:procecto2/screens/main_screen.dart';
import 'package:procecto2/screens/userProfile_screen.dart';
import 'package:procecto2/style/theme.dart' as Style;

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({super.key});

  @override
  _FriendsScreenState createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  //final _formKey = GlobalKey<FormState>();
  final TextEditingController _searchController = TextEditingController();
  bool isShowUsers = false;

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        appBar: AppBar(
          backgroundColor:
              Theme.of(context).colorScheme.background, //background
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            color: Theme.of(context).colorScheme.primary,
            onPressed: () {
              Navigator.of(context).pop();
              /*Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  const LibraryScreen(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            const begin = Offset(1.0, 0.0);
                            const end = Offset.zero;
                            const curve = Curves.ease;

                            var tween = Tween(begin: begin, end: end)
                                .chain(CurveTween(curve: curve));
                            var offsetAnimation = animation.drive(tween);

                            return SlideTransition(
                              position: offsetAnimation,
                              child: child,
                            );
                          },
                          transitionDuration: const Duration(milliseconds: 250),
                        ),
                      );*/
            },
          ),
          title: TextFormField(
            controller: _searchController,
            style: const TextStyle(
                //color: Colors.white
                ),
            decoration: InputDecoration(
              fillColor: Colors.grey,
              filled: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide.none,
              ),
              hintText: "Search users",
              hintStyle: const TextStyle(
                  //color: Colors.white
                  ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  //print(_searchController.text);
                  setState(() {
                    isShowUsers = true;
                  });
                },
                //color: Colors.white,
              ),
            ),
            onFieldSubmitted: (_) {
              setState(() {
                isShowUsers = true;
              });
            },
          ),
        ),
        body: isShowUsers
            ? FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('Users')
                    .where('nickname',
                        isGreaterThanOrEqualTo: _searchController.text)
                    .get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: buildLoadingWidget(),
                    );
                  }
                  return ListView.builder(
                    itemBuilder: (context, index) {
                      final userData =
                          (snapshot.data! as dynamic).docs[index].data();
                      return GestureDetector(
                        onTap: () {
                          // Navegar a la página del perfil del usuario
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserProfilePage(
                                uid: userData[
                                    'email'], // Ajusta la clave del usuario en tu base de datos
                              ),
                            ),
                          );
                        },
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 23,
                            backgroundImage: userData['avatar'] != ""
                                ? NetworkImage(userData['avatar'])
                                : const NetworkImage(
                                    'https://www.shutterstock.com/image-vector/blank-avatar-photo-place-holder-600nw-1095249842.jpg'),
                          ),
                          title: Text(
                            userData['nickname'],
                            style: const TextStyle(
                              fontSize: 18,
                              //fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: (snapshot.data! as dynamic).docs.length,
                  );
                },
              ) //SI NO BUSCA APARECE LAS REQUEST Y DEBAJO LOS AMIGOS
            : Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 5, top: 25),
                    color: Theme.of(context).colorScheme.secondary,
                    child: const Row(children: [
                      Text(
                        "  Friend requests",
                        textAlign:
                            TextAlign.center, // Centra el texto horizontalmente
                        style: TextStyle(
                          //color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ]),
                  ),
                  //REQUESTS
                  FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('Users')
                        .where('email',
                            isEqualTo: FirebaseAuth.instance.currentUser!.email)
                        .get()
                        .then((querySnapshot) {
                      if (querySnapshot.docs.isNotEmpty) {
                        return FirebaseFirestore.instance
                            .collection('Users')
                            .doc(querySnapshot.docs.first.id)
                            .collection('Requests')
                            .get();
                      } else {
                        throw Exception("User not found");
                      }
                    }),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: buildLoadingWidget(), // Tu widget de carga
                        );
                      }
                      print(
                          FirebaseAuth.instance.currentUser!.email.toString());

                      var requests = (snapshot.data! as QuerySnapshot).docs;

                      return ListView.builder(
                        shrinkWrap:
                            true, // Added to ensure the ListView takes only the necessary space
                        physics:
                            NeverScrollableScrollPhysics(), // Prevent ListView from scrolling independently
                        itemCount: requests.length,
                        itemBuilder: (context, index) {
                          var userData =
                              requests[index].data() as Map<String, dynamic>;

                          return GestureDetector(
                            onTap: () {
                              // Navegar a la página del perfil del usuario
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UserProfilePage(
                                    uid: userData[
                                        'email'], // Ajusta la clave del usuario en tu base de datos
                                  ),
                                ),
                              );
                            },
                            child: ListTile(
                              tileColor:
                                  Theme.of(context).colorScheme.secondary,
                              leading: CircleAvatar(
                                radius: 23,
                                backgroundImage: userData['avatar'] != ""
                                    ? NetworkImage(userData['avatar'])
                                    : const NetworkImage(
                                        'https://www.shutterstock.com/image-vector/blank-avatar-photo-place-holder-600nw-1095249842.jpg'),
                              ),
                              title: Text(
                                userData['nickname'],
                                style: const TextStyle(
                                  fontSize: 18,
                                  //fontWeight: FontWeight.bold,
                                ),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.check,
                                        color: Colors.green, size: 30),
                                    onPressed: () {
                                      // Lógica para aceptar la solicitud de amistad
                                      UserRepository().acceptFriendRequest(
                                          FirebaseAuth
                                              .instance.currentUser!.email
                                              .toString(),
                                          userData['nickname'],
                                          userData['avatar'],
                                          userData['email']);
                                      setState(() {});
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  "Friend Request accepted")));
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.close,
                                        color: Colors.red, size: 30),
                                    onPressed: () {
                                      UserRepository().declineFriendRequest(
                                          FirebaseAuth
                                              .instance.currentUser!.email
                                              .toString(),
                                          userData['nickname'],
                                          userData['avatar'],
                                          userData['email']);
                                      setState(() {});
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  "Friend request denied")));
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 5, top: 25),
                    color: Theme.of(context).colorScheme.secondary,
                    child: const Row(children: [
                      Text(
                        "  Friends",
                        textAlign:
                            TextAlign.center, // Centra el texto horizontalmente
                        style: TextStyle(
                          //color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ]),
                  ),
                  //FRIENDS
                  FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('Users')
                        .where('email',
                            isEqualTo: FirebaseAuth.instance.currentUser!.email)
                        .get()
                        .then((querySnapshot) {
                      if (querySnapshot.docs.isNotEmpty) {
                        return FirebaseFirestore.instance
                            .collection('Users')
                            .doc(querySnapshot.docs.first.id)
                            .collection('Friends')
                            .get();
                      } else {
                        throw Exception("User not found");
                      }
                    }),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: buildLoadingWidget(), // Tu widget de carga
                        );
                      }

                      var friends = (snapshot.data! as QuerySnapshot).docs;

                      return ListView.builder(
                        shrinkWrap:
                            true, // Added to ensure the ListView takes only the necessary space
                        physics:
                            NeverScrollableScrollPhysics(), // Prevent ListView from scrolling independently
                        itemCount: friends.length,
                        itemBuilder: (context, index) {
                          var userData =
                              friends[index].data() as Map<String, dynamic>;

                          return GestureDetector(
                            onTap: () {
                              // Navegar a la página del perfil del usuario
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UserProfilePage(
                                    uid: userData[
                                        'email'], // Ajusta la clave del usuario en tu base de datos
                                  ),
                                ),
                              );
                            },
                            child: ListTile(
                              tileColor:
                                  Theme.of(context).colorScheme.secondary,
                              leading: CircleAvatar(
                                radius: 23,
                                backgroundImage: userData['avatar'] != ""
                                    ? NetworkImage(userData['avatar'])
                                    : const NetworkImage(
                                        'https://www.shutterstock.com/image-vector/blank-avatar-photo-place-holder-600nw-1095249842.jpg'),
                              ),
                              title: Text(
                                userData['nickname'],
                                style: const TextStyle(
                                  fontSize: 18,
                                  //fontWeight: FontWeight.bold,
                                ),
                              ),
                              trailing: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.people, size: 30),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ));
  }
}
