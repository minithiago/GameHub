import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:procecto2/model/user_log_data.dart';
import 'package:procecto2/services/config.dart';

//------------------------------------------------------------------------------------
// Rest Api - Account & Authentication Service
//------------------------------------------------------------------------------------

class AuthService extends ChangeNotifier {
  final _storage = const FlutterSecureStorage();

  // Authentication - Login
  //----------------------------------------------------------------
  Future<void> login(String email, String password) async {
    var url = Uri.parse('$restURL/auth/signin');

    var body = """
        {
          "email": "$email",
          "password": "$password"
        }
        """;

    final response = await http.post(url, body: body, headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
    }).timeout(
      const Duration(seconds: 1),
      onTimeout: () {
        throw Exception("Can't connect to GameHub");
      },
    );

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      currentAccount = UserLogData.fromJson(jsonResponse);
      storageWriteEmail(email);
      storageWritePassword(password);
      return;
    } else if (response.statusCode == 401) {
      throw Exception("Wrong email or password");
    } else {
      throw Exception("Can't connect to GameHub");
    }
  }

  // Authentication - Create new account.
  //----------------------------------------------------------------
  Future<void> signup(String nickname, String email, String password) async {
    var url = Uri.parse('$restURL/auth/signup/user');

    var body = """
        {
          "nickname": "$nickname",
          "email": "$email",
          "password": "$password",
        }
        """;

    final response = await http.post(url, body: body, headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
    }).timeout(
      const Duration(seconds: 1),
      onTimeout: () {
        throw Exception("Can't connect to GameHub");
      },
    );

    if (response.statusCode == 200) {
      return;
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
    var url = Uri.parse('$restURL/account');

    var body = """
        {
          "id" : "${currentAccount.id}",
          "nickname": "$nickname",
          "email": "$email",
          "password": "$password",
        }
        """;

    final Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: "Bearer ${currentAccount.token}"
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
    var url = Uri.parse('$restURL/auth/forgot-password?email=$email');

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

  void logout() {
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
}
