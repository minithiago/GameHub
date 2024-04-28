import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:procecto2/model/game.dart';
import 'package:procecto2/model/userModel.dart';

class UserRepository extends ChangeNotifier {
  final _storage = const FlutterSecureStorage();
  //static const _keyGames = 'games';

  static late UserModel currentUser;

  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<bool> addUser(
      String nickname, String email, String password, String profilePic) async {
    try {
      await db.collection("Users").add({
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
      print('Error al obtener los datos del usuario: $e');
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
