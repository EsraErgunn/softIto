# Ortak Bileşenler

> `design-system` skill'inin ek dosyasıdır. Bileşenler `lib/core/widgets/` altında, feature'a özgü olanlar `features/<x>/presentation/widgets/` altında durur.
> **Yeni bir ortak bileşen yazmadan önce burada benzeri var mı diye kontrol et.** Yeni bileşen eklediğinde bu dosyaya da ekle.

## Genel

### AsyncValueView\<T\>
Async veri gösteren ekranların ortak kalıbı.
```dart
AsyncValueView<List<Mentor>>(
  value: ref.watch(filteredMentorsProvider),
  loading: () => const SkeletonList(variant: SkeletonVariant.person),
  empty: (data) => data.isEmpty,        // opsiyonel
  emptyBuilder: () => const EmptyState(...),
  data: (data) => ...,
  onRetry: () => ref.invalidate(mentorsProvider), // opsiyonel, ErrorState'e geçer
)
```
- Hata durumunda `ErrorState`'i otomatik gösterir.
- Yenileme sırasında (veri varken yeniden yükleme) eski veriyi gösterir, iskelete dönmez.

### SkeletonList
- Parametreler: `variant` (`person`, `program`, `post`, `tile`), `itemCount` (varsayılan 6)
- Her varyant ilgili gerçek kartla **aynı yükseklik ve yerleşimdedir**.
- `shimmer` paketi kullanılır, renkler `surfaceContainerHigh` → `surfaceContainerHighest` arasında değişir.

### EmptyState
- Parametreler: `icon` veya `lottieAsset`, `title`, `message`, `actionLabel?`, `onAction?`
- Hazır constructor'lar: `EmptyState.mentors()`, `.investors()`, `.programs()`, `.posts()`, `.matches()`, `.filtered(onClear)`
- Ortalanmış, maksimum genişlik 320, ikon/Lottie 120 dp.

### ErrorState
- Parametreler: `message`, `onRetry?`
- İkon + mesaj + "Tekrar dene" (`OutlinedButton`).

### SectionHeader
- Parametreler: `title`, `actionLabel?` (ör. "Tümünü gör"), `onAction?`
- `titleMedium` stilinde, alt boşluk `AppSpacing.sm`.

## Kimlik ve durum

### VerifiedAvatar
- Parametreler: `name`, `avatarAsset?`, `isVerified`, `size` (`sm=32`, `md=48`, `lg=80`), `heroTag?`
- Görsel yoksa adın **baş harflerini** gösterir. Arka plan rengi isme göre `primaryContainer`, `secondaryContainer` veya `tertiaryContainer` arasından sabit bir seçimdir (aynı isim her zaman aynı renk).
- `isVerified` ise sağ altta `StatusColors.info` renginde küçük bir tik bulunur.
- `heroTag` verilirse `Hero` ile sarılır.

### StatusBadge
- Parametreler: `label`, `icon`, `tone` (`approved`, `pending`, `rejected`, `info`, `neutral`)
- Hazır constructor'lar: `StatusBadge.verification(VerificationStatus)`, `.match(MatchStatus)`, `.deadline(int daysLeft)`
- Hap şeklinde (`AppRadius.full`), `...Container` arka planı + `on...` yazı rengi, `labelSmall` stil.
- Her zaman **ikon + metin** içerir.

### LockedOverlay
- Parametreler: `child`, `isLocked`, `title`, `message`, `actionLabel` (varsayılan "Onay için başvur"), `onAction`
- Kilitliyken `child` `ImageFiltered(blur 6)` ile bulanıklaşır ve dokunmaya kapanır (`AbsorbPointer`). Ortada yarı saydam yüzey üzerinde kilit ikonu, başlık, açıklama ve buton gösterilir.
- Kilit açıldığında bulanıklık `AppDurations.slow` sürede 0'a iner.

### VerificationTimeline
- Parametreler: `status: VerificationStatus`, `submittedAt?`, `reviewedAt?`, `reviewerNote?`
- Adımlar: Başvuru → İnceleme → Uzman görüşmesi → Onay
- Tamamlanan adımlar `approved` renginde ve dolu ikonla, aktif adım vurgulu (ikon biraz büyük, `pending` renginde), gelecek adımlar soluk (`outlineVariant`) gösterilir.
- `rejected` durumunda son adım kırmızıdır ve altında `reviewerNote` ile "Tekrar başvur" butonu bulunur.

### ProfileCompletionCard
- Parametreler: `percent`, `missingItems: List<String>`
- Dairesel ilerleme göstergesi + eksik maddeler. Her madde ilgili düzenleme ekranına götürür.

## Dizin (mentör & yatırımcı)

### PersonCard
- Parametreler: `profile: DirectoryProfile`, `matchState`, `onTap`, `compatibility?` (Faz 2)
- Yerleşim: solda `VerifiedAvatar(md, heroTag)`, ortada ad, alt başlık (mentörse `title`, yatırımcıysa `firm`), şehir, en fazla 3 sektör chip'i. Sağ üstte `compatibility` varsa "%85 uyumlu" etiketi.
- Yatırımcı kartında ek olarak bilet aralığı gösterilir: "₺250B – ₺1,5M".

### MatchButton
- Parametreler: `state` (`none`, `pending`, `accepted`, `rejected`), `onRequest`, `onContact`
- Durumlar:
  - `none` → `FilledButton` "Eşleşme İste"
  - `pending` → pasif `OutlinedButton` "⏳ Bekliyor"
  - `accepted` → `FilledButton.tonal` "İletişime Geç"
  - `rejected` → pasif `TextButton` "Reddedildi"
- Durumlar arasında `AnimatedSwitcher` ile geçilir.
- `onRequest`, mesaj yazılan bir bottom sheet açar (en fazla 300 karakter, opsiyonel).

### ContactCard
- Parametreler: `contact: ContactInfo`, `isVisible`
- Görünmezken alanlar maskelenir (`s•••@•••.com`) ve altında "Eşleşme kabul edilince görünür" notu yer alır. Görünürken satırlara dokunulunca kopyalanır ve `SnackBar` gösterilir.

### FilterBottomSheet + FilterChipGroup
- `FilterChipGroup<T>`: `title`, `options: List<T>`, `selected: Set<T>`, `labelOf`, `onChanged`
- Bottom sheet: başlık + "Temizle" butonu, chip grupları ve altta "Sonuçları göster (n)" butonu. Sonuç sayısı canlı güncellenir.

## Programlar

### ProgramCard
- Parametreler: `program`, `isSaved`, `onTap`, `onToggleSave`
- Yerleşim: üstte tür chip'i + kapsam ("Yurt içi" veya "🌍 AB"), başlık, sağlayıcı, tutar ("₺900.000'e kadar"), altta `DeadlineProgress`. Sağ üstte kaydet (bookmark) ikonu.
- `requiresVerification` ise küçük bir "Onay gerekli" etiketi gösterilir.

### DeadlineProgress
- Parametreler: `deadline`, `totalWindowDays` (varsayılan 60)
- İnce ilerleme çubuğu + "18 gün kaldı" yazısı.
  - 7 günden fazla → `primary`
  - 7 günden az → `pending` + `StatusBadge.deadline`
  - Süresi dolmuş → `rejected`, çubuk dolu, "Süresi doldu"

## Topluluk

### PostCard
- Parametreler: `post`, `isLiked`, `onLike`, `onComment`, `onAuthorTap`
- Yerleşim: yazar satırı (`VerifiedAvatar(sm)`, ad, rol, göreli zaman: "45 dk önce"), içerik (en fazla 6 satır + "Devamını gör"), etiketler, alt satırda `LikeButton` ve yorum sayısı.
- Karta çift dokunulunca beğenilir.

### LikeButton
- Parametreler: `isLiked`, `count`, `onPressed`
- Pop animasyonu, `HapticFeedback.lightImpact()`, sayı değişimi `AnimatedSwitcher` ile.
- Optimistic update yapılır: önce UI güncellenir, hata olursa geri alınır.

### PostComposer
- Bottom sheet veya tam ekran. Çok satırlı alan (en fazla 1000 karakter, sayaç görünür), etiket seçimi (chip), "Paylaş" butonu boşken pasif.

## Profil ve panel

### DashboardTile (bento)
- Parametreler: `size` (`small` = 1×1, `wide` = 2×1, `large` = 2×2), `title`, `child`, `onTap?`
- `Card.filled`, `AppRadius.md`, iç boşluk `AppSpacing.md`.
- Panel yerleşimi (2 sütunlu grid):
  - `large`: Onay durumu (`StatusBadge` + kısa timeline + aksiyon)
  - `small`: Profil tamamlama yüzdesi
  - `small`: Bekleyen eşleşme istekleri sayısı
  - `wide`: En yakın son başvuru tarihi olan kayıtlı program
  - `wide`: Önerilen mentör

### StartupTabs
- `startupTabsFor(hasBusinessPlan)` listesinden `TabBar` + `TabBarView` üretir. **Kendi içinde koşul yazmaz.**

### ThemeModeSelector
- `SegmentedButton<ThemeMode>`: Sistem / Açık / Koyu.

## Demo

### DemoPanel bileşenleri
- `DemoSection(title, children)`: gruplu ayar kartı
- Aksiyonlar `ListTile` + `Switch` / `SegmentedButton` / `FilledButton.tonal` ile gösterilir.
- Sayfanın en üstünde `pending` renginde bir uyarı şeridi bulunur: "Bu panel yalnızca demo amaçlıdır."