import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    int totalCount = 0;

    _items.forEach((key, item) {
      totalCount += item.quantity;
    });
    return totalCount;
  }

  double get totalAmount {
    double totalAmount = 0.0;

    _items.forEach((key, item) {
      totalAmount += item.quantity * item.unitPrice;
    });
    return totalAmount;
  }

  void addItem(
    String productId,
    String title,
    double price,
  ) {
    if (_items.containsKey(productId)) {
      _items.update(
          productId,
          (existingItem) => CartItem(
                id: existingItem.id,
                title: existingItem.title,
                quantity: existingItem.quantity + 1,
                unitPrice: existingItem.unitPrice,
              ));
    } else {
      _items.putIfAbsent(
          productId,
          () => CartItem(
              id: DateTime.now().toString(),
              title: title,
              quantity: 1,
              unitPrice: price));
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void removeSingleItem(String pID){
    if (_items.containsKey(pID)){
      if (_items[pID].quantity > 1){
        _items.update(pID, (existingCartItem) => CartItem(
          id: existingCartItem.id,
          title: existingCartItem.title,
          unitPrice: existingCartItem.unitPrice,
          quantity: existingCartItem.quantity -1 ,
        ));
      }
      else {
        removeItem(pID);
      }
      notifyListeners();
    }
    else {
      return;
    }
  }

  void emptyCart() {
    _items.clear();
    notifyListeners();
  }
}
