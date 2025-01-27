import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/products_provider.dart';
import 'package:shop/utils/app_routes.dart';
import 'package:shop/widgets/app_drawer.dart';
import 'package:shop/widgets/product_item.dart';

class ProductsCrudScreen extends StatelessWidget {
  const ProductsCrudScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ProductsProvider products = Provider.of<ProductsProvider>(context);

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Products"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(AppRoutes.PRODUCT_FORM, arguments: null);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: ListView.builder(
          itemCount: products.itemCount,
          itemBuilder: (ctx, i) {
            return ProductItem(product: products.items[i]);
          },
        ),
      ),
    );
  }
}
