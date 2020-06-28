import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem(
      {@required this.id,
      @required this.title,
      @required this.quantity,
      @required this.price});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get noofItems {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, value) {
      total += value.price * value.quantity;
    });
    return total;
  }

  void addItem(String productId, double price, String title) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (existingCardItem) => CartItem(
          id: existingCardItem.id,
          price: existingCardItem.price,
          title: existingCardItem.title,
          quantity: existingCardItem.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(id: productId, title: title, quantity: 1, price: price),
      );
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void addQuantity(String productId) {
    _items.update(
      productId,
      (value) => CartItem(
          id: value.id,
          title: value.title,
          quantity: value.quantity + 1,
          price: value.price),
    );
    notifyListeners();
  }

  void subQuantity(String productId) {
    _items.update(
      productId,
      (value) => CartItem(
          id: value.id,
          title: value.title,
          quantity: value.quantity - 1 < 0 ? 0 : value.quantity - 1,
          price: value.price),
    );
    if (_items[productId].quantity == 0){
      removeItem(productId);
    }
    notifyListeners();
  }

  void clearCart(){
    _items = {};
    notifyListeners();
  }
}
