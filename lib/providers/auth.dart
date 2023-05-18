import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:shop_app/models/exception.dart';
import 'package:shop_app/models/links.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiry;
  String? _userId;
  Timer? _authTimer;
  bool? get isAuth {
    return (token != null);
  }

  String? get token {
    if (_expiry != null && _expiry!.isAfter(DateTime.now()) && _token != null) {
      return _token;
    } else {
      return null;
    }
  }

  String? get userId {
    return _userId;
  }

  Future<void> _authenticate(
      String email, String password, String? urlString) async {
    final url = Uri.parse(urlString!);
    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(message: responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiry = DateTime.now().add(
        Duration(
          seconds: int.parse(responseData['expiresIn']),
        ),
      );
      autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiry': _expiry,
      });
      prefs.setString('userData', userData);
    } catch (e) {
      throw e;
    }
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password,Links.signUp
        );
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password,
    Links.login);
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData =
        json.decode(prefs.getString('userData')!) as Map<String, dynamic>;
    final expiryDate = DateTime.parse(extractedUserData['expiry'] as String);
    if (!expiryDate.isAfter(DateTime.now())) {
      return false;
    }
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expiry = extractedUserData['expiry'];
    notifyListeners();
    autoLogout();
    return true;
  }

  void logout() async {
    _token = null;
    _userId = null;
    _expiry = null;
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    notifyListeners();
  }

  void autoLogout() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final timeExpiry = _expiry!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeExpiry), logout);
  }
}
