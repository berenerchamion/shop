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
    );
  }
}
