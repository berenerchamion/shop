import 'package:flutter/material.dart';
import '../widgets/product_grid.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool _showOnlyFavorites = false;
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
          ),
        ],
      ), //AppBar
      body: ProductGrid(_showOnlyFavorites), //GridView
    );
  }
}
