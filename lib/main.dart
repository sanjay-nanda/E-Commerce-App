import './screens/orders_screen.dart';
import './provider/cart.dart';
import './screens/cart_screen.dart';
import './screens/product_detail_screen.dart';
import 'package:flutter/material.dart';
import './screens/product_overview_screen.dart';
import 'package:provider/provider.dart';
import './provider/products.dart';
import './provider/orders.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Products(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Order(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Shoppie',
        theme: ThemeData(
            primaryColor: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato'),
        initialRoute: '/',
        routes: {
          '/': (ctx) => ProductOverviewScreen(),
          ProductDetailsScreen.routeName: (ctx) => ProductDetailsScreen(),
          CartScreen.routeName: (ctx) => CartScreen(),
          OrdersScreen.routeName: (ctx) => OrdersScreen(),
        },
      ),
    );
  }
}
