import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'dart:convert';

import '../models/cart_item.dart';
import '../models/order.dart';
import '../models/http_exception.dart';
import '../models/product_exception.dart';

class Orders with ChangeNotifier {
  final String _baseUrl =
      'https://hob-shop-default-rtdb.firebaseio.com/products';

  List<Order> _orders = [];

  List<Order> get orders {
    return [..._orders];
  }

  Future<void> addOrder(List<CartItem> cartContents, double total) async {
    Response response;
    try {
      final timestamp = DateTime.now();
      Uri uri = Uri.parse('$_baseUrl.json');

      response = await post(uri,
          body: json.encode({
            'amount': total,
            'dateTime': timestamp.toIso8601String(),
            'products': cartContents
                .map((cc) => {
                      'id': cc.id,
                      'title': cc.title,
                      'quantity': cc.quantity,
                      'price': cc.unitPrice,
                    })
                .toList(),
          }));
      _orders.insert(
          0,
          Order(
            id: json.decode(response.body)['name'],
            amount: total,
            products: cartContents,
            orderDateTime: timestamp,
          ));
      notifyListeners();
    } catch (error) {
      if (response.statusCode >= 400) {
        throw (HttpException(
            'HTTP $response.statusCode error while editing product.'));
      } else {
        throw (ProductException('Adding the order failed.'));
      }
    }
  }
}
