import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';
import '../models/order.dart';

class Orders with ChangeNotifier {
  List<Order> _orders = [];

  List<Order> get orders {
    return [..._orders];
  }

  void addOrder(List<CartItem> cartContents, double total) {
    _orders.insert(
        0,
        Order(
          id: DateTime.now().toString(),
          amount: total,
          products: cartContents,
          orderDateTime: DateTime.now(),
        ));
    notifyListeners();
  }
}
