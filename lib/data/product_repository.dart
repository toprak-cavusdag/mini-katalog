import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/product.dart';

/// Ürünleri assets klasöründeki JSON dosyasından okur (API simülasyonu).
class ProductRepository {
  static const String _path = 'assets/data/products.json';

  Future<List<Product>> loadProducts() async {
    final raw = await rootBundle.loadString(_path);
    final json = jsonDecode(raw) as Map<String, dynamic>;
    final data = json['data'] as List<dynamic>;
    return data
        .map((item) => Product.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
