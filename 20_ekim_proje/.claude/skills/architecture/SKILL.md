---
name: architecture
description: Use when adding or changing a feature folder, provider, repository, route, navigation guard, session/demo state, or anything about how layers talk to each other.
---

# Mimari Kuralları

## 1. Katmanlar

```
presentation (pages, widgets)
        │  ref.watch / ref.read
        ▼
providers (Notifier, AsyncNotifier, Provider)
        │
        ▼
repository (abstract sınıf)  ◄── MockXRepository (JSON + bellek)
                              ◄── ApiXRepository (ileride, backend gelince)
```

**Kurallar**
- Widget'lar **yalnızca provider** kullanır. Widget içinde repository oluşturulmaz, JSON okunmaz.
- Provider'lar iş mantığını ve state'i tutar. Repository sadece veri getirir ve kaydeder.
- Repository'ler **abstract** tanımlanır. Mock implementasyon tek bir provider satırıyla bağlanır.
- Bir feature başka bir feature'ın `presentation` klasörünü import etmez. Ortak widget'lar `core/widgets/` altına konur.
- Bir feature, başka bir feature'ın **provider'ını** kullanabilir (örneğin community, session'ı okuyabilir).

## 2. Klasör yapısı

```
lib/
├── main.dart                        # ProviderScope + SharedPreferences başlatma
├── app/
│   ├── app.dart                     # MaterialApp.router
│   ├── router.dart                  # routerProvider, rota tanımları, redirect
│   ├── tab_config.dart              # İş planına göre sekme listesi
│   └── theme/
│       ├── app_theme.dart           # lightTheme / darkTheme
│       ├── app_colors.dart          # seed renk + StatusColors (GEÇİCİ değerler)
│       ├── app_tokens.dart          # AppSpacing, AppRadius, AppDurations
│       └── theme_mode_provider.dart
├── core/
│   ├── models/                      # Ortak enum'lar ve tipler
│   ├── session/                     # sessionProvider, SessionState
│   ├── demo/                        # demoSettingsProvider (gecikme, hata simülasyonu)
│   ├── storage/                     # prefsProvider, LocalStore yardımcıları
│   ├── errors/                      # AppException
│   ├── utils/                       # tarih/para formatlama, extension'lar
│   └── widgets/                     # Ortak bileşenler (bkz. design-system/components.md)
├── features/
│   ├── auth/
│   ├── onboarding/
│   ├── verification/
│   ├── support/                     # maddi destek + danışmanlık
│   ├── directory/                   # mentör & yatırımcı ORTAK liste/kart/filtre
│   ├── mentors/
│   ├── investors/
│   ├── matching/
│   ├── programs/
│   ├── community/
│   ├── profile/                     # panel (bento), girişimim sekmeleri, ayarlar
│   └── demo_panel/
assets/
├── mock/
├── images/
└── lottie/
```

Her feature'ın içi şu yapıdadır:

```
features/<feature>/
├── data/
│   ├── models/                      # freezed modeller (feature'a özgü olanlar)
│   ├── <feature>_repository.dart    # abstract
│   └── mock_<feature>_repository.dart
├── providers/
│   └── <feature>_providers.dart
└── presentation/
    ├── pages/
    └── widgets/
```

## 3. İsimlendirme

| Öğe | Kural | Örnek |
|---|---|---|
| Dosya | snake_case | `mentor_detail_page.dart` |
| Sınıf | PascalCase | `MentorDetailPage` |
| Provider | camelCase + `Provider` | `mentorsProvider`, `sessionProvider` |
| Notifier | PascalCase + `Notifier` | `MentorsNotifier` |
| Sayfa | `...Page` | `ProgramsPage` |
| Ortak widget | Anlamlı isim, `App` öneki yalnızca genel bileşenlerde | `PersonCard`, `AppScaffold` |
| ID önekleri | `usr_`, `mnt_`, `inv_`, `prg_`, `pst_`, `cmt_`, `mtc_`, `doc_` | `mnt_004` |

## 4. Provider türleri, ne zaman hangisi?

| İhtiyaç | Tür |
|---|---|
| Repository bağlamak | `Provider<XRepository>` |
| Senkron, değişen state (tema, filtre, beğeniler, session) | `NotifierProvider` |
| Yüklenen ve değiştirilebilen liste (gönderiler, eşleşmeler) | `AsyncNotifierProvider` |
| Salt okunur async veri | `FutureProvider` |
| ID ile detay | `FutureProvider.family<T, String>` |
| Türetilmiş/hesaplanan değer (filtrelenmiş liste, profil yüzdesi) | `Provider` (diğer provider'ları `watch` eder) |

### Örnek: repository → provider → ekran

```dart
// data/directory_repository.dart
abstract class DirectoryRepository {
  Future<List<Mentor>> getMentors();
  Future<List<Investor>> getInvestors();
  Future<DirectoryProfile> getById(String id);
}

// providers/directory_providers.dart
final directoryRepositoryProvider = Provider<DirectoryRepository>(
  (ref) => MockDirectoryRepository(ref),
);

final mentorsProvider = FutureProvider<List<Mentor>>(
  (ref) => ref.watch(directoryRepositoryProvider).getMentors(),
);

final filteredMentorsProvider = Provider<AsyncValue<List<Mentor>>>((ref) {
  final filter = ref.watch(mentorFilterProvider);
  return ref.watch(mentorsProvider).whenData(
        (list) => list.where(filter.matches).toList(),
      );
});

// presentation/pages/mentors_page.dart
final mentors = ref.watch(filteredMentorsProvider);
return AsyncValueView(
  value: mentors,
  loading: () => const SkeletonList(variant: SkeletonVariant.person),
  empty: (list) => list.isEmpty,
  emptyBuilder: () => const EmptyState.mentors(),
  data: (list) => MentorList(items: list),
);
```

## 5. Session ve kullanıcı durumu

`core/session/` içinde tek bir kaynak bulunur:

```dart
@freezed
abstract class SessionState with _$SessionState {
  const factory SessionState({
    AppUser? user,                       // null → giriş yapılmamış
    @Default(false) bool onboardingDone,
  }) = _SessionState;
}
```

- `sessionProvider` (`NotifierProvider<SessionNotifier, SessionState>`), `shared_preferences`'a JSON olarak yazılır ve açılışta oradan okunur.
- `verificationStatus` ve `hasBusinessPlan` değerleri `AppUser` içindedir. Bunları **yalnızca** `SessionNotifier` metotları değiştirir: `submitVerification()`, `setVerificationStatus()`, `setHasBusinessPlan()`.
- Türetilmiş provider'lar:
  - `isApprovedProvider` → `user?.verificationStatus == VerificationStatus.approved`
  - `currentRoleProvider`
  - `profileCompletionProvider` (0–100)

## 6. Router ve yetki kontrolü

```dart
final routerProvider = Provider<GoRouter>((ref) {
  final session = ValueNotifier(ref.read(sessionProvider));
  ref.listen(sessionProvider, (_, next) => session.value = next);
  ref.onDispose(session.dispose);

  return GoRouter(
    initialLocation: '/mentors',
    refreshListenable: session,
    redirect: (context, state) => authGuard(session.value, state.matchedLocation),
    routes: appRoutes,
  );
});
```

**Redirect kuralları** (`authGuard` fonksiyonu, sırayla uygulanır):

| Koşul | Yönlendirme |
|---|---|
| `user == null` ve rota `/welcome`, `/role`, `/login` değil | `/welcome` |
| Giriş yapılmış, `onboardingDone == false`, rol girişimci | `/onboarding` |
| Rota `/support/*` ve kullanıcı onaylı değil | **Yönlendirme yok.** Sayfa açılır ama `LockedOverlay` gösterilir |
| Rota `/demo` ve `kDemoPanelEnabled == false` | `/profile` |
| Giriş yapılmış ve rota `/welcome`, `/role` veya `/login` | `/mentors` |

> Kilitli özellikler **gizlenmez, kilitli gösterilir.** Kullanıcı neyi kaçırdığını görmeli. Bu ürünün temel kararlarından biri.

- Alt bar `StatefulShellRoute.indexedStack` ile 4 dallıdır: `/mentors`, `/investors`, `/programs`, `/community`. Sekmeler arasında geçişte scroll konumu korunur.
- Tüm rotalar: `docs/screens.md`

## 7. İş planına göre sekmeler

`app/tab_config.dart` dosyası:

```dart
class TabConfig {
  const TabConfig({required this.id, required this.label, required this.icon});
  final String id;
  final String label;
  final IconData icon;
}

List<TabConfig> startupTabsFor({required bool hasBusinessPlan}) => hasBusinessPlan
    ? const [
        TabConfig(id: 'overview', label: 'Girişimim', icon: Icons.rocket_launch_outlined),
        TabConfig(id: 'plan', label: 'İş Planım', icon: Icons.description_outlined),
        TabConfig(id: 'investor_ready', label: 'Yatırımcıya Hazırlık', icon: Icons.trending_up),
      ]
    : const [
        TabConfig(id: 'overview', label: 'Girişimim', icon: Icons.rocket_launch_outlined),
        TabConfig(id: 'plan_guide', label: 'İş Planı Hazırla', icon: Icons.edit_note),
      ];
```

**`hasBusinessPlan` koşulu başka hiçbir yerde `if` olarak yazılmaz**, sekme ve içerik bu listeden üretilir.

## 8. Hata yönetimi

- Repository'ler hata durumunda `AppException(message, {cause})` fırlatır. Mesaj kullanıcıya gösterilebilecek Türkçe bir metindir.
- UI tarafında `AsyncValueView` hata durumunda `ErrorState` ve "Tekrar dene" butonu gösterir (`ref.invalidate(...)`).
- Aksiyon hataları (beğeni, istek gönderme) `SnackBar` ile gösterilir. Optimistic update yapıldıysa değişiklik geri alınır.

## 9. Demo altyapısı

- `kDemoPanelEnabled` (`core/demo/`) bir `const bool`'dur. Varsayılan değeri `true` (sunum için).
- `demoSettingsProvider` şunları tutar: `latency` (varsayılan 600 ms), `simulateErrors` (varsayılan `false`).
- Mock repository'ler her çağrıda bu ayarları okur (bkz. `data-models/mock-data.md`).
- Demo panelindeki aksiyonlar **yalnızca** notifier metotlarını çağırır, state'i doğrudan değiştirmez.

## 10. Yapılacaklar / yapılmayacaklar

✅ Yapılacaklar
- Immutable state + `copyWith`
- Listeyi değiştirirken yeni bir koleksiyon oluşturmak (`[...state, item]`, `{...set, id}`)
- `ref.watch` build içinde, `ref.read` callback (onPressed) içinde
- Uzun widget'ları alt widget'lara bölmek (bir build metodu 80 satırı geçmesin)

❌ Yapılmayacaklar
- Widget içinde `rootBundle.loadString`
- `setState` ile uygulama state'i tutmak (yalnızca animasyon gibi yerel UI state'i için kabul edilir)
- `BuildContext`'i async boşluktan sonra `mounted` kontrolü yapmadan kullanmak
- Global singleton ve statik değişkenle state tutmak
- `hasBusinessPlan` ve `verificationStatus` koşullarını ekranlara dağıtmak