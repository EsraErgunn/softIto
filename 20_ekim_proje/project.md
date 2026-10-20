# Girişim Destek Platformu — Proje Rehberi

> "Girişim Destek Platformu" bir çalışma adıdır.
> Bu dosya coding agent için ana rehberdir. **Her göreve başlamadan önce bu dosyayı ve görevle ilgili skill dosyasını oku.**

## 1. Amaç

Girişimciler hukuki ve mali süreçleri (şirket kuruluşu, vergi, SGK, mali müşavir ihtiyacı) takip etmekte zorlanıyor. Finansmana (hibe, yatırımcı, mentör) ulaşmak da ayrı bir zorluk. Bu uygulama:

- girişimciyi iş planı olup olmamasına göre farklı bir yoldan yönlendirir,
- uzman onayından geçen kullanıcıya **maddi destek** ve **ücretsiz danışmanlık** sunar,
- mentör ve yatırımcılarla **eşleşme** imkânı verir,
- hibe, TÜBİTAK ve KOSGEB gibi yurt içi/yurt dışı **programları** listeler,
- network kurmak için bir **topluluk** alanı sağlar.

## 2. Kapsam ve kısıtlar

| Konu | Karar |
|---|---|
| Platform | Flutter (Android + iOS), Material 3 |
| Backend | **YOK.** Tüm veri `assets/mock/*.json` dosyalarından okunur, oturum boyunca bellekte değiştirilir |
| Kalıcılık | Tema, oturum/kullanıcı durumu, beğeniler, kaydedilen programlar ve eşleşmeler `shared_preferences` ile saklanır |
| Sunucu olayları | Uzman onayı, eşleşme kabulü gibi olaylar **Demo Paneli** ile simüle edilir |
| Dil | Kod tanımlayıcıları İngilizce, arayüz metinleri Türkçe (ileride l10n ile İngilizce eklenebilir) |
| Renk paleti | ⏸️ **Karar bekliyor.** Geçici seed renk kullanılır (bkz. design-system skill) |

## 3. Temel kullanıcı akışı

1. **Rol seçimi + sahte giriş:** girişimci / mentör / yatırımcı
2. **Onboarding:** "İş planın var mı?" sorusu → sekme seti buna göre değişir
3. **Uzman onayı:** belge yükleme → *İncelemede* → *Onaylı* veya *Reddedildi*
4. **Onaylı kullanıcı:** maddi destek başvurusu + ücretsiz danışmanlık randevusu
5. **Ana sekmeler (alt bar):** Mentörler · Yatırımcılar · Programlar · Topluluk
6. **Profil (app bar'daki avatar):** panel, onay durumu, girişim bilgileri, destek, ayarlar

## 4. Teknoloji yığını

| Alan | Paket |
|---|---|
| State management | `flutter_riverpod` (Notifier / AsyncNotifier, **riverpod codegen kullanılmaz**) |
| Yönlendirme | `go_router` (StatefulShellRoute + redirect ile yetki kontrolü) |
| Modeller | `freezed`, `freezed_annotation`, `json_serializable`, `json_annotation`, `build_runner` |
| Kalıcılık | `shared_preferences` |
| Dosya seçme | `file_picker` (yalnızca dosya adı saklanır) |
| Animasyon | `flutter_animate`, `shimmer`, `lottie` |
| Biçimlendirme | `intl` (tarih, para) |
| Ekstra (Faz 2) | `flutter_card_swiper`, `add_2_calendar`, `flutter_localizations` |

Paketler `flutter pub add <paket>` ile en güncel stabil sürümleriyle eklenir. **Bu listede olmayan bir paketi eklemeden önce sor.**

## 5. Dosya haritası

```
project.md                              ← bu dosya
analysis_options.yaml
.claude/skills/
├── architecture/SKILL.md               ← mimari, Riverpod, repository, router kuralları
├── data-models/SKILL.md                ← veri yapıları, enum'lar, freezed modeller
├── data-models/mock-data.md            ← mock JSON formatları, demo verisi
├── design-system/SKILL.md              ← tasarım kuralları, boşluk, animasyon
├── design-system/components.md         ← ortak bileşenlerin tanımları
└── git-workflow/SKILL.md               ← commit / branch kuralları
docs/
├── features.md                         ← MVP + ekstra özellik checklist'i
└── screens.md                          ← ekran envanteri ve rotalar
```

## 6. Agent çalışma kuralları

1. Görevi `docs/features.md` içinden al, **sırayı bozma**. Bitirdiğin maddeyi `[x]` olarak işaretle.
2. Görevle ilgili skill'i oku: ekran ya da widget için `design-system`, model için `data-models`, provider, repository veya rota için `architecture`.
3. Ekranlar repository'ye **doğrudan erişmez**, her zaman provider üzerinden erişir.
4. Async veri gösteren her ekranda **loading (skeleton), empty ve error** durumları bulunur.
5. Sabit renk, sabit boşluk değeri ve sabit süre kullanma. `Theme`, `AppSpacing`, `AppRadius` ve `AppDurations` kullan.
6. Model değiştirdikten sonra: `dart run build_runner build --delete-conflicting-outputs`
7. Görev bitmeden önce `flutter analyze` **sıfır hata/uyarı** vermeli.
8. Commit kuralları için `git-workflow` skill'ine bak. Commit mesajları **İngilizce** yazılır.
9. Kapsam dışı bir iyileştirme fark edersen uygulama; `docs/features.md` sonundaki "Notlar" bölümüne yaz.

## 7. Geliştirme sırası (özet)

| Faz | İçerik |
|---|---|
| **Faz 0 — Altyapı** | Proje kurulumu, tema iskeleti, router, session provider, mock repository altyapısı, ortak bileşenler |
| **Faz 1 — MVP** | Rol seçimi → onboarding → onay akışı + demo paneli → mentörler/yatırımcılar → eşleşme → programlar → topluluk → profil, destek, danışmanlık |
| **Faz 2 — Ekstralar** | Hukuki & Mali Yol Haritası, uygunluk sihirbazı, uyum skoru, kaydırmalı eşleşme, program takibi… |
| **Faz 3 — Cilalama** | Animasyonlar, boş durum görselleri, erişilebilirlik, renk paletinin kesinleşmesi |

Detaylı liste: `docs/features.md`

## 8. Bitti tanımı (Definition of Done)

Bir madde ancak şu koşullar sağlandığında bitmiş sayılır:

- Açık ve koyu temada düzgün görünüyor
- 360dp genişlikte taşma yok
- Loading, empty ve error durumları var
- Demo panelinden ilgili durumlar (onaylı / onaysız, iş planı var / yok) değiştirildiğinde doğru davranıyor
- `flutter analyze` temiz
- `docs/features.md` güncellendi ve commit atıldı