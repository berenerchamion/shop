import 'package:flutter/material.dart';
import 'package:http/http.dart';

class HttpException implements Exception {
  final String message;

  HttpException(this.message);

  @override
  String toString() {
    return message;
  }
}