import 'dart:math';
// 26:05
import 'package:flutter/material.dart';
import 'package:shop/providers/product.dart';

class CartItem {
  final String id;
  final String productId;
  final String title;
  final int quantity;
  final num price;
  CartItem({
    required this.id,
    required this.productId,
    required this.title,
    required this.quantity,
    required this.price,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemsCount {
    return _items.length;
  }

  double get totalAmount {
    double total = 0.0;
    _items.forEach(
        (key, cartItem) => total += cartItem.price * cartItem.quantity);
    return total;
  }

  void addItem(Product product) {
    if (_items.containsKey(product.id)) {
      _items.update(
        product.id,
        (existingItem) {
          return CartItem(
            id: existingItem.id,
            productId: product.id,
            title: existingItem.title,
            quantity: existingItem.quantity + 1,
            price: existingItem.price,
          );
        },
      );
    } else {
      _items.putIfAbsent(
        product.id,
        () {
          return CartItem(
              id: Random().nextDouble().toString(),
              productId: product.id,
              title: product.title,
              quantity: 1,
              price: product.price);
        },
      );
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    _items.remove(productId);
    notifyListeners();
  }

  void addQuantity(String productid) {
    if (!_items.containsKey(productid)) {
      return;
    }

    _items.update(productid, (item) {
      return CartItem(
        id: item.id,
        productId: item.productId,
        title: item.title,
        quantity: item.quantity + 1,
        price: item.price,
      );
    });
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId]!.quantity > 1) {
      _items.update(
        productId,
        (existingItem) => CartItem(
          id: existingItem.id,
          productId: productId,
          title: existingItem.title,
          quantity: existingItem.quantity - 1,
          price: existingItem.price,
        ),
      );
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
