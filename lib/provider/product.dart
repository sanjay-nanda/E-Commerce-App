import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.description,
    @required this.imageUrl,
    @required this.price,
    @required this.title,
    this.isFavorite = false,
  });

  Future<void> toggleFavorite() async {
    final status = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url = 'https://myshop-d4cd0.firebaseio.com/products/$id.json';
    try {
      final respone = await http.patch(
        url,
        body: json.encode(
          {'isFavorite': isFavorite},
        ),
      );
      if (respone.statusCode >= 400) {
        isFavorite = status;
        notifyListeners();
      } 
    } catch (e) {
      isFavorite = status;
      notifyListeners();
    }
  }
}
