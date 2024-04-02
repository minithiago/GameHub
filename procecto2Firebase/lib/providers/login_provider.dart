import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:procecto2/model/user_log_data.dart';
import 'package:procecto2/services/config.dart';

class LoginProvider extends ChangeNotifier {
  final String _baseUrl = "http://10.0.2.2:8081";

  final _storage = const FlutterSecureStorage();

  static late UserLogData currentUser;

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
      currentAccount = UserLogData.fromJson(jsonResponse);
      storageWriteEmail(email);
      storageWritePassword(password);

      return true;
    } else {
      throw Exception('Failed to connect to server');
    }
  }

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
    } else {
      throw Exception('Failed to connect to server');
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
}
