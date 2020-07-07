import 'package:flutter/foundation.dart';
import 'cart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({this.amount, this.dateTime, this.id, this.products});
}

class Order with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String authToken;
  final String userId;

  Order(this.authToken, this.userId, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetProducts() async {
    final url = 'https://myshop-d4cd0.firebaseio.com/orders/$userId.json?auth=$authToken';
    final response = await http.get(url);
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    final List<OrderItem> loadedOrders = [];
    if(extractedData == null){
      return;
    }
    extractedData.forEach((orderId, orderValue) {
      loadedOrders.add(OrderItem(
        id: orderId,
        amount: orderValue['amount'],
        dateTime: DateTime.parse(orderValue['dateTime']),
        products: (orderValue['products'] as List<dynamic>)
            .map(
              (item) => CartItem(
                id: item['id'],
                title: item['title'],
                quantity: item['quantity'],
                price: item['price'],
              ),
            )
            .toList(),
      ));
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
    });
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url = 'https://myshop-d4cd0.firebaseio.com/orders/$userId.json?auth=$authToken';
    final timeStamp = DateTime.now();
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'amount': total,
            'dateTime': timeStamp.toIso8601String(),
            'products': cartProducts
                .map(
                  (e) => {
                    'id': e.id,
                    'title': e.title,
                    'quantity': e.quantity,
                    'price': e.price
                  },
                )
                .toList(),
          },
        ),
      );
      _orders.insert(
        0,
        OrderItem(
            id: json.decode(response.body)['name'],
            amount: total,
            products: cartProducts,
            dateTime: timeStamp),
      );
    } catch (e) {}
    notifyListeners();
  }
}
