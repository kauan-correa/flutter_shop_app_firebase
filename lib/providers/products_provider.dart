import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/providers/product.dart';
import 'package:flutter/services.dart' show rootBundle;

class ProductsProvider with ChangeNotifier {
  final List<Product> _items = [];

  List<Product> get items => [..._items];

  Future<String> get _urlDb async {
    final settingsFile =
        rootBundle.loadString('assets/settings/settingsDb.json');
    final settings = json.decode(await settingsFile);
    return settings["database_url"];
  }

  Future<void> loadProducts() async {
    try {
      String url = await _urlDb;
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
      String url = await _urlDb;
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
      debugPrint("Product added successfully");
      return true;
    } catch (error) {
      debugPrint("Error adding product: $error");
      return false;
    }
  }

  Future<bool> updateProduct(Product product) async {
    try {
      String url = await _urlDb;
      final response = await http.patch(
        Uri.parse("$url/products/${product.id}.json"),
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
        }),
      );
      debugPrint("Response status code: ${response.statusCode}");
      if (response.statusCode == 200 || response.statusCode == 204) {
        notifyListeners();
        debugPrint("Product updated successfully");
        return true;
      } else {
        debugPrint("Failed to update product");
        return false;
      }
    } catch (error) {
      debugPrint("Error updating product: $error");
      return false;
    }
  }

  Future<bool> removeProduct(Product product) async {
    try {
      String url = await _urlDb;
      debugPrint("Removing product with id: ${product.id}");
      final response = await http.delete(
        Uri.parse("$url/products/${product.id}.json"),
      );
      debugPrint("Response status code: ${response.statusCode}");
      if (response.statusCode == 200 || response.statusCode == 204) {
        _items.remove(product);
        notifyListeners();
        debugPrint("Product removed successfully");
        return true;
      } else {
        debugPrint("Failed to remove product");
        return false;
      }
    } catch (error) {
      debugPrint("Error removing product: $error");
      return false;
    }
  }
}
