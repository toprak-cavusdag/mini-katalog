import 'package:flutter/material.dart';

import '../data/product_repository.dart';
import '../models/product.dart';
import '../routes.dart';
import '../state/cart.dart';
import '../theme/app_theme.dart';
import '../widgets/product_card.dart';

/// Ana sayfa: arama, banner, kategori filtresi ve ürün ızgarası.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const String _allCategories = 'Tümü';

  late final Future<List<Product>> _productsFuture;
  String _query = '';
  String _category = _allCategories;

  @override
  void initState() {
    super.initState();
    _productsFuture = ProductRepository().loadProducts();
  }

  /// Arama metnine ve seçili kategoriye göre listeyi süzer.
  List<Product> _filter(List<Product> products) {
    final query = _query.trim().toLowerCase();
    return products.where((product) {
      final matchesCategory =
          _category == _allCategories || product.category == _category;
      final matchesQuery =
          query.isEmpty ||
          product.name.toLowerCase().contains(query) ||
          product.tagline.toLowerCase().contains(query);
      return matchesCategory && matchesQuery;
    }).toList();
  }

  void _openDetail(Product product) {
    Navigator.pushNamed(context, AppRoutes.detail, arguments: product);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<List<Product>>(
          future: _productsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Center(child: Text('Ürünler yüklenemedi.'));
            }
            final products = snapshot.data ?? [];
            return _buildContent(products);
          },
        ),
      ),
    );
  }

  Widget _buildContent(List<Product> products) {
    final filtered = _filter(products);
    final categories = <String>{
      _allCategories,
      ...products.map((product) => product.category),
    }.toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        _buildHeader(),
        const SizedBox(height: 16),
        _buildSearchField(),
        const SizedBox(height: 16),
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.asset('assets/images/banner.png', fit: BoxFit.cover),
        ),
        const SizedBox(height: 16),
        _buildCategoryChips(categories),
        const SizedBox(height: 16),
        if (filtered.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 48),
            child: Center(
              child: Text(
                'Aramanıza uygun ürün bulunamadı.',
                style: TextStyle(color: AppTheme.muted),
              ),
            ),
          )
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filtered.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.72,
            ),
            itemBuilder: (context, index) {
              final product = filtered[index];
              return ProductCard(
                product: product,
                onTap: () => _openDetail(product),
              );
            },
          ),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Keşfet',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
              ),
              SizedBox(height: 2),
              Text(
                'Sana uygun cihazı bul.',
                style: TextStyle(color: AppTheme.muted),
              ),
            ],
          ),
        ),
        ListenableBuilder(
          listenable: cart,
          builder: (context, child) {
            return IconButton(
              tooltip: 'Sepet',
              onPressed: () => Navigator.pushNamed(context, AppRoutes.cart),
              icon: Badge(
                isLabelVisible: !cart.isEmpty,
                label: Text('${cart.count}'),
                child: const Icon(Icons.shopping_bag_outlined),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSearchField() {
    return TextField(
      onChanged: (value) => setState(() => _query = value),
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: 'Ürün ara',
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: AppTheme.surface,
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildCategoryChips(List<String> categories) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = categories[index];
          return ChoiceChip(
            label: Text(category),
            selected: category == _category,
            onSelected: (_) => setState(() => _category = category),
          );
        },
      ),
    );
  }
}
