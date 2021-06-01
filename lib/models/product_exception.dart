import 'package:flutter/material.dart';
import 'package:http/http.dart';

class ProductException implements Exception {
  final String message;

  ProductException(this.message);

  @override
  String toString() {
    return message;
  }
}