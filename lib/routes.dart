import 'package:flutter/material.dart';

import 'screens/cart_screen.dart';
import 'screens/home_screen.dart';
import 'screens/product_detail_screen.dart';

/// Named route adları ve sayfa eşleşmeleri.
class AppRoutes {
  static const String home = '/';
  static const String detail = '/detail';
  static const String cart = '/cart';

  static Map<String, WidgetBuilder> get routes {
    return {
      home: (context) => const HomeScreen(),
      detail: (context) => const ProductDetailScreen(),
      cart: (context) => const CartScreen(),
    };
  }
}
