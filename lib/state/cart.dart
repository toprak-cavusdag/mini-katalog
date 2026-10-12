import 'package:flutter/foundation.dart';

import '../models/product.dart';

/// Basit sepet simülasyonu. Veriler yalnızca uygulama açıkken bellekte tutulur.
class Cart extends ChangeNotifier {
  final List<Product> _items = [];

  List<Product> get items => List.unmodifiable(_items);

  int get count => _items.length;

  bool get isEmpty => _items.isEmpty;

  double get total {
    double sum = 0;
    for (final product in _items) {
      sum += product.priceValue;
    }
    return sum;
  }

  bool contains(Product product) {
    return _items.any((item) => item.id == product.id);
  }

  void add(Product product) {
    if (contains(product)) return;
    _items.add(product);
    notifyListeners();
  }

  void remove(Product product) {
    _items.removeWhere((item) => item.id == product.id);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}

/// Uygulama genelinde kullanılan tek sepet nesnesi.
final Cart cart = Cart();
