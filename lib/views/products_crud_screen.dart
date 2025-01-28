import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/products_provider.dart';
import 'package:shop/utils/app_routes.dart';
import 'package:shop/widgets/app_drawer.dart';
import 'package:shop/widgets/product_item.dart';

class ProductsCrudScreen extends StatefulWidget {
  const ProductsCrudScreen({super.key});

  @override
  State<ProductsCrudScreen> createState() => _ProductsCrudScreenState();
}

class _ProductsCrudScreenState extends State<ProductsCrudScreen> {
  bool _isLoading = false;

  void toggleLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  Future<void> _refreshProducts(BuildContext context) async {
    return await Provider.of<ProductsProvider>(context, listen: false)
        .loadProducts();
  }

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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator.adaptive())
          : RefreshIndicator(
              onRefresh: () => _refreshProducts(context),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: ListView.builder(
                  itemCount: products.itemCount,
                  itemBuilder: (ctx, i) {
                    return ProductItem(
                      product: products.items[i],
                      toggleLoading: toggleLoading,
                    );
                  },
                ),
              ),
            ),
    );
  }
}
