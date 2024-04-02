import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:procecto2/model/userModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthRepository {
  final _auth = FirebaseAuth.instance;
  final _storage = FirebaseStorage.instance;
  final _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      print(e);
    }
  }

  Future<void> createUser({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      print(e);
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  /*
  Future<UserCredential?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      return credential;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<String?> signOut() async {
    try {
      _auth.signOut();
      return null;
    } catch (e) {
      print(e);
      return e.toString();
    }
  }

  Future<UserCredential?> createAccount({
    required String email,
    required String password,
    required String nickname,
    required File? image,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      final path = _storage
          .ref(StorageFolderNames.profilePics)
          .child(FirebaseAuth.instance.currentUser!.uid);

      if (image == null) {
        return null;
      }
      final TaskSnapshot = await path.putFile(image);
      final downloadUrl = await TaskSnapshot.ref.getDownloadURL();

      UserModel user = UserModel(
          id: int.parse(FirebaseAuth.instance.currentUser!.uid),
          nickname: nickname,
          email: email,
          password: password,
          profilePicUrl: downloadUrl);

      await _firestore
          .collection(FirebaseCollectionNames.users)
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set(
            user.toMap(),
          );
      return credential;
    } catch (e) {
      print(e);
      return null;
    }
  }
  */
}
