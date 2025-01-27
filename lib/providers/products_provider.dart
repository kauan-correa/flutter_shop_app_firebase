import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/providers/product.dart';
import 'package:flutter/services.dart' show rootBundle;

class ProductsProvider with ChangeNotifier {
  final List<Product> _items = [];
  final settingsFile = rootBundle.loadString('assets/settings/settingsDb.json');

  List<Product> get items => [..._items];

  Future<void> loadProducts() async {
    try {
      final settings = json.decode(await settingsFile);
      String url = settings["database_url"];
      final response = await http.get(Uri.parse("$url/products.json"));
      final Map<String, dynamic> extractedData = json.decode(response.body);
      _items.clear();
      extractedData.forEach((productId, productData) {
        _items.add(Product(
          id: productId,
          title: productData["title"],
          description: productData["description"],
          price: productData["price"],
          imageUrl: productData["imageUrl"],
          isFavorite: productData["isFavorite"],
        ));
      });
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  int get itemCount {
    return _items.length;
  }

  List<Product> get favoriteItems {
    return _items.where((item) => item.isFavorite).toList();
  }

  Future<bool> addProduct(Product product) async {
    try {
      final data = json.decode(await settingsFile);
      String url = data["database_url"];

      final response = await http.post(
        Uri.parse("$url/products.json"),
        body: json.encode(
          {
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
            'isFavorite': product.isFavorite,
          },
        ),
      );

      final newProduct = Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      _items.add(newProduct);
      notifyListeners();
      return true;
    } catch (error) {
      print(error);
      return false;
    }
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
