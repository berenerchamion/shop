import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product_provider.dart';
import '../providers/products_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  static const String routeName = '/product-detail';

  ProductDetailScreen();

  @override
  Widget build(BuildContext context) {
    final String productId =
        ModalRoute.of(context).settings.arguments as String;
    final Product selectedProduct = Provider.of<Products>(
      context,
      listen: false,
    ).findProductById(productId);

    return Scaffold(
      appBar: AppBar(
        title: Text(selectedProduct.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 300,
              width: double.infinity,
              child: Hero(
                tag: selectedProduct.id,
                child: Image.network(
                  selectedProduct.imageUrl,
                  fit: BoxFit.cover,
                )
              ),
            ), //Container
            SizedBox(height: 10),
            Text(
              '\$${selectedProduct.price}',
              style: TextStyle(
                color: Theme.of(context).splashColor,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                selectedProduct.description,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),
          ],
        ), //Column
      ), //ScrollView
    );
  }
}
