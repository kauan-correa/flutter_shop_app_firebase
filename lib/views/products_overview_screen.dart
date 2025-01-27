import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/cart.dart';
import 'package:shop/utils/app_routes.dart';
import 'package:shop/widgets/app_drawer.dart';
import '../widgets/badge.dart' as wdgt;
import 'package:shop/widgets/product_grid.dart';

enum FilterOptions {
  All,
  Favorite,
}

class ProductsOverviewScreen extends StatefulWidget {
  const ProductsOverviewScreen({super.key});

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool _showFavoriteOnly = false;
  FilterOptions selectedMenu = FilterOptions.All;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        actions: [
          PopupMenuButton(
            onSelected: (FilterOptions value) {
              setState(
                () {
                  selectedMenu = value;
                  if (selectedMenu == FilterOptions.All) {
                    _showFavoriteOnly = false;
                  } else {
                    _showFavoriteOnly = true;
                  }
                },
              );
            },
            icon: const Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                value: FilterOptions.All,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("All"),
                    if (selectedMenu == FilterOptions.All)
                      const Icon(
                        Icons.circle,
                        color: Colors.white,
                        size: 12,
                      )
                  ],
                ),
              ),
              PopupMenuItem(
                value: FilterOptions.Favorite,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Favorites"),
                    if (selectedMenu == FilterOptions.Favorite)
                      const Icon(
                        Icons.circle,
                        color: Colors.white,
                        size: 12,
                      )
                  ],
                ),
              ),
            ],
          ),
          Consumer<Cart>(
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.CART);
              },
              icon: const Icon(
                Icons.shopping_cart,
              ),
            ),
            builder: (context, cart, child) => wdgt.Badge(
              value: cart.itemsCount.toString(),
              child: child!,
            ),
          ),
        ],
        title: const Text(
          "My Shop",
        ),
        centerTitle: true,
      ),
      body: ProductGrid(showFavoriteOnly: _showFavoriteOnly),
    );
  }
}
