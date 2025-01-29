import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/data/database_service.dart';
import 'package:shop/providers/product.dart';

class ProductsProvider with ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  final List<Product> _items = [];

  ProductsProvider() {
    loadProducts();
  }

  UnmodifiableListView<Product> get items => UnmodifiableListView(_items);
  UnmodifiableListView<Product> get favoriteItems {
    return UnmodifiableListView(
        _items.where((product) => product.isFavorite).toList());
  }

  Future<void> loadProducts() async {
    try {
      String url = await _databaseService.getDatabaseUrl();
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
      debugPrint("Error loading products: $error");
    }
  }

  Future<bool> addProduct(Product product) async {
    try {
      String url = await _databaseService.getDatabaseUrl();
      final response = await http.post(
        Uri.parse("$url/products.json"),
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
          'isFavorite': product.isFavorite,
        }),
      );

      final newProduct = Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        isFavorite: product.isFavorite,
      );
      _items.add(newProduct);
      notifyListeners();
      return true;
    } catch (error) {
      debugPrint("Error adding product: $error");
      return false;
    }
  }

  Future<bool> updateProduct(Product product) async {
    try {
      String url = await _databaseService.getDatabaseUrl();
      final response = await http.patch(
        Uri.parse("$url/products/${product.id}.json"),
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
        }),
      );
      if (response.statusCode == 200 || response.statusCode == 204) {
        final prodIndex = _items.indexWhere((p) => p.id == product.id);
        if (prodIndex >= 0) {
          _items[prodIndex] = product;
          notifyListeners();
        }
        return true;
      }
      return false;
    } catch (error) {
      debugPrint("Error updating product: $error");
      return false;
    }
  }

  Future<bool> removeProduct(Product product) async {
    try {
      String url = await _databaseService.getDatabaseUrl();
      final response = await http.delete(
        Uri.parse("$url/products/${product.id}.json"),
      );
      if (response.statusCode == 200 || response.statusCode == 204) {
        _items.removeWhere((p) => p.id == product.id);
        notifyListeners();
        return true;
      }
      return false;
    } catch (error) {
      debugPrint("Error removing product: $error");
      return false;
    }
  }
}
