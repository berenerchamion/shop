import 'package:flutter/material.dart';
import 'package:shop/providers/product_provider.dart';

class UserProductItem extends StatelessWidget {

  final Product product;

  UserProductItem(this.product);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(this.product.title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(this.product.imageUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
