import '../widgets/app_drawer.dart';
import '../screens/cart_screen.dart';
import '../widgets/badge.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/products_grid.dart';
import '../provider/cart.dart';

enum FilterOptions { Favorites, All }

class ProductOverviewScreen extends StatefulWidget {
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _showFavorites = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Shop'),
        actions: [
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favorites) {
                  _showFavorites = true;
                } else {
                  _showFavorites = false;
                }
              });
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Only Favorite'),
                value: FilterOptions.Favorites,
              ),
              PopupMenuItem(
                child: Text('Show All'),
                value: FilterOptions.All,
              )
            ],
            icon: Icon(
              Icons.more_vert,
            ),
          ),
          Consumer<Cart>(builder: (_, cart, __) => Badge(
              child:
                  IconButton(icon: Icon(Icons.shopping_cart), onPressed: (){
                    Navigator.of(context).pushNamed(CartScreen.routeName);
                  }),
              value: cart.noofItems.toString()),) 
        ],
      ),
      body: ProductsGrid(_showFavorites),
      drawer: AppDrawer(),
    );
  }
}
