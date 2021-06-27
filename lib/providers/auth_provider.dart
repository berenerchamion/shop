import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'dart:convert';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  final String _baseUrl =
      'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyBBqgWYJc-VTS9QVpKvq-vU37JnhUx0Msc';

  Future<void> signup(String email, String password) async {
    Uri uri = Uri.parse('$_baseUrl');
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
  }
}
