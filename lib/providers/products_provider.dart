import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'product_provider.dart';
import '../models/http_exception.dart';
import '../models/product_exception.dart';

class Products with ChangeNotifier {
  List<Product> _products = [];
  final String _baseUrl =
      'https://hob-shop-default-rtdb.firebaseio.com/products';

  final String _authToken;
  final String _userId;

  Products(this._authToken, this._userId, this._products);

  List<Product> get products {
    return [..._products];
  }

  Future<void> fetchProducts([bool filterByUser = false]) async {
    final String filter = filterByUser? '&orderBy="creatorId"&equalTo="$_userId"' : '';
    Uri uriProducts = Uri.parse('$_baseUrl.json?auth=$_authToken&$filter');
    try {
      final response = await get(uriProducts);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      if (extractedData == null) {
        return;
      } else {
        final String url = 'https://hob-shop-default-rtdb.firebaseio.com/userFavorites/$_userId.json?auth=$_authToken';
        Uri uriFavorites = Uri.parse(url);
        final favoritesResponse = await get (uriFavorites);
        final favoritesData = json.decode(favoritesResponse.body);
        // Check the ?? below...tricky operator
        //Basically a double check with the ternary and then the ??
        //asks if favoritesData['prodId'] is not null use it, or if it is null return false.
        extractedData.forEach((prodId, prodData) {
          loadedProducts.add(Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            price: prodData['price'],
            isFavorite: favoritesData == null ? false : favoritesData[prodId] ?? false,
            imageUrl: prodData['imageUrl'],
          ));
        });
        _products = loadedProducts;
        notifyListeners();
      }
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
      Uri uri = Uri.parse('$_baseUrl.json?auth=$_authToken');
      final response = await post(
        uri,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'creatorId': _userId,
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
      final url = '$_baseUrl/${product.id}.json?auth=$_authToken';
      Uri uri = Uri.parse(url);
      final response = await patch(uri,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
          }));
      if (response.statusCode >= 400) {
        throw (HttpException(
            'HTTP $response.statusCode error while editing product.'));
      } else {
        _products[productIndex] = product;
        notifyListeners();
      }
    } else {
      throw (ProductException('Product ID not found. Editing failed.'));
    }
  }

  Future<void> deleteProduct(Product product) async {
    final url = '$_baseUrl/$product.id.json?auth=$_authToken';
    Uri uri = Uri.parse(url);
    final existingProductIndex =
        _products.indexWhere((p) => p.id == product.id);
    var existingProduct = _products[existingProductIndex];
    //remove the product from memory
    _products.removeAt(existingProductIndex);
    notifyListeners();
    //remove the product from firebase
    await delete(uri).then((response) {
      if (response.statusCode >= 400) {
        _products.insert(existingProductIndex, existingProduct);
        notifyListeners();
        throw (HttpException(
            'HTTP $response.statusCode error while deleting product.'));
      }
    });
    existingProduct = null;
  }
}
