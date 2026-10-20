---
name: data-models
description: Use when creating, modifying, or extending any data model, enum, JSON serialization, freezed class, or data conversion in the application.
---

# Veri Yapıları ve Modeller

> Mock JSON formatları ve örnek veri için: `mock-data.md`

## 1. Prensipler

1. **Tüm modeller `freezed` ile tanımlanır.** Elle `copyWith`, `==`, `hashCode` yazılmaz.
2. **JSON serileştirme iki yönlüdür.** Tüm modeller `fromJson` ve `toJson` metoduna sahiptir.
3. **Enum'lar tür güvenlidir.** String yerine her zaman ilgili enum kullanılır.
4. **Her enum'ın kullanıcı dostu Türkçe `label` extension'ı bulunur.** Arayüzde doğrudan enum string'i basılmaz.
5. **ID kuralları:** Her model türü kendine özel bir önekle başlar (`usr_`, `mnt_`, `inv_`, `prg_`, `pst_`, `cmt_`, `mtc_`, `doc_`, `cns_`, `ses_`, `sup_`, `rdm_`).

---

## 2. Enum Tanımları

### 2.1 UserRole (Kullanıcı Rolü)
```dart
enum UserRole {
  entrepreneur,
  mentor,
  investor;

  String get label => switch (this) {
    UserRole.entrepreneur => 'Girişimci',
    UserRole.mentor => 'Mentör',
    UserRole.investor => 'Yatırımcı',
  };
}
```

### 2.2 VerificationStatus (Doğrulama / Onay Durumu)
```dart
enum VerificationStatus {
  notStarted,
  pending,
  approved,
  rejected;

  String get label => switch (this) {
    VerificationStatus.notStarted => 'Başvurulmadı',
    VerificationStatus.pending => 'İncelemede',
    VerificationStatus.approved => 'Onaylandı',
    VerificationStatus.rejected => 'Reddedildi',
  };
}
```

### 2.3 Sector (Sektör)
```dart
enum Sector {
  fintech,
  health,
  education,
  agriculture,
  saas,
  eCommerce,
  ai,
  gaming,
  energy,
  other;

  String get label => switch (this) {
    Sector.fintech => 'Fintek',
    Sector.health => 'Sağlık',
    Sector.education => 'Eğitim',
    Sector.agriculture => 'Tarım Teknolojileri',
    Sector.saas => 'SaaS & Bulut',
    Sector.eCommerce => 'E-Ticaret & Pazaryeri',
    Sector.ai => 'Yapay Zekâ',
    Sector.gaming => 'Oyun',
    Sector.energy => 'Enerji & Sürdürülebilirlik',
    Sector.other => 'Diğer',
  };
}
```

### 2.4 StartupStage (Girişim Aşaması)
```dart
enum StartupStage {
  idea,
  prototype,
  earlyRevenue,
  growth,
  scale;

  String get label => switch (this) {
    StartupStage.idea => 'Fikir Aşaması',
    StartupStage.prototype => 'Prototip / MVP',
    StartupStage.earlyRevenue => 'Erken Gelir',
    StartupStage.growth => 'Büyüme',
    StartupStage.scale => 'Ölçeklenme',
  };
}
```

### 2.5 NeedType (Girişim İhtiyacı)
```dart
enum NeedType {
  legal,
  tax,
  accounting,
  investment,
  grant,
  mentor;

  String get label => switch (this) {
    NeedType.legal => 'Hukuki Danışmanlık',
    NeedType.tax => 'Vergi & SGK',
    NeedType.accounting => 'Mali Müşavirlik',
    NeedType.investment => 'Yatırım Arama',
    NeedType.grant => 'Hibe & Teşvik',
    NeedType.mentor => 'Mentörlük',
  };
}
```

### 2.6 InvestorType (Yatırımcı Türü)
```dart
enum InvestorType {
  angel,
  vc,
  accelerator,
  corporate;

  String get label => switch (this) {
    InvestorType.angel => 'Melek Yatırımcı',
    InvestorType.vc => 'Girişim Sermayesi (VC)',
    InvestorType.accelerator => 'Hızlandırıcı Program',
    InvestorType.corporate => 'Kurumsal Yatırımcı',
  };
}
```

### 2.7 ProgramType & ProgramScope
```dart
enum ProgramType {
  grant,
  equity,
  loan,
  acceleration,
  contest;

  String get label => switch (this) {
    ProgramType.grant => 'Hibe & Teşvik',
    ProgramType.equity => 'Yatırım / Sermaye',
    ProgramType.loan => 'Düşük Faizli Kredi',
    ProgramType.acceleration => 'Hızlandırıcı Program',
    ProgramType.contest => 'Yarışma & Ödül',
  };
}

enum ProgramScope {
  domestic,
  international;

  String get label => switch (this) {
    ProgramScope.domestic => 'Yurt İçi',
    ProgramScope.international => 'Yurt Dışı / AB',
  };
}
```

### 2.8 MatchStatus (Eşleşme Durumu)
```dart
enum MatchStatus {
  none,
  pending,
  accepted,
  rejected;

  String get label => switch (this) {
    MatchStatus.none => 'İstek Yok',
    MatchStatus.pending => 'Bekliyor',
    MatchStatus.accepted => 'Kabul Edildi',
    MatchStatus.rejected => 'Reddedildi',
  };
}
```

### 2.9 ConsultantField & SupportStatus & RoadmapCategory
```dart
enum ConsultantField {
  legal,
  accounting,
  tax,
  sgk,
  investment;

  String get label => switch (this) {
    ConsultantField.legal => 'Hukuk',
    ConsultantField.accounting => 'Mali Müşavirlik',
    ConsultantField.tax => 'Vergi Mevzuatı',
    ConsultantField.sgk => 'SGK & İstihdam',
    ConsultantField.investment => 'Yatırım & Finansman',
  };
}

enum SupportStatus {
  pending,
  approved,
  rejected;

  String get label => switch (this) {
    SupportStatus.pending => 'İncelemede',
    SupportStatus.approved => 'Onaylandı',
    SupportStatus.rejected => 'Reddedildi',
  };
}

enum RoadmapCategory {
  legal,
  tax,
  sgk,
  accounting;

  String get label => switch (this) {
    RoadmapCategory.legal => 'Hukuki Süreçler',
    RoadmapCategory.tax => 'Vergi İşlemleri',
    RoadmapCategory.sgk => 'SGK & İstihdam',
    RoadmapCategory.accounting => 'Mali Müşavir & Muhasebe',
  };
}
```

---

## 3. Freezed Modelleri

### 3.1 AppUser & BusinessProfile
```dart
@freezed
abstract class AppUser with _$AppUser {
  const factory AppUser({
    required String id,
    required String name,
    required UserRole role,
    required String email,
    required String city,
    String? bio,
    String? avatarAsset,
    @Default(VerificationStatus.notStarted) VerificationStatus verificationStatus,
    @Default(false) bool hasBusinessPlan,
    BusinessProfile? businessProfile,
    String? rejectionReason,
  }) = _AppUser;

  factory AppUser.fromJson(Map<String, dynamic> json) => _$AppUserFromJson(json);
}

@freezed
abstract class BusinessProfile with _$BusinessProfile {
  const factory BusinessProfile({
    required String startupName,
    required Sector sector,
    required StartupStage stage,
    @Default(1) int teamSize,
    String? businessPlanFileName,
    @Default([]) List<NeedType> needs,
  }) = _BusinessProfile;

  factory BusinessProfile.fromJson(Map<String, dynamic> json) => _$BusinessProfileFromJson(json);
}
```

### 3.2 ContactInfo
```dart
@freezed
abstract class ContactInfo with _$ContactInfo {
  const factory ContactInfo({
    required String email,
    String? phone,
    String? linkedinUrl,
  }) = _ContactInfo;

  factory ContactInfo.fromJson(Map<String, dynamic> json) => _$ContactInfoFromJson(json);
}
```

### 3.3 DirectoryProfile (Mentör & Yatırımcı Sealed Sınıfı)
```dart
@Freezed(unionKey: 'kind', unionValueCase: FreezedUnionCase.snake)
abstract class DirectoryProfile with _$DirectoryProfile {
  const factory DirectoryProfile.mentor({
    @Default('mentor') String kind,
    required String id,
    required String name,
    required String bio,
    required String city,
    @Default(false) bool isVerified,
    required ContactInfo contact,
    required String title,
    @Default([]) List<Sector> expertise,
    @Default([]) List<NeedType> topics,
    @Default(0) int yearsOfExperience,
    String? avatarAsset,
  }) = Mentor;

  const factory DirectoryProfile.investor({
    @Default('investor') String kind,
    required String id,
    required String name,
    required String bio,
    required String city,
    @Default(false) bool isVerified,
    required ContactInfo contact,
    required String firm,
    required InvestorType investorType,
    required int ticketMin,
    required int ticketMax,
    @Default([]) List<Sector> sectors,
    @Default([]) List<StartupStage> stages,
    String? avatarAsset,
  }) = Investor;

  factory DirectoryProfile.fromJson(Map<String, dynamic> json) => _$DirectoryProfileFromJson(json);
}
```

### 3.4 Program
```dart
@freezed
abstract class Program with _$Program {
  const factory Program({
    required String id,
    required String title,
    required String provider,
    required ProgramType type,
    required ProgramScope scope,
    String? country,
    required int amountMax,
    required DateTime deadline,
    required String summary,
    @Default([]) List<String> eligibility,
    @Default([]) List<StartupStage> targetStages,
    @Default([]) List<Sector> sectors,
    @Default(false) bool requiresVerification,
    @Default([]) List<String> tags,
  }) = _Program;

  factory Program.fromJson(Map<String, dynamic> json) => _$ProgramFromJson(json);
}
```

### 3.5 Topluluk: Post, PostAuthor, Comment
```dart
@freezed
abstract class PostAuthor with _$PostAuthor {
  const factory PostAuthor({
    required String id,
    required String name,
    required UserRole role,
    @Default(false) bool isVerified,
    String? avatarAsset,
  }) = _PostAuthor;

  factory PostAuthor.fromJson(Map<String, dynamic> json) => _$PostAuthorFromJson(json);
}

@freezed
abstract class Post with _$Post {
  const factory Post({
    required String id,
    required PostAuthor author,
    required String content,
    @Default([]) List<String> tags,
    required DateTime createdAt,
    @Default(0) int likeCount,
    @Default(0) int commentCount,
  }) = _Post;

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);
}

@freezed
abstract class Comment with _$Comment {
  const factory Comment({
    required String id,
    required String postId,
    required PostAuthor author,
    required String content,
    required DateTime createdAt,
  }) = _Comment;

  factory Comment.fromJson(Map<String, dynamic> json) => _$CommentFromJson(json);
}
```

### 3.6 Eşleşme (MatchRequest)
```dart
@freezed
abstract class MatchRequest with _$MatchRequest {
  const factory MatchRequest({
    required String id,
    required String fromUserId,
    required String toUserId,
    required String targetKind, // 'mentor' veya 'investor'
    String? message,
    @Default(MatchStatus.pending) MatchStatus status,
    required DateTime createdAt,
  }) = _MatchRequest;

  factory MatchRequest.fromJson(Map<String, dynamic> json) => _$MatchRequestFromJson(json);
}
```

### 3.7 Destek & Danışmanlık & Yol Haritası
```dart
@freezed
abstract class Consultant with _$Consultant {
  const factory Consultant({
    required String id,
    required String name,
    required String title,
    required ConsultantField field,
    required String bio,
    String? avatarAsset,
    @Default([]) List<String> availableHours,
  }) = _Consultant;

  factory Consultant.fromJson(Map<String, dynamic> json) => _$ConsultantFromJson(json);
}

@freezed
abstract class ConsultationSession with _$ConsultationSession {
  const factory ConsultationSession({
    required String id,
    required String userId,
    required String consultantId,
    required ConsultantField field,
    required DateTime date,
    required String timeSlot,
    @Default('confirmed') String status,
  }) = _ConsultationSession;

  factory ConsultationSession.fromJson(Map<String, dynamic> json) => _$ConsultationSessionFromJson(json);
}

@freezed
abstract class SupportApplication with _$SupportApplication {
  const factory SupportApplication({
    required String id,
    required String userId,
    required int amount,
    required String purpose,
    @Default(SupportStatus.pending) SupportStatus status,
    required DateTime appliedAt,
  }) = _SupportApplication;

  factory SupportApplication.fromJson(Map<String, dynamic> json) => _$SupportApplicationFromJson(json);
}

@freezed
abstract class RoadmapStep with _$RoadmapStep {
  const factory RoadmapStep({
    required String id,
    required int order,
    required RoadmapCategory category,
    required String title,
    required String description,
    @Default(false) bool isCompleted,
  }) = _RoadmapStep;

  factory RoadmapStep.fromJson(Map<String, dynamic> json) => _$RoadmapStepFromJson(json);
}
```

---

## 4. Kod Üretimi (Code Generation)

Modeller yazıldıktan veya değiştirildikten sonra build runner çalıştırılır:

```bash
dart run build_runner build --delete-conflicting-outputs
```

---

## 5. Uyum Skoru Algoritması (Faz 2)

Mentör ve yatırımcılar ile girişimcinin profil uyumu aşağıdaki formülle hesaplanır:

```dart
int calculateCompatibilityScore({
  required BusinessProfile startup,
  required DirectoryProfile profile,
}) {
  int score = 0;

  if (profile is Mentor) {
    // 1. Sektör eşleşmesi: %40
    if (profile.expertise.contains(startup.sector)) {
      score += 40;
    }
    // 2. İhtiyaç / Konu eşleşmesi: %40
    final commonTopics = profile.topics.where((t) => startup.needs.contains(t)).length;
    if (startup.needs.isNotEmpty) {
      score += ((commonTopics / startup.needs.length) * 40).round();
    }
    // 3. Tecrübe bonusu: %20
    if (profile.yearsOfExperience >= 10) {
      score += 20;
    } else {
      score += (profile.yearsOfExperience * 2).clamp(0, 20);
    }
  } else if (profile is Investor) {
    // 1. Sektör eşleşmesi: %40
    if (profile.sectors.isEmpty || profile.sectors.contains(startup.sector)) {
      score += 40;
    }
    // 2. Aşama uyumu: %40
    if (profile.stages.isEmpty || profile.stages.contains(startup.stage)) {
      score += 40;
    }
    // 3. Yatırımcı tipi / aktiflik bonusu: %20
    score += profile.isVerified ? 20 : 10;
  }

  return score.clamp(0, 100);
}
```
