import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:procecto2/model/userModel.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserRepository extends ChangeNotifier {
  final _storage = const FlutterSecureStorage();
  //static const _keyGames = 'games';

  static late UserModel currentUser;

  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<bool> addUser(String uid, String nickname, String email,
      String password, String profilePic) async {
    try {
      await db.collection("Users").doc(uid).set({
        "nickname": nickname,
        "email": email,
        "password": password,
        "avatar": profilePic
      });
      currentUser = UserModel(
          nickname: nickname,
          email: email,
          password: password,
          profilePicUrl: profilePic);

      print("User added Successfully");
      return true;
    } catch (e) {
      print("Error adding user: $e");
      return false;
    }
  }

  Future<bool> updateUser(
      String email, String nickname, String profilePic) async {
    try {
      // Obtén una referencia al documento del usuario en Firestore utilizando su correo electrónico
      QuerySnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where('email', isEqualTo: email)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        String userId = userSnapshot.docs.first.id;

        // Actualiza el nickname y el avatar del usuario en Firestore
        await FirebaseFirestore.instance
            .collection("Users")
            .doc(userId)
            .update({
          "nickname": nickname,
          "avatar": profilePic,
        });

        print("User updated successfully");
        return true;
      } else {
        print("User with email $email not found");
        return false;
      }
    } catch (e) {
      print("Error updating user: $e");
      return false;
    }
  }

  Future<bool> forgotPassword(String email) async {
    try {
      auth.sendPasswordResetEmail(email: email);

      print("Recover password");
      return true;
    } catch (e) {
      print("Error adding user: $e");
      return false;
    }
  }

  Future<bool> addGameToUser(String email, String coverId, String gameName,
      double rating, int id) async {
    try {
      // Obtén una referencia al documento del usuario en Firestore utilizando su correo electrónico
      QuerySnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where('email', isEqualTo: email)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        String userId = userSnapshot.docs.first.id;

        // Obtén una referencia a la colección de juegos del usuario
        DocumentReference userRef =
            FirebaseFirestore.instance.collection('Users').doc(userId);

        // Agrega el juego a la colección de juegos del usuario
        await userRef.collection('Games').add({
          "name": gameName,
          "id": id,
          "rating": rating,
          "coverId": coverId,
        });

        print("Game added to user successfully");
        return true;
      } else {
        print("User with email $email not found");
        return false;
      }
    } catch (e) {
      print("Error adding game to user: $e");
      return false;
    }
  }

  Future<bool> removeGameFromUser(String email, int gameId) async {
    try {
      // Obtén una referencia al documento del usuario en Firestore utilizando su correo electrónico
      QuerySnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where('email', isEqualTo: email)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        String userId = userSnapshot.docs.first.id;

        // Obtén una referencia al documento del usuario
        DocumentReference userRef =
            FirebaseFirestore.instance.collection('Users').doc(userId);

        // Elimina el juego de la colección de juegos del usuario usando el ID del juego
        QuerySnapshot gameQuery = await userRef
            .collection('Games')
            .where('id', isEqualTo: gameId)
            .get();
        if (gameQuery.docs.isNotEmpty) {
          await gameQuery.docs.first.reference.delete();
          print("Game removed from user successfully");
          return true;
        } else {
          print("Game not found in user's collection");
          return false;
        }
      } else {
        print("User with email $email not found");
        return false;
      }
    } catch (e) {
      print("Error removing game from user: $e");
      return false;
    }
  }

  Future<Map<String, dynamic>?> fetchUserData() async {
    try {
      // Obtener el correo electrónico del usuario actualmente autenticado
      String? userEmail = FirebaseAuth.instance.currentUser!.email;

      // Realizar una consulta en Firestore para obtener los datos del usuario
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where('email', isEqualTo: userEmail)
          .get();

      // Verificar si se encontró algún usuario con el correo electrónico dado
      if (querySnapshot.docs.isNotEmpty) {
        // Obtener los datos del primer usuario encontrado
        Map<String, dynamic> userData =
            querySnapshot.docs.first.data() as Map<String, dynamic>;

        // Devolver los datos del usuario
        return userData;
      } else {
        // Si no se encontró ningún usuario, devolver null
        return null;
      }
    } catch (e) {
      // Manejar errores y devolver null
      print('Error obtaining the user data: $e');
      return null;
    }
  }

  Future<String?> getUserUID() async {
    // Llamamos a la función fetchUserData() para obtener los datos del usuario
    Map<String, dynamic>? userData = await UserRepository().fetchUserData();

    // Verificamos si se encontró algún usuario con el correo electrónico dado
    if (userData != null) {
      // Accedemos al valor del campo "nickname" del usuario
      String? uid = userData['uid'];

      // Devolvemos el valor del nickname
      return uid;
    } else {
      // Si no se encontró ningún usuario, devolvemos null
      return null;
    }
  }

  Future<User?> registerUser(String email, String password) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print("User created Successfully");

      storageWriteEmail(email);
      storageWritePassword(password);
      return credential.user; // El registro se realizó correctamente
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
      return null; // Hubo un error durante el registro
    } catch (e) {
      print(e);
      return null; // Hubo un error desconocido durante el registro
    }
  }
  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<User?> loginUser(String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      storageWriteEmail(email);
      storageWritePassword(password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
      return null;
    }
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    storageWriteEmail('');
    storageWritePassword('');
  }

  Future<String> storageReadEmail() async {
    return await _storage.read(key: 'email') ?? '';
  }

  Future<String> storageReadPassword() async {
    return await _storage.read(key: 'password') ?? '';
  }

  Future<List<String>> storageGetAuthData() async {
    return [await storageReadEmail(), await storageReadPassword()];
  }

  void storageWriteEmail(String email) {
    _storage.write(key: 'email', value: email);
  }

  void storageWritePassword(String password) {
    _storage.write(key: 'password', value: password);
  }
}
