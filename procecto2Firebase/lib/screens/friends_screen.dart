import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:procecto2/elements/loader_element.dart';
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
        backgroundColor: Theme.of(context).colorScheme.background, //background
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
                          backgroundImage: userData['avatar'] != ""
                              ? NetworkImage(userData['avatar'])
                              : const NetworkImage(
                                  'https://www.shutterstock.com/image-vector/blank-avatar-photo-place-holder-600nw-1095249842.jpg'),
                        ),
                        title: Text(
                          userData['nickname'],
                          style: const TextStyle(
                              //color: Colors.white
                              ),
                        ),
                      ),
                    );
                  },
                  itemCount: (snapshot.data! as dynamic).docs.length,
                );
              },
            )
          : const Text(
              'Añadir lista de amigos',
              style: TextStyle(
                  //color: Colors.white
                  ),
            ),
    );
  }
}
