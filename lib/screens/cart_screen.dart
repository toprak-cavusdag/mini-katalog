import 'package:flutter/material.dart';

import '../models/product.dart';
import '../state/cart.dart';
import '../theme/app_theme.dart';

/// Sepet sayfası: eklenen ürünler, toplam tutar ve sipariş simülasyonu.
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  Future<void> _checkout(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sipariş alındı'),
          content: const Text(
            'Bu bir simülasyondur, gerçek bir ödeme yapılmadı.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tamam'),
            ),
          ],
        );
      },
    );
    cart.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sepet'), titleSpacing: 0),
      body: ListenableBuilder(
        listenable: cart,
        builder: (context, child) {
          return Column(
            children: [
              Expanded(child: cart.isEmpty ? const _EmptyCart() : _buildList()),
              _buildFooter(context),
            ],
          );
        },
      ),
    );
  }

  Widget _buildList() {
    final items = cart.items;
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final Product product = items[index];
        return ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              product.image,
              width: 56,
              height: 56,
              fit: BoxFit.cover,
            ),
          ),
          title: Text(
            product.name,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.tagline,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(product.price),
            ],
          ),
          isThreeLine: true,
          trailing: IconButton(
            tooltip: 'Sepetten çıkar',
            onPressed: () => cart.remove(product),
            icon: const Icon(Icons.remove_circle_outline),
          ),
        );
      },
    );
  }

  Widget _buildFooter(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, size: 18),
                  const SizedBox(width: 8),
                  const Expanded(child: Text('Toplam')),
                  Text(
                    formatPrice(cart.total),
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            FilledButton(
              onPressed: cart.isEmpty ? null : () => _checkout(context),
              child: const Text('Siparişi Tamamla'),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyCart extends StatelessWidget {
  const _EmptyCart();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 56, color: AppTheme.muted),
          SizedBox(height: 12),
          Text(
            'Sepetin boş',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 4),
          Text(
            'Alışverişe başlamak için ürün ekle.',
            style: TextStyle(color: AppTheme.muted),
          ),
        ],
      ),
    );
  }
}
