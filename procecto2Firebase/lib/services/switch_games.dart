import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SwitchState with ChangeNotifier {
  bool _isSwitchedOn = false;
  final _storage = const FlutterSecureStorage();
  final _key = 'switchState';

  SwitchState() {
    _loadSwitchState();
  }

  bool get isSwitchedOn => _isSwitchedOn;

  void toggleSwitch(bool value) {
    _isSwitchedOn = value;
    notifyListeners();
    _saveSwitchState();
  }

  Future<void> _saveSwitchState() async {
    await _storage.write(key: _key, value: _isSwitchedOn.toString());
  }

  Future<void> _loadSwitchState() async {
    String? value = await _storage.read(key: _key);
    if (value != null) {
      _isSwitchedOn = value.toLowerCase() == 'true';
      notifyListeners();
    }
  }
}
