---
name: design-system
description: Use when creating or changing any screen, widget, theme, spacing, typography, animation, empty/loading/error state, or dark/light mode behaviour.
---

# Tasarım Sistemi

Bileşen tanımları için: `components.md`

## 1. Prensipler

1. **Güven önce gelir.** Hukuk ve para konuşulan bir uygulama: sade, düzenli, tutarlı. Süs ikinci planda.
2. **Her ekranın tek bir ana aksiyonu vardır.** Örneğin "Eşleşme İste", "Başvur", "Paylaş". Ana aksiyon `FilledButton`, diğerleri `OutlinedButton` veya `TextButton` olur.
3. **Kilitli özellik gizlenmez.** Bulanık ve kilitli gösterilir, kullanıcı neyi neden göremediğini ve nasıl açacağını bilir.
4. **Durum her zaman görünür.** Onay durumu, eşleşme durumu ve son başvuru tarihi renkli rozetlerle belirtilir.
5. **Kart tabanlı düzen.** Listeler kartlardan oluşur, kartlar arası boşluk tutarlıdır.

## 2. Renk

> ⏸️ **Palet henüz kararlaştırılmadı.** Aşağıdaki kurallar her paletle geçerlidir. Renk kararı alındığında yalnızca `app_colors.dart` değişir.

```dart
// app/theme/app_colors.dart
const kSeedColor = Color(0xFF3F51B5); // GEÇİCİ: renk kararı bekliyor
```

- Tema `ColorScheme.fromSeed(seedColor: kSeedColor, brightness: ...)` ile üretilir (Material 3).
- **Sabit `Color(0x...)` ve `Colors.xxx` kullanmak yasaktır.** Renkler yalnızca şuralardan alınır:
  - `Theme.of(context).colorScheme` (primary, surface, outline…)
  - `Theme.of(context).extension<StatusColors>()!`
- Durum renkleri için `StatusColors` adlı bir `ThemeExtension` vardır. Açık ve koyu tema için ayrı değerleri bulunur:

| Alan | Anlamı | Kullanım |
|---|---|---|
| `approved` | Başarılı / onaylı | Onaylı rozeti, kabul edilen eşleşme |
| `pending` | Bekliyor / uyarı | İncelemede, son başvuruya 7 günden az kaldı |
| `rejected` | Hata / red | Reddedildi, süresi doldu |
| `info` | Bilgi / doğrulanmış | Doğrulanmış tiki, bilgi kutuları |

Her alanın bir de `on...` karşılığı (rozet içindeki yazı rengi) ve `...Container` karşılığı (açık arka plan) bulunur.

- Program türü chip'leri `colorScheme`'in `primaryContainer`, `secondaryContainer` ve `tertiaryContainer` renklerini sırayla kullanır.

## 3. Tasarım token'ları

```dart
// app/theme/app_tokens.dart
abstract final class AppSpacing {
  static const xxs = 2.0;
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;
  static const xxl = 48.0;
  static const screenPadding = EdgeInsets.symmetric(horizontal: md);
}

abstract final class AppRadius {
  static const sm = 8.0;     // chip, küçük buton, input
  static const md = 16.0;    // kart
  static const lg = 24.0;    // bottom sheet, büyük panel
  static const full = 999.0; // rozet, avatar
}

abstract final class AppDurations {
  static const fast = Duration(milliseconds: 150);    // basma, toggle
  static const normal = Duration(milliseconds: 250);  // genel geçişler
  static const slow = Duration(milliseconds: 400);    // sayfa içi büyük değişim
  static const stagger = Duration(milliseconds: 50);  // liste öğeleri arası gecikme
}
```

**Kural:** `EdgeInsets.all(13)`, `BorderRadius.circular(10)`, `Duration(milliseconds: 320)` gibi sabit sayılar yazılmaz. Token kullanılır.

## 4. Tipografi

- Yalnızca `Theme.of(context).textTheme` stilleri kullanılır. `TextStyle(fontSize: 17)` yazılmaz.
- Font ailesi ⏸️ **karar bekliyor**, şimdilik sistem fontu kullanılıyor.

| Kullanım | Stil |
|---|---|
| Sayfa başlığı | `headlineSmall` |
| Bölüm başlığı | `titleMedium` (+ `FontWeight.w600`) |
| Kart başlığı | `titleSmall` |
| Gövde metni | `bodyMedium` |
| Yardımcı metin, tarih | `bodySmall` + `onSurfaceVariant` |
| Rozet, chip | `labelSmall` / `labelMedium` |

## 5. Düzen ve navigasyon

- Ekran kenar boşluğu: `AppSpacing.screenPadding` (16).
- Kartlar arası dikey boşluk: `AppSpacing.sm` (8). Bölümler arası: `AppSpacing.lg` (24).
- Alt bar: Material 3 `NavigationBar`, 4 sekme: **Mentörler, Yatırımcılar, Programlar, Topluluk**.
- App bar sağ tarafı: bildirim ikonu (Faz 2) + kullanıcı avatarı (`VerifiedAvatar`). Avatara dokununca profil açılır.
- Filtreler **bottom sheet** içinde açılır. Aktif filtre sayısı, filtre ikonunun üstünde bir `Badge` ile gösterilir.
- Detay sayfalarında ana aksiyon, ekranın altına sabitlenmiş bir buton alanında durur (`bottomNavigationBar` slotu, `SafeArea` ile).
- Formlar tek sütunludur, etiketler alanların üstündedir. Hata mesajı alanın altında gösterilir.

## 6. Hareket (animasyon)

| Desen | Nerede | Nasıl |
|---|---|---|
| **Hero** | Kişi kartı → detay sayfası | Avatar, `Hero(tag: 'avatar-${id}')` ile uçarak geçer |
| **Sırayla belirme** | Tüm listeler | `flutter_animate`: `fadeIn` + `slideY(begin: 0.1)`, öğe başına `AppDurations.stagger`. **Yalnızca ilk 8 öğe** animasyonlu |
| **Shimmer** | Tüm yükleme durumları | `SkeletonList`, gerçek kart şekliyle aynı iskelet |
| **Beğeni pop** | `LikeButton` | Kalp 1.0 → 1.3 → 1.0 ölçeklenir, `HapticFeedback.lightImpact()`. Gönderiye çift dokunuşla da beğenilir |
| **Durum geçişi** | Eşleşme butonu, rozetler | `AnimatedSwitcher`, `AppDurations.normal` |
| **Kilit açılması** | Onay sonrası destek ekranı | Bulanıklık 0'a iner ve kilit ikonu kaybolur |

**Kurallar:** animasyon 400 ms'yi geçmez, döngüsel animasyon olmaz (Lottie boş durumları hariç). `MediaQuery.disableAnimations` açıksa animasyonlar kapatılır.

## 7. Durum ekranları (zorunlu)

Async veri gösteren **her** ekranda dört durum da tasarlanır:

| Durum | Gösterim |
|---|---|
| Loading | `SkeletonList`, gerçek içerikle aynı şekilde. **Ortada dönen `CircularProgressIndicator` ile tam ekran yükleme kullanılmaz** |
| Empty | `EmptyState`: ikon veya Lottie, başlık, açıklama ve yönlendirici bir buton |
| Error | `ErrorState`: mesaj + "Tekrar dene" |
| Data | İçerik. Filtre sonucu boşsa "Filtreleri temizle" butonlu bir `EmptyState` gösterilir |

Ortak kalıp `AsyncValueView` widget'ıdır (bkz. `components.md`).

## 8. Karanlık / aydınlık mod

- `ThemeMode` üç seçeneklidir: Sistem / Açık / Koyu. Varsayılan Sistem'dir ve seçim kaydedilir.
- Her ekran **iki temada da** kontrol edilir.
- Görsellerde ve illüstrasyonlarda koyu temada saf beyaz arka plan bırakılmaz.
- Gölge yerine Material 3 yüzey tonları (`surfaceContainerLow`, `surfaceContainerHigh`) kullanılır. Kartlar `Card.filled` veya `Card.outlined` olur.

## 9. Erişilebilirlik

- Dokunma alanları en az **48×48 dp**.
- Yalnızca ikondan oluşan butonlarda `tooltip` bulunur.
- Durum **sadece renkle** anlatılmaz, rozetlerde her zaman ikon + metin olur (✓ Onaylı, ⏳ İncelemede).
- Metin ölçeği 1.3'e çıktığında düzen bozulmaz. Uzun metinlerde `maxLines` + `TextOverflow.ellipsis` kullanılır.
- Avatarlar ve görseller için `semanticLabel` verilir.

## 10. Öne çıkan tasarım desenleri

| Desen | Ekran |
|---|---|
| **Bento panel** | Profil (`/profile`): farklı boyutlarda kutucuklar: onay durumu (büyük), profil tamamlama yüzdesi, yaklaşan program, önerilen mentör, eşleşme istekleri |
| **Onay timeline'ı** | Doğrulama ekranı: dikey adımlar *Başvuru → İnceleme → Uzman görüşmesi → Onay*. Tamamlanan adım dolu ikonla, aktif adım vurgulu ve hafif büyütülmüş, gelecek adımlar soluk gösterilir |
| **Kilitli özellik** | Destek ve danışmanlık: içerik `ImageFiltered` ile bulanık, üstte kilit ikonu, açıklama ve "Onay için başvur" butonu (`LockedOverlay`) |
| **Son başvuru çubuğu** | Program kartları: kalan süre ilerleme çubuğu. 7 günden az kaldıysa `pending`, süresi dolduysa `rejected` rengi ve "Süresi doldu" etiketi |
| **Doğrulanmış tiki** | Onaylı kullanıcıların avatarının sağ alt köşesinde küçük `info` renkli tik |
| **Chip filtreleri** | Programlar ve dizin: bottom sheet içinde `FilterChip` grupları |

## 11. Ekran tamamlanma kontrol listesi

- [ ] Sabit renk, boşluk veya süre yok, token'lar kullanıldı
- [ ] Loading (skeleton), empty, error ve data durumları var
- [ ] Açık ve koyu temada kontrol edildi
- [ ] 360 dp genişlikte ve metin ölçeği 1.3'te taşma yok
- [ ] Ana aksiyon tek ve belirgin
- [ ] Liste animasyonları yalnızca ilk 8 öğede, 400 ms altında
- [ ] Rozetlerde ikon + metin var
- [ ] İkon butonlarında tooltip var