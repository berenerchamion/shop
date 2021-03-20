import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import './cart_item.dart';

class Order {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime orderDateTime;

  Order({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.orderDateTime,
  });
}
