import '../widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/orders.dart';
import '../widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders-screen';

  @override
  Widget build(BuildContext context) {
    /* 
    final ordersData = Provider.of<Order>(context); */
    return Scaffold(
        drawer: AppDrawer(),
        appBar: AppBar(
          title: Text('Your Orders'),
        ),
        body: FutureBuilder(
            future: Provider.of<Order>(context, listen: false)
                .fetchAndSetProducts(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.error != null) {
                return Center(
                  child: Text('An error has occured!'),
                );
              } else {
                return Consumer<Order>(
                    builder: (ctx, ordersData, child) => ListView.builder(
                          itemCount: ordersData.orders.length,
                          itemBuilder: (ctx, index) =>
                              OrderTile(ordersData.orders[index]),
                        ));
              }
            }));
  }
}
