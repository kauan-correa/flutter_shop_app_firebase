import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shop/providers/cart.dart';

class OrderItem {
  final String id;
  final double totalAmount;
  final List<CartItem> products;
  final DateTime date;

  OrderItem({
    required this.id,
    required this.totalAmount,
    required this.products,
    required this.date,
  });
}

class Orders with ChangeNotifier {
  final List<OrderItem> _items = [];

  List<OrderItem> get items {
    return [..._items];
  }

  int get itemsCount {
    return _items.length;
  }

  void addOrder(Cart cart) {
    _items.insert(
      0,
      OrderItem(
        id: Random().nextDouble().toString(),
        products: cart.items.values.toList(),
        totalAmount: cart.totalAmount,
        date: DateTime.now(),
      ),
    );
    notifyListeners();
  }
}
