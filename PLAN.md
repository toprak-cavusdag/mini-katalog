# Mini Katalog ödev çalışma planı

Amaç: Flutter ile ana sayfa, ürün detayı ve sepet ekranlarından oluşan "Mini Katalog Uygulaması"nı geliştirmek; projeyi README ve ekran görüntüleriyle birlikte public bir GitHub deposunda teslim etmek.

Yönergenin kısıtları:

- Yalnızca `material.dart` kullanılacak, ek paket eklenmeyecek.
- Ek paket olmadığı için ürünler internetten çekilmeyecek; wantapi.com verisi ve görselleri `assets/` klasörüne indirildi ve oradan okunuyor (JSON simülasyonu).

## 1. Kurulum ve temel yapı

- [x] Proje klasörünü aç: `mini-katalog/`.
- [x] Flutter SDK'yı kur (Homebrew).
- [x] `flutter create` ile Android ve iOS proje iskeletini oluştur.
- [x] Klasör yapısını kur: `models`, `data`, `state`, `screens`, `widgets`, `theme`.

## 2. Veri ve model

- [x] wantapi.com ürün verisini `assets/data/products.json` olarak kaydet (20 ürün).
- [x] Ürün görsellerini ve banner'ı `assets/images/` altına indir.
- [x] `Product` model sınıfını `fromJson` / `toJson` ile yaz.
- [x] JSON'u asset'ten okuyan `ProductRepository` sınıfını yaz.
- [x] Asset'leri `pubspec.yaml` içinde tanımla.

## 3. Ekranlar

- [x] Ana sayfa: başlık, arama kutusu, banner, kategori filtresi, `GridView` ile ürün kartları.
- [x] Ürün detayı: görsel, ad, fiyat, açıklama, özellikler, sepete ekle butonu.
- [x] Sepet: `ListView.builder` ile ürün listesi, ürün çıkarma, toplam tutar, boş sepet görünümü, sipariş simülasyonu.

## 4. Navigasyon ve state

- [x] Named route tanımları (`/`, `/detail`, `/cart`).
- [x] Ürünü detay sayfasına route argument olarak taşı.
- [x] Sepet için basit state yönetimi (`ChangeNotifier` + `ListenableBuilder`).
- [x] Arama ve kategori filtresi için `setState`.

## 5. Kontrol

- [x] `flutter analyze` hatasız geçsin.
- [x] Testler geçsin (`flutter test`).
- [x] Uygulamayı iOS simülatöründe çalıştır ve dört ekranı görüntüle.
- [ ] Android emülatöründe çalıştır (bu makinede denenmedi: disk alanı yetersiz, Android cmdline-tools eksik).
- [ ] Ekranları elle dene: arama, filtre, sepete ekle/çıkar, siparişi tamamla.

## 6. Teslim

- [x] Ekran görüntülerini al ve `ekran-goruntuleri/` klasörüne koy: ana sayfa, detay, dolu sepet, boş sepet.
- [x] README'yi tamamla: proje adı, kısa açıklama, Flutter sürümü, çalıştırma adımları, ekran görüntüleri.
- [ ] Public GitHub deposu aç ve projeyi gönder.
- [ ] Depo URL'ini ve ekran görüntülerini teslim et.

Not: GitHub URL'i olmayan veya ekran görüntüsü eksik projeler teslim edilmiş sayılmıyor.
