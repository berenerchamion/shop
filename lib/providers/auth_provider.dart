import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userid;
  bool get isAuth {
    return token != null;
  }
  Timer _sessionTimer;

  bool checkForValidSession() {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return true;
    } else {
      return false;
    }
  }

  String get token {
    if (checkForValidSession()) {
      return _token;
    }
    else {
      return null;
    }
  }

  String get userid {
    if (checkForValidSession()) {
      return _userid;
    }
    else {
      return null;
    }
  }

  //urlBit is the authentication method type, see signin() and signup() below.
  Future<void> _authenticate(
      String email, String password, String urlBit) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlBit?key=AIzaSyBBqgWYJc-VTS9QVpKvq-vU37JnhUx0Msc';
    try {
      Uri uri = Uri.parse(url);
      final response = await post(
        uri,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userid = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
        ),
      );
      _invalidateSession();
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userid': _userid,
        'expiryDate': _expiryDate.toIso8601String(),
      });
      prefs.setString('hob_shop', userData);

    } catch (error) {
      print(error.toString());
      throw (error);
    }
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> signIn(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<bool> attemptAutoLogin () async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('hob_shop')) {
      return false;
    }
    else {
      final extractedUserData = json.decode(prefs.get('hob_shop')) as Map<String, Object>;
      final expiryDate = DateTime.parse(extractedUserData['expiryDate']);

      if (expiryDate.isBefore(DateTime.now())) {
        return false;
      }
      else {
        _token = extractedUserData['token'];
        _userid = extractedUserData['userid'];
        _expiryDate = expiryDate;
        notifyListeners();
        _invalidateSession();
        return true;
      }
    }
  }

  Future<void> signOut() async {
    _token = null;
    _expiryDate = null;
    _userid = null;
    if (_sessionTimer != null) {
      _sessionTimer.cancel();
      _sessionTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('hob_shop');
  }

  void _invalidateSession() {
    if (_sessionTimer != null) {
      _sessionTimer.cancel();
    }

    final countdown = _expiryDate.difference(DateTime.now()).inSeconds;
    _sessionTimer = Timer(Duration(seconds: countdown), signOut);
  }

}
