import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/products_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/cart_screen.dart';
import './screens/orders_screen.dart';
import './screens/user_products_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/auth_screen.dart';

import './providers/products_provider.dart';
import './providers/cart_provider.dart';
import './providers/orders_provider.dart';
import './providers/auth_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (BuildContext ctx) => Products(
              Provider.of<Auth>(ctx, listen: false).token,
              Provider.of<Auth>(ctx, listen: false).userid, []),
          update: (ctx, auth, previousProducts) => Products(
            auth.token,
            auth.userid,
            previousProducts == null ? [] : previousProducts.products,
          ),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (ctx) =>
              Orders(Provider.of<Auth>(ctx, listen: false).token, []),
          update: (ctx, auth, previousOrders) => Orders(
            auth.token,
            previousOrders == null ? [] : previousOrders.orders,
          ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'HOB Shop',
          theme: ThemeData(
            primarySwatch: Colors.deepPurple,
            accentColor: Colors.deepOrange,
            buttonColor: Colors.white,
            splashColor: Colors.deepOrange,
            errorColor: Colors.deepPurple,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            fontFamily: 'Lato',
          ),
          home: auth.isAuth ? ProductsOverviewScreen() : AuthScreen(),
          routes: {
            ProductsOverviewScreen.routeName: (ctx) => ProductsOverviewScreen(),
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            UserProductsScreen.routeName: (cts) => UserProductsScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
            AuthScreen.routeName: (ctx) => AuthScreen(),
          },
        ),
      ),
    );
  }
}
