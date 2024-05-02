import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:procecto2/screens/userProfile_screen.dart';
import 'package:procecto2/style/theme.dart' as Style;

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({super.key});

  @override
  _FriendsScreenState createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  final _formKey = GlobalKey<FormState>();
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
      backgroundColor: Style.Colors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Style.Colors.introGrey, //background
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: TextFormField(
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
            hintText: "Search users",
            hintStyle: const TextStyle(color: Colors.white),
            suffixIcon: IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                print(_searchController.text);
              },
              color: Colors.white,
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
                  return const Center(
                    child: CircularProgressIndicator(),
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
                              : NetworkImage(
                                  'https://www.shutterstock.com/image-vector/blank-avatar-photo-place-holder-600nw-1095249842.jpg'),
                        ),
                        title: Text(
                          userData['nickname'],
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  },
                  itemCount: (snapshot.data! as dynamic).docs.length,
                );
              },
            )
          : Text(
              'posts',
              style: TextStyle(color: Colors.white),
            ),
    );
  }
}
