import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double unitPrice;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.unitPrice,
  });
}