import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shop/providers/cart.dart';
import 'package:shop/providers/orders.dart';
import 'package:shop/providers/products_provider.dart';
import 'package:shop/providers/settings.dart';

import 'package:shop/utils/app_routes.dart';

import 'package:shop/views/cart_screen.dart';
import 'package:shop/views/orders_screen.dart';
import 'package:shop/views/product_detail_screen.dart';
import 'package:shop/views/product_form_screen.dart';
import 'package:shop/views/products_crud_screen.dart';
import 'package:shop/views/products_overview_screen.dart';
import 'package:shop/views/settings_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ProductsProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (_) => Orders(),
        ),
        ChangeNotifierProvider(
          create: (_) => SettingsProvider(),
        ),
      ],
      child: Main(),
    );
  }
}

class Main extends StatelessWidget {
  Main({
    super.key,
  });

  final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: const Color.fromARGB(255, 202, 200, 200),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        iconColor: WidgetStateProperty.all<Color>(Colors.white),
      ),
    ),
    colorScheme: const ColorScheme.light(
      primary: Colors.pink,
      secondary: Colors.deepOrangeAccent,
      tertiary: Colors.black,
      surface: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromARGB(255, 189, 14, 72),
      titleTextStyle: TextStyle(
          color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black, fontSize: 16),
      bodyMedium: TextStyle(color: Colors.black, fontSize: 14),
      labelMedium: TextStyle(color: Colors.white, fontSize: 16),
      headlineLarge: TextStyle(
          color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
    ),
  );

  final ThemeData darkTheme = ThemeData(
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        iconColor: WidgetStateProperty.all<Color>(Colors.white),
      ),
    ),
    colorScheme: ColorScheme.dark(
      primary: const Color.fromARGB(255, 189, 14, 72),
      secondary: Colors.deepOrangeAccent,
      tertiary: Colors.white,
      surface: Colors.grey[850]!,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromARGB(255, 189, 14, 72),
      titleTextStyle: TextStyle(
          color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white, fontSize: 16),
      bodyMedium: TextStyle(color: Colors.white, fontSize: 14),
      labelMedium: TextStyle(color: Colors.white, fontSize: 16),
      headlineLarge: TextStyle(
          color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Provider.of<SettingsProvider>(context).isDarkMode
          ? darkTheme
          : lightTheme,
      initialRoute: AppRoutes.HOME,
      routes: {
        AppRoutes.HOME: (ctx) => const ProductsOverviewScreen(),
        AppRoutes.PRODUCT_DETAIL: (ctx) => const ProductDetailScreen(),
        AppRoutes.CART: (ctx) => const CartScreen(),
        AppRoutes.ORDERS: (ctx) => const OrdersScreen(),
        AppRoutes.PRODUCTS: (ctx) => const ProductsCrudScreen(),
        AppRoutes.PRODUCT_FORM: (ctx) => const ProductFormScreen(),
        AppRoutes.SETTINGS: (ctx) => const SettingsScreen(),
      },
    );
  }
}
