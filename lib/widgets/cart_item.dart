import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final String title;
  final double price;
  final int quantity;

  CartItem(
    this.id,
    this.productId,
    this.title,
    this.price,
    this.quantity,
  );

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(this.id),
      background: Container(
        color: Theme.of(context).primaryColor,
        child: Icon(
          Icons.delete,
          color: Theme.of(context).accentColor,
          size: 30,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(
          right: 15,
        ),
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Remove Item?'),
            content: Text('Are you really sure you want to remove this?'),
            actions: <Widget>[
              TextButton(
                child: Text('Yes'),
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
              ),
              TextButton(
                child: Text('No'),
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
              ),
            ],
          ),);
      },
      onDismissed: (direction) {
        Provider.of<Cart>(
          context,
          listen: false,
        ).removeItem(this.productId);
      },
      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: Chip(
              label: Text(
                '\$${(price * quantity)}',
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                ),
              ),
              backgroundColor: Theme.of(context).primaryColor,
            ),
            title: Text(title),
            subtitle: Text(
              'Unit Price: \$${price}',
            ),
            trailing: Text('$quantity x'),
          ),
        ),
      ),
    );
  }
}
