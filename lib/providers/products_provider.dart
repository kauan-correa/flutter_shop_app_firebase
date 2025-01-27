import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/data/dummy_data.dart';
import 'package:shop/providers/product.dart';
import 'package:flutter/services.dart' show rootBundle;

class ProductsProvider with ChangeNotifier {
  final List<Product> _items = DUMMY_PRODUCTS;

  List<Product> get items => [..._items];

  int get itemCount {
    return _items.length;
  }

  List<Product> get favoriteItems {
    return _items.where((item) => item.isFavorite).toList();
  }

  Future<void> addProduct(Product product) async {
    JsonDecoder jsonDecoder = const JsonDecoder();
    final jsonDatabase =
        await rootBundle.loadString('assets/data/settings.json');
    final data = jsonDecoder.convert(jsonDatabase);
    String url = data["database_url"];

    http.post(Uri.parse("$url/products.json"),
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'price': product.price.toString(),
          'imageUrl': product.imageUrl,
          'isFavorite': product.isFavorite.toString(),
        }));

    if (_items.any((item) => item.id == product.id)) {
      final index = _items.indexWhere((item) => item.id == product.id);
      _items[index] = product;
    } else {
      _items.add(product);
    }
    notifyListeners();
  }

  void updateProduct(Product product) {
    if (_items.any((item) => item.id == product.id)) {
      final index = _items.indexWhere((item) => item.id == product.id);
      _items[index] = product;
      notifyListeners();
    }
  }

  void removeProduct(String productId) {
    _items.removeWhere((item) => item.id == productId);
    notifyListeners();
  }
}
