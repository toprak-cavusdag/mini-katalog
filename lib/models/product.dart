/// Katalogdaki tek bir ürünü temsil eden model sınıfı.
class Product {
  final int id;
  final String name;
  final String tagline;
  final String description;
  final String price;
  final String currency;
  final String image;
  final Map<String, String> specs;

  const Product({
    required this.id,
    required this.name,
    required this.tagline,
    required this.description,
    required this.price,
    required this.currency,
    required this.image,
    required this.specs,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final specs = json['specs'] as Map<String, dynamic>? ?? {};
    return Product(
      id: json['id'] as int,
      name: json['name'] as String,
      tagline: json['tagline'] as String? ?? '',
      description: json['description'] as String? ?? '',
      price: json['price'] as String,
      currency: json['currency'] as String? ?? 'USD',
      image: json['image'] as String,
      specs: specs.map((key, value) => MapEntry(key, value.toString())),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'tagline': tagline,
      'description': description,
      'price': price,
      'currency': currency,
      'image': image,
      'specs': specs,
    };
  }

  /// "$2,499" gibi bir metni toplam hesabı için sayıya çevirir.
  double get priceValue {
    final digits = price.replaceAll(RegExp(r'[^0-9.]'), '');
    return double.tryParse(digits) ?? 0;
  }

  /// JSON'da kategori alanı olmadığı için ürün adından türetilir.
  String get category {
    if (name.contains('iPhone')) return 'iPhone';
    if (name.contains('Mac')) return 'Mac';
    if (name.contains('iPad')) return 'iPad';
    if (name.contains('Watch')) return 'Watch';
    if (name.contains('AirPods') || name.contains('HomePod')) return 'Ses';
    return 'Diğer';
  }
}
