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
