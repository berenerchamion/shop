import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'dart:convert';

import '../models/http_exception.dart';
import '../models/product_exception.dart';

class Product with ChangeNotifier {
  @required
  final String id;
  @required
  final String title;
  @required
  final String description;
  @required
  final double price;
  @required
  final String imageUrl;
  bool isFavorite;

  final String _baseUrl =
      'https://hob-shop-default-rtdb.firebaseio.com/products';

  Product({
    this.id,
    this.title,
    this.description,
    this.price,
    this.imageUrl,
    this.isFavorite = false,
  });

  void _setFavoriteStatus (bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus() async {
    final url = '$_baseUrl/${this.id}.json';
    Uri uri = Uri.parse(url);
    final currentFavoriteStatus = isFavorite;
    _setFavoriteStatus(!isFavorite);
    try {
      final response = await patch(uri,
          body: json.encode({
            'isFavorite': isFavorite,
          }));
      if (response.statusCode >= 400) {
        throw (HttpException('HTTP $response.statusCode error while setting product favorite value.'));
      }
    } catch (error) {
      _setFavoriteStatus(currentFavoriteStatus);
    }
  }
}
