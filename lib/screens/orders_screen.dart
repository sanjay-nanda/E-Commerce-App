import '../widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/orders.dart';
import '../widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders-screen';
  @override
  Widget build(BuildContext context) {
    final ordersData = Provider.of<Order>(context);
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      body: ListView.builder(
        itemCount: ordersData.orders.length,
        itemBuilder: (ctx, index) => OrderTile(ordersData.orders[index]),
      ),
    );
  }
}
