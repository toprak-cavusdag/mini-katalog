import 'package:flutter/material.dart';

import '../models/product.dart';
import '../routes.dart';
import '../state/cart.dart';
import '../theme/app_theme.dart';

/// Ürün detay sayfası. Ürün, route argument olarak alınır.
class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context)!.settings.arguments as Product;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Geri'),
        titleSpacing: 0,
        actions: [
          IconButton(
            tooltip: 'Sepet',
            onPressed: () => Navigator.pushNamed(context, AppRoutes.cart),
            icon: const Icon(Icons.shopping_bag_outlined),
          ),
        ],
      ),
      body: ListView(
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Hero(
              tag: 'product-${product.id}',
              child: Image.asset(product.image, fit: BoxFit.cover),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        product.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      product.price,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.accent,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  product.tagline,
                  style: const TextStyle(
                    color: AppTheme.muted,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 20),
                const _SectionTitle('Açıklama'),
                const SizedBox(height: 8),
                Text(product.description, style: const TextStyle(height: 1.5)),
                const SizedBox(height: 20),
                const _SectionTitle('Özellikler'),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final spec in product.specs.entries)
                      _SpecBox(label: spec.key, value: spec.value),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: _CartButton(product: product),
        ),
      ),
    );
  }
}

/// Sepete ekle / çıkar butonu. Sepet değiştikçe kendini günceller.
class _CartButton extends StatelessWidget {
  final Product product;

  const _CartButton({required this.product});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: cart,
      builder: (context, child) {
        final inCart = cart.contains(product);
        if (inCart) {
          return OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () => cart.remove(product),
            icon: const Icon(Icons.check),
            label: const Text('Sepetten Çıkar'),
          );
        }
        return FilledButton.icon(
          onPressed: () {
            cart.add(product);
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(content: Text('${product.name} sepete eklendi.')),
              );
          },
          icon: const Icon(Icons.add_shopping_cart),
          label: const Text('Sepete Ekle'),
        );
      },
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;

  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
    );
  }
}

class _SpecBox extends StatelessWidget {
  final String label;
  final String value;

  const _SpecBox({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE0E0E4)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: const TextStyle(fontSize: 10, color: AppTheme.muted),
          ),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
