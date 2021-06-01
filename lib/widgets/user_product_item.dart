import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../providers/products_provider.dart';

import '../screens/edit_product_screen.dart';

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
              onPressed: () {
                try {
                  Navigator.of(context).pushNamed(
                    EditProductScreen.routeName,
                    arguments: product,
                  );
                }
                catch (error) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(error.toString()),
                  ));
                }

              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                try {
                  Provider.of<Products>(
                    context,
                    listen: false,
                  ).deleteProduct(this.product);
                } catch (error) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Deleting product failed.'),
                  ));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
