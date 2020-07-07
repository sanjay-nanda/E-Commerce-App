import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  final String creatorId;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.description,
    @required this.imageUrl,
    @required this.price,
    @required this.title,
    @required this.creatorId,
    this.isFavorite = false,
  });

  Future<void> toggleFavorite(String authToken, String userId) async {
    final status = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url = 'https://myshop-d4cd0.firebaseio.com/userFavorites/$userId/$id.json?auth=$authToken';
    try {
      final respone = await http.put(
        url,
        body: json.encode(
          isFavorite
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
