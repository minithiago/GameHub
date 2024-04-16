import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:procecto2/model/game.dart';
import 'package:procecto2/model/user_log_data.dart';

//------------------------------------------------------------------------------------
// Rest Api - Account & Authentication Service
//------------------------------------------------------------------------------------

class LoginProvider extends ChangeNotifier {
  final String _baseUrl = "http://10.0.2.2:8081";

  final _storage = const FlutterSecureStorage();
  static const _keyGames = 'games';

  static late UserLogData currentUser;

  // Authentication - Login
  //----------------------------------------------------------------

  Future<bool?> login(String email, String password) async {
    var url = Uri.parse('$_baseUrl/api/auth/signin');

    Map data = {
      "email": email,
      "password": password,
    };

    var body = json.encode(data);

    final response = await http.post(url, body: body, headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
    }).timeout(
      const Duration(seconds: 3),
      onTimeout: () {
        return http.Response('Error', 404);
      },
    );

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      currentUser = UserLogData.fromJson(jsonResponse);
      storageWriteEmail(email);
      storageWritePassword(password);

      return true;
    } else {
      throw Exception('Failed to connect to server');
    }
  }

  // Authentication - Create new account.
  //----------------------------------------------------------------
  Future<bool> signup(String nickname, String email, String password) async {
    var url = Uri.parse('$_baseUrl/api/auth/signup');

    Map data = {
      "nickname": nickname,
      "email": email,
      "password": password,
    };

    var body = json.encode(data);

    debugPrint(data.toString());
    final Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json'
    };

    final response = await http.post(url, body: body, headers: headers).timeout(
      const Duration(seconds: 3),
      onTimeout: () {
        return http.Response('Error', 404);
      },
    );
    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 400) {
      throw Exception("Email already in use");
    } else {
      throw Exception("Can't connect to GameHub");
    }
  }

  // Account - Modify Account
  //----------------------------------------------------------------
  Future<void> modifyAccount(
      String nickname, String email, String password) async {
    var url = Uri.parse('$_baseUrl/account');

    var body = """
        {
          "id" : "${currentUser.id}",
          "nickname": "$nickname",
          "email": "$email",
          "password": "$password",
        }
        """;

    final Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: "Bearer ${currentUser.token}"
    };

    final response = await http.put(url, body: body, headers: headers).timeout(
      const Duration(seconds: 3),
      onTimeout: () {
        throw Exception("Can't connect to GameHub");
      },
    );

    if (response.statusCode == 200) {
      storageWriteEmail(email);
      storageWritePassword(password);
      return;
    } else if (response.statusCode == 400) {
      throw Exception("Email already in use");
    } else {
      throw Exception("Can't connect to GameHub");
    }
  }

  // Authentication - Password Recovery
  //----------------------------------------------------------------
  Future<void> requestPassword(String email) async {
    var url = Uri.parse('$_baseUrl/auth/forgot-password?email=$email');

    final response = await http.put(url, headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
    }).timeout(
      const Duration(seconds: 1),
      onTimeout: () {
        throw Exception("Can't connect to GameHub");
      },
    );

    if (response.statusCode == 200) {
      storageWriteEmail('');
      storageWritePassword('');
      return;
    } else if (response.statusCode == 404) {
      throw Exception("Incorrect account email");
    } else {
      throw Exception("Can't connect to GameHub");
    }
  }

  getUserId() {
    return currentUser.id;
  }

  logout() {
    storageWriteEmail('');
    storageWritePassword('');
  }

  // Secure Storage IO
  //----------------------------------------------------------------
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

/*  void setGames(List<GameModel> favoriteGames) {
    final value = json.encode(favoriteGames);
    _storage.write(key: _keyGames, value: value);
  }

  List<GameModel>? getGames() {
    final value = _storage.read(key: _keyGames);
    return List<GameModel>.from(json.decode(value as String));
  }*/
}
