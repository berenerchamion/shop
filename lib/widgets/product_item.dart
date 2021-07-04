import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/auth_provider.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final authData  = Provider.of<Auth>(context, listen:false);
    return Consumer2<Product, Cart>(
      builder: (ctx, product, cart, child) => ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: GridTile(
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black87,
                  blurRadius: 10.0,
                  spreadRadius: 7.0,
                ),
              ],
            ),
            child: GestureDetector(
                onTap: () {
                  Navigator.of(context)
                      .pushNamed('/product-detail', arguments: product.id);
                },
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                )),
          ),
          footer: GridTileBar(
            backgroundColor: Colors.black54,
            leading: IconButton(
              icon: Icon(
                product.isFavorite ? Icons.favorite : Icons.favorite_border,
              ),
              color: Theme.of(context).buttonColor,
              onPressed: () {
                try{
                  product.toggleFavoriteStatus(authData.token);
                }
                catch(error) {
                  scaffoldMessenger.showSnackBar(SnackBar(
                    content: Text(error.toString()),
                  ));
                }
              },
            ),
            trailing: IconButton(
              icon: Icon(Icons.shopping_cart),
              color: Theme.of(context).buttonColor,
              onPressed: () {
                ScaffoldMessenger.maybeOf(context).hideCurrentSnackBar();
                cart.addItem(
                  product.id,
                  product.title,
                  product.price,
                );
                ScaffoldMessenger.maybeOf(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.black54,
                    content: Text(
                      'Hey I added that...',
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                    action: SnackBarAction(
                      label: 'UNDO',
                      onPressed: () {
                        cart.removeSingleItem(product.id);
                      },
                    ),
                  ),
                );
              },
            ),
            title: Text(
              product.title,
              textAlign: TextAlign.center,
            ),
          ),
        ), //GridTile
      ),
    );
  }
}
