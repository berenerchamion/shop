import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'product_provider.dart';
import '../screens/user_products_screen.dart';

class Products with ChangeNotifier {
  List<Product> _products = [];
  final String _url =
      'https://hob-shop-default-rtdb.firebaseio.com/products.json';
  final String _baseUrl =
      'https://hob-shop-default-rtdb.firebaseio.com/products';

  List<Product> get products {
    return [..._products];
  }

  Future<void> fetchProducts() async {
    Uri uri = Uri.parse('${_baseUrl}.json');
    try {
      final response = await get(uri);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          isFavorite: prodData['isFavorite'],
          imageUrl: prodData['imageUrl'],
        ));
      });
      _products = loadedProducts;
      notifyListeners();
    } catch (error) {
      print('Firebase Fetch error!');
      throw (error);
    }
  }

  List<Product> get favoriteProducts {
    return _products.where((product) => product.isFavorite).toList();
  }

  Product findProductById(String id) {
    return _products.firstWhere((prod) => prod.id == id);
  }

  Future<void> addProduct(Product product) async {
    try {
      Uri uri = Uri.parse('${_baseUrl}.json');
      final response = await post(
        uri,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'isFavorite': product.isFavorite,
        }),
      );
      final newProduct = Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        price: product.price,
        description: product.description,
        imageUrl: product.imageUrl,
      );
      _products.add(newProduct);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateProduct(Product product) async {
    final productIndex = _products.indexWhere((p) => p.id == product.id);
    if (productIndex >= 0) {
      final url = '$_baseUrl/${product.id}.json';
      Uri uri = Uri.parse(url);
      patch(uri, body: json.encode({
        'title': product.title,
        'description': product.description,
        'price': product.price,
        'imageUrl': product.imageUrl,
      }));
      _products[productIndex] = product;
      notifyListeners();
    } else {
      print('Cannot update product, not found.');
    }
  }

  void deleteProduct(Product product) {
    _products.removeWhere((p) => p.id == product.id);
    notifyListeners();
  }
}
