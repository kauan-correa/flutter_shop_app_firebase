import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/orders.dart';
import 'package:shop/widgets/app_drawer.dart';
import 'package:shop/widgets/order_widget.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Orders orders = Provider.of<Orders>(context);
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text("My Orders"),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: orders.itemsCount,
        itemBuilder: (context, i) {
          return OrderWidget(order: orders.items[i]);
        },
      ),
    );
  }
}
