import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'dart:convert';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  final String _baseUrl = 'https://identitytoolkit.googleapis.com/v1/accounts:';

  Future<void> _authenticate(String email, String password, String urlBit) async {
    final url = 'https://identitytoolkit.googleapis.com/v1/accounts:$urlBit?key=AIzaSyBBqgWYJc-VTS9QVpKvq-vU37JnhUx0Msc';
    print(url);
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
    print(json.decode(response.body));
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> signin(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }
}
