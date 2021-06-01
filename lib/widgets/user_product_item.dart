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
    final scaffoldMessenger = ScaffoldMessenger.of(context);
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
              onPressed: () async {
                try {
                  Navigator.of(context).pushNamed(
                    EditProductScreen.routeName,
                    arguments: product,
                  );
                }
                catch (error) {
                  scaffoldMessenger.showSnackBar(SnackBar(
                    content: Text(error.toString()),
                  ));
                }
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                try {
                  await Provider.of<Products>(
                    context,
                    listen: false,
                  ).deleteProduct(this.product);
                } catch (error) {
                  scaffoldMessenger.showSnackBar(SnackBar(
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
