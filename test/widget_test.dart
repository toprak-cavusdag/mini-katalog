import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mini_katalog/main.dart';
import 'package:mini_katalog/models/product.dart';
import 'package:mini_katalog/state/cart.dart';

void main() {
  const product = Product(
    id: 99,
    name: 'MacBook Pro 16"',
    tagline: 'Test',
    description: 'Test',
    price: r'$2,499',
    currency: 'USD',
    image: 'assets/images/macbook.png',
    specs: {'chip': 'M3'},
  );

  setUp(cart.clear);

  test('Product JSON dönüşümü ve fiyat hesabı', () {
    final copy = Product.fromJson(product.toJson());

    expect(copy.name, product.name);
    expect(copy.specs['chip'], 'M3');
    expect(copy.priceValue, 2499);
    expect(copy.category, 'Mac');
  });

  test('Sepete ekleme, çıkarma ve toplam', () {
    cart.add(product);
    cart.add(product);

    expect(cart.count, 1);
    expect(cart.total, 2499);

    cart.remove(product);

    expect(cart.isEmpty, isTrue);
  });

  test('Tutar binlik ayraçla yazılır', () {
    expect(formatPrice(0), r'$0');
    expect(formatPrice(799), r'$799');
    expect(formatPrice(4098), r'$4,098');
    expect(formatPrice(1234567), r'$1,234,567');
  });

  testWidgets('Arama, detay ve sepet akışı', (tester) async {
    // Telefon boyutunda bir ekran kullanılır.
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const MiniKatalogApp());
    await tester.pumpAndSettle();

    expect(find.text('Keşfet'), findsOneWidget);
    expect(find.text('iPhone 15 Pro'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'homepod mini');
    await tester.pumpAndSettle();

    expect(find.text('iPhone 15 Pro'), findsNothing);
    expect(find.text('HomePod Mini'), findsOneWidget);

    await tester.ensureVisible(find.text('HomePod Mini'));
    await tester.tap(find.text('HomePod Mini'));
    await tester.pumpAndSettle();

    expect(find.text('Sepete Ekle'), findsOneWidget);

    await tester.tap(find.text('Sepete Ekle'));
    await tester.pumpAndSettle();

    expect(cart.count, 1);

    await tester.tap(find.byIcon(Icons.shopping_bag_outlined));
    await tester.pumpAndSettle();

    expect(find.text('Siparişi Tamamla'), findsOneWidget);
    // Hem ürün satırında hem toplamda aynı tutar görünür.
    expect(find.text(r'$99'), findsNWidgets(2));
  });
}
