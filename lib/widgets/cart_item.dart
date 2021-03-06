import 'package:flutter/material.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String title;
  final double price;
  final int quantity;

  CartItem(
    this.id,
    this.title,
    this.price,
    this.quantity,
  );

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 4,
      ),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: ListTile(
          leading: Chip(
            label: Text(
              '\$${price}',
              style: TextStyle(
                color: Theme.of(context).accentColor,
              ),
            ),
            backgroundColor: Theme.of(context).primaryColor,
          ),
          title: Text(title),
          subtitle: Text(
            'Total: \$${(price * quantity)}',
          ),
          trailing: Text('$quantity x'),
        ),
      ),
    );
  }
}
