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
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            floating: true,
            iconTheme: IconThemeData(
              color: Theme.of(context).accentColor,
            ),
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              //titlePadding: EdgeInsets.zero,
              title: Container(
                width: double.infinity,
                child: Text(selectedProduct.title),
                color: Colors.black54,
              ),
              background: Hero(
                  tag: selectedProduct.id,
                  child: Image.network(
                    selectedProduct.imageUrl,
                    fit: BoxFit.cover,
                  )),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox(height: 10),
                Text(selectedProduct.title,
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 30,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  '\$${selectedProduct.price}',
                  style: TextStyle(
                    color: Theme.of(context).splashColor,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
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
                SizedBox(height: 1000),
              ],
            ),
          ),
        ],
      ), //Column
    );
  }
}
