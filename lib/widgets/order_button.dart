import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import '../providers/orders_provider.dart';
import '../providers/cart_provider.dart';

class OrderButton extends StatefulWidget {
  //const OrderButton({Key? key}) : super(key: key);
  const OrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: (widget.cart.totalAmount <= 0 || _isLoading)
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              await Provider.of<Orders>(
                context,
                listen: false,
              ).addOrder(
                widget.cart.items.values.toList(),
                widget.cart.totalAmount,
              );
              widget.cart.emptyCart();
              setState(() {
                _isLoading = false;
              });
            },
      child: _isLoading ? CircularProgressIndicator() : Text('ORDER NOW!'),
    );
  }
}
