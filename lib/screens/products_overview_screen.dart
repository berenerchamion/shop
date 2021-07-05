import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/product_grid.dart';
import '../widgets/badge.dart';
import '../widgets/app_drawer.dart';

import '../screens/cart_screen.dart';
import '../providers/cart_provider.dart';
import '../providers/products_provider.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  static const String routeName = '/products-overview-screen';
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool _showOnlyFavorites = false;
  bool _isLoading = false;

  @override
  void initState() {
    _isLoading = true;
    Provider.of<Products>(context, listen: false).fetchProducts().then((_) {
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HOB Shop'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favorites) {
                  _showOnlyFavorites = true;
                } else {
                  _showOnlyFavorites = false;
                }
              });
            },
            icon: Icon(
              Icons.more_vert,
            ),
            itemBuilder: (ctx) => [
              CheckedPopupMenuItem(
                child: Text('Only Favorites'),
                value: FilterOptions.Favorites,
                checked: _showOnlyFavorites,
              ),
              CheckedPopupMenuItem(
                child: Text('Show All'),
                value: FilterOptions.All,
                checked: !_showOnlyFavorites,
              ),
            ],
          ), //End menu
          Consumer<Cart>(
            builder: (ctx, cart, child) => Badge(
              child: child,
              value: cart.itemCount.toString(),
              color: Colors.black,
            ),
            child: IconButton(
              icon: Icon(
                Icons.shopping_cart,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ), //IconButton
          ), //Consumer
        ],
      ), //AppBar
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductGrid(_showOnlyFavorites), //GridView
    );
  }
}
