---
name: data-models
description: Use when creating or changing any model, enum, JSON shape, collection type (List/Set/Map) or computed value such as profile completion, contact visibility or compatibility score.
---

# Veri Yapıları ve Modeller

Mock JSON formatları ve demo verisi için: `mock-data.md`

## 1. Genel kurallar

- Tüm modeller **freezed** ile yazılır: immutable yapı, `copyWith`, `==`, `fromJson`/`toJson`.
- ID'ler `String` tipindedir ve önek taşır: `usr_`, `mnt_`, `inv_`, `prg_`, `pst_`, `cmt_`, `mtc_`, `doc_`, `sup_`, `cns_`.
- Tarihler `DateTime` tipindedir, JSON'da ISO 8601 formatında tutulur (mock dosyalarındaki göreli tarihler için bkz. `mock-data.md`).
- Para tutarları **TL cinsinden `int`** olarak tutulur (kuruş yok). Gösterim `intl` ile yapılır: `₺250.000`.
- Opsiyonel alanlar `?` ile işaretlenir. Liste alanlarına `@Default([])` verilir, `null` liste kullanılmaz.
- Enum'ların Türkçe etiketleri **extension** ile verilir, enum adının içine Türkçe yazılmaz.
- Model dosyaları: ortak olanlar `lib/core/models/`, feature'a özgü olanlar `features/<x>/data/models/` altına konur.

## 2. Enum'lar

```dart
enum UserRole { entrepreneur, mentor, investor, expert }
enum VerificationStatus { notStarted, pending, approved, rejected }
enum BusinessStage { idea, prototype, earlyRevenue, growth }
enum Sector { fintech, health, agriculture, education, ecommerce, energy, gaming, saas, manufacturing, other }
enum InvestorType { angel, vc, corporate, crowdfunding }
enum MatchStatus { pending, accepted, rejected }
enum MatchTargetType { mentor, investor }
enum ProgramType { grant, loan, accelerator, incubator, competition }
enum ProgramScope { domestic, international }
enum DocumentType { businessPlan, taxCertificate, tradeRegistry, identity, other }
enum ConsultationTopic { legal, accounting, tax, sgk, investment }
enum ApplicationStatus { draft, submitted, inReview, approved, rejected }
enum SessionStatus { requested, scheduled, completed, cancelled }
```

Etiket örneği:

```dart
extension VerificationStatusX on VerificationStatus {
  String get label => switch (this) {
        VerificationStatus.notStarted => 'Başvuru yapılmadı',
        VerificationStatus.pending => 'İncelemede',
        VerificationStatus.approved => 'Onaylı',
        VerificationStatus.rejected => 'Reddedildi',
      };
}
```

Tüm enum'lar için aynı şekilde bir `label` extension'ı yazılır.

## 3. Modeller

### 3.1 Kullanıcı ve girişim

| Model | Alanlar |
|---|---|
| **AppUser** | `id`, `name`, `role: UserRole`, `email`, `avatarAsset?`, `city?`, `bio?`, `verificationStatus` (default `notStarted`), `hasBusinessPlan` (default `false`), `businessProfile: BusinessProfile?` (yalnızca girişimci) |
| **BusinessProfile** | `startupName`, `sector: Sector`, `stage: BusinessStage`, `teamSize: int`, `description?`, `businessPlanFileName?`, `needs: Set<ConsultationTopic>` |
| **AuthorSummary** | `id`, `name`, `avatarAsset?`, `role: UserRole`, `isVerified: bool`. Gönderi ve yorumlarda yazarı göstermek için **denormalize özet** |

### 3.2 Onay süreci

| Model | Alanlar |
|---|---|
| **VerificationApplication** | `id`, `userId`, `status: VerificationStatus`, `documents: List<UploadedDocument>`, `submittedAt?`, `reviewedAt?`, `reviewerName?`, `reviewerNote?` (red gerekçesi) |
| **UploadedDocument** | `id`, `type: DocumentType`, `fileName`, `uploadedAt` |

Zorunlu belgeler (sabit liste):

```dart
const requiredDocuments = {DocumentType.identity, DocumentType.taxCertificate};
// hasBusinessPlan == true ise businessPlan da zorunludur.
```

### 3.3 Mentör ve yatırımcı (sealed union)

Mentör ve yatırımcı ortak liste bileşenini (`directory`) paylaştığı için tek bir **sealed** tipin iki alt türüdür:

```dart
@Freezed(unionKey: 'kind')
sealed class DirectoryProfile with _$DirectoryProfile {
  const factory DirectoryProfile.mentor({
    required String id,
    required String name,
    String? avatarAsset,
    required String bio,
    required String city,
    @Default(false) bool isVerified,
    required ContactInfo contact,
    required String title,
    @Default([]) List<Sector> expertise,
    @Default([]) List<ConsultationTopic> topics,
    required int yearsOfExperience,
  }) = Mentor;

  const factory DirectoryProfile.investor({
    required String id,
    required String name,
    String? avatarAsset,
    required String bio,
    required String city,
    @Default(false) bool isVerified,
    required ContactInfo contact,
    required String firm,
    required InvestorType investorType,
    required int ticketMin,
    required int ticketMax,
    @Default([]) List<Sector> sectors,
    @Default([]) List<BusinessStage> stages,
  }) = Investor;

  factory DirectoryProfile.fromJson(Map<String, dynamic> json) =>
      _$DirectoryProfileFromJson(json);
}
```

Ortak alanlara (`id`, `name`, `bio`, `contact`…) doğrudan `profile.name` ile erişilir. Farklılıklar `switch` ile ele alınır:

```dart
final subtitle = switch (profile) {
  Mentor(:final title) => title,
  Investor(:final firm) => firm,
};
```

| Model | Alanlar |
|---|---|
| **ContactInfo** | `email`, `phone?`, `linkedinUrl?` |

### 3.4 Eşleşme

| Model | Alanlar |
|---|---|
| **MatchRequest** | `id`, `fromUserId`, `targetId`, `targetType: MatchTargetType`, `message`, `status: MatchStatus`, `createdAt`, `respondedAt?` |

### 3.5 Programlar

| Model | Alanlar |
|---|---|
| **FundingProgram** | `id`, `title`, `provider` (TÜBİTAK, KOSGEB…), `type: ProgramType`, `scope: ProgramScope`, `country?` (yurt dışı için), `amountMin?`, `amountMax?`, `deadline: DateTime`, `summary`, `eligibility: List<String>`, `targetStages: List<BusinessStage>`, `sectors: List<Sector>` (boşsa tüm sektörler), `requiresVerification: bool`, `applyUrl?`, `tags: List<String>` |

### 3.6 Destek ve danışmanlık (yalnızca onaylı kullanıcı)

| Model | Alanlar |
|---|---|
| **SupportApplication** | `id`, `userId`, `amountRequested: int`, `purpose`, `status: ApplicationStatus`, `createdAt` |
| **Consultant** | `id`, `name`, `title`, `topics: List<ConsultationTopic>`, `avatarAsset?` |
| **ConsultationSession** | `id`, `consultantId`, `topic`, `dateTime`, `note?`, `status: SessionStatus` |

### 3.7 Topluluk

| Model | Alanlar |
|---|---|
| **Post** | `id`, `author: AuthorSummary`, `content`, `tags: List<String>`, `createdAt`, `likeCount`, `commentCount` |
| **Comment** | `id`, `postId`, `author: AuthorSummary`, `content`, `createdAt` |

> Beğeni bilgisi `Post` içinde tutulmaz. Kullanıcının beğendikleri ayrı bir `Set` olarak tutulur (bkz. bölüm 4).

### 3.8 Ekstra (Faz 2) modeller

| Model | Alanlar |
|---|---|
| **RoadmapStep** | `id`, `title`, `description`, `category: ConsultationTopic`, `order`, `isDone` |
| **EligibilityQuestion** | `id`, `text`, `options: List<EligibilityOption>` |
| **EligibilityOption** | `label`, `value: String` (filtreye dönüşecek anahtar) |
| **AppNotification** | `id`, `title`, `body`, `createdAt`, `isRead`, `route?` (tıklayınca gidilecek rota) |
| **ChatMessage** | `id`, `matchId`, `fromUserId`, `text`, `sentAt` |
| **AppBadge** | `id`, `title`, `description`, `iconName`, `earnedAt?` |

## 4. Koleksiyon seçimleri

| İhtiyaç | Yapı | Provider | Neden |
|---|---|---|---|
| Kullanıcının beğendiği gönderiler | `Set<String>` | `likedPostIdsProvider` | Kontrol O(1), çift beğeni imkânsız |
| Kaydedilen programlar | `Set<String>` | `savedProgramIdsProvider` | Aç/kapat basit |
| Eşleşme istekleri | `Map<String, MatchRequest>` (anahtar `targetId`) | `matchRequestsProvider` | Kart üzerindeki buton durumu anında bulunur |
| Listeler | `List<T>` | ilgili provider | Sıralama ve sayfalama |
| Filtreler | Immutable filtre sınıfı | `mentorFilterProvider` vb. | `copyWith` ile güncellenir, liste otomatik yeniden hesaplanır |
| Yüklenen belgeler | `List<UploadedDocument>` | `verificationProvider` | Sıra önemli, aynı türden tekrar yüklemede eskisi değiştirilir |
| Yol haritası ilerlemesi (Faz 2) | `Set<String>` (tamamlanan adım ID'leri) | `roadmapProgressProvider` | Kalıcı ve küçük |

Güncelleme her zaman **yeni koleksiyonla** yapılır:

```dart
void toggle(String postId) {
  state = state.contains(postId)
      ? ({...state}..remove(postId))
      : {...state, postId};
}
```

### Filtre sınıfları

```dart
@freezed
abstract class DirectoryFilter with _$DirectoryFilter {
  const DirectoryFilter._();
  const factory DirectoryFilter({
    @Default('') String query,
    @Default(<Sector>{}) Set<Sector> sectors,
    @Default(false) bool verifiedOnly,
  }) = _DirectoryFilter;

  bool matches(DirectoryProfile p) { /* query ad/bio içinde geçiyor mu, sektör kesişimi… */ }
  bool get isActive => query.isNotEmpty || sectors.isNotEmpty || verifiedOnly;
}

@freezed
abstract class ProgramFilter with _$ProgramFilter {
  const factory ProgramFilter({
    @Default(<ProgramType>{}) Set<ProgramType> types,
    ProgramScope? scope,                 // null → hepsi
    @Default(false) bool savedOnly,
    @Default(false) bool hideExpired,
  }) = _ProgramFilter;
}
```

## 5. Hesaplanan değerler

Bu değerler **saklanmaz**, her seferinde hesaplanır:

| Değer | Kural |
|---|---|
| `canSeeContact(target)` | `matchRequests[target.id]?.status == MatchStatus.accepted` |
| `matchButtonState(target)` | İstek yok → "Eşleşme İste", `pending` → "Bekliyor", `accepted` → "İletişime Geç", `rejected` → "Reddedildi" (pasif) |
| `profileCompletion` | 5 kriter × %20: avatar, bio, şehir, girişim bilgisi (sektör + aşama), en az 1 belge |
| `daysUntilDeadline` | `deadline.difference(today).inDays`. 7 günden azsa uyarı, 0'dan küçükse "Süresi doldu" |
| `isExpired` | `daysUntilDeadline < 0` |
| `canApplyProgram` | `!program.requiresVerification \|\| isApproved` |
| `compatibilityScore` (Faz 2) | Sektör kesişimi %50 + aşama uyumu %30 + şehir aynıysa %20. Sonuç 0–100, tam sayıya yuvarlanır |

## 6. Kalıcı veriler (shared_preferences anahtarları)

| Anahtar | Tür | İçerik |
|---|---|---|
| `theme_mode` | String | `system` / `light` / `dark` |
| `session` | String (JSON) | `SessionState` |
| `liked_post_ids` | List<String> | Beğeniler |
| `saved_program_ids` | List<String> | Kaydedilen programlar |
| `match_requests` | String (JSON) | `Map<String, MatchRequest>` |
| `verification` | String (JSON) | `VerificationApplication` |
| `user_posts` | String (JSON) | Kullanıcının oluşturduğu gönderiler |
| `roadmap_done` | List<String> | Faz 2 |

Demo panelindeki **"Tüm veriyi sıfırla"** aksiyonu bu anahtarların hepsini siler.

## 7. Kontrol listesi

- [ ] Model freezed ile yazıldı, `fromJson` var
- [ ] Liste alanlarında `@Default([])` kullanıldı
- [ ] Enum'a Türkçe `label` extension'ı eklendi
- [ ] Mock JSON'da karşılık gelen alanlar eklendi (`mock-data.md`)
- [ ] `build_runner` çalıştırıldı, `flutter analyze` temiz