# Özellik Listesi

> Agent görevleri buradan **sırayla** alır. Biten madde `[x]` olarak işaretlenir ve aynı commit'e dahil edilir.
> Her maddenin "bitti" sayılması için `project.md` → *Bitti tanımı* koşulları geçerlidir.

---

## Faz 0 — Altyapı

- [x] **0.1 Proje kurulumu:** Flutter projesi, paketler (`project.md` §4), `analysis_options.yaml`, klasör yapısı (`architecture` §2), assets tanımları
- [x] **0.2 Tema iskeleti:** `app_tokens.dart`, `app_colors.dart` (geçici seed + `StatusColors`), açık/koyu `ThemeData`, `themeModeProvider` (kalıcı)
- [x] **0.3 Kalıcılık:** `prefsProvider` (`main.dart` içinde `SharedPreferences` başlatılıp override edilir)
- [x] **0.4 Modeller:** Tüm enum'lar + MVP modelleri (`data-models` §2–3.7), `label` extension'ları, `build_runner`
- [x] **0.5 Mock altyapısı:** `demoSettingsProvider`, `AppException`, `resolveRelativeDates`, mock JSON dosyaları (`mock-data.md`)
- [x] **0.6 Session:** `SessionState`, `sessionProvider` (kalıcı), `isApprovedProvider`, `currentRoleProvider`
- [x] **0.7 Router:** `routerProvider`, `authGuard`, 4 dallı `StatefulShellRoute`, boş placeholder sayfalar
- [x] **0.8 Ortak bileşenler (temel):** `AsyncValueView`, `SkeletonList`, `EmptyState`, `ErrorState`, `SectionHeader`, `VerifiedAvatar`, `StatusBadge`

---

## Faz 1 — MVP (olmazsa olmazlar)

### 1.1 Giriş ve rol
- [ ] Karşılama ekranı (`/welcome`): uygulamanın 3 maddelik değer önerisi + "Başla"
- [ ] Rol seçimi (`/role`): Girişimci / Mentör / Yatırımcı kartları
- [ ] Sahte giriş (`/login`): e-posta + ad. Doğrulama sadece format kontrolüdür, `AppUser` oluşturulur
- **Kabul:** Uygulama yeniden açıldığında oturum korunuyor. Çıkış yapınca `/welcome`'a dönülüyor.

### 1.2 Onboarding (yalnızca girişimci)
- [ ] Adım 1: "İş planın var mı?" (Evet / Hayır kartları)
- [ ] Adım 2: Girişim bilgileri (ad, sektör, aşama, ekip büyüklüğü, ihtiyaçlar)
- [ ] Adım 3: İş planı varsa dosya seçimi (`file_picker`, sadece dosya adı) veya "Sonra yükle"
- [ ] `StartupTabs`: `startupTabsFor(hasBusinessPlan)`'a göre sekmeler
  - İş planı yok → **Girişimim**, **İş Planı Hazırla** (adım adım rehber: problem, çözüm, pazar, gelir modeli, ekip, finansal ihtiyaç)
  - İş planı var → **Girişimim**, **İş Planım** (dosya + özet), **Yatırımcıya Hazırlık** (pitch kontrol listesi)
- **Kabul:** Demo panelinden `hasBusinessPlan` değiştirildiğinde sekmeler anında değişiyor.

### 1.3 Uzman onay akışı
- [ ] Doğrulama ekranı (`/verification`): zorunlu belge listesi, belge yükleme ve silme
- [ ] Başvuruyu gönder → durum `pending`
- [ ] `VerificationTimeline` ile durum gösterimi (tüm durumlar, red gerekçesi dahil)
- [ ] Reddedildiyse "Tekrar başvur" akışı
- **Kabul:** Zorunlu belgeler eksikken "Gönder" butonu pasif ve eksikler listeleniyor.

### 1.4 Demo paneli
- [ ] `/demo` ekranı, `mock-data.md` §6'daki tüm aksiyonlar
- [ ] Profildeki "Demo Paneli" satırı + sürüm yazısına 5 kez dokunma ile açılma
- **Kabul:** Persona seçimiyle tüm akışlar 30 saniyede gösterilebiliyor.

### 1.5 Mentörler ve Yatırımcılar
- [x] `directory` feature'ı: `DirectoryRepository`, `PersonCard`, `DirectoryFilter`, `FilterBottomSheet`
- [x] Mentör listesi (`/mentors`): arama + sektör filtresi + "Sadece doğrulanmış"
- [x] Yatırımcı listesi (`/investors`): arama, filtreler, bilet aralığı, yatırım tezi ve portföy kartları
- [x] Detay sayfaları: Hero avatar, bio, uzmanlık/sektörler, `ContactCard`, sabit alt alanda `MatchButton` / talep formu
- **Kabul:** Filtre sonucu boşsa "Filtreleri temizle" butonlu boş durum gösteriliyor.

### 1.6 Eşleşme
- [ ] `MatchRepository` + `matchRequestsProvider` (`Map<String, MatchRequest>`, kalıcı)
- [ ] Mesajlı istek gönderme bottom sheet'i
- [ ] Eşleşme isteklerim ekranı (`/matches`): Bekleyen / Kabul edilen / Reddedilen sekmeleri
- [ ] İletişim bilgisi yalnızca `accepted` durumunda görünüyor
- **Kabul:** Demo panelinden "kabul et" denince detay sayfasındaki buton "İletişime Geç" oluyor ve iletişim bilgisi açılıyor.

### 1.7 Programlar
- [x] Program listesi (`/programs`): `ProgramCard`, `DeadlineProgress`, son başvuru rozetleri
- [x] Filtreler: tür (hızlandırıcı, hibe, ödül), kapsam (yurt içi/yurt dışı/hepsi), yer imi kaydetme
- [x] Sıralama: son başvuru tarihi en yakın olan önce
- [x] Program detayı: özet, koşullar checklist'i, hedef aşamalar, bütçe/tutar, "Başvur" butonu (`requiresVerification` kontrolü ile kilitli overlay)
- **Kabul:** Süresi dolmuş, yaklaşan ve normal programlar farklı görünüyor.

### 1.8 Topluluk
- [x] Akış (`/community`): `PostCard`, yeniden eskiye, aşağı çekerek yenileme, yüksek çözünürlüklü görseller
- [x] Beğeni & Repost: `likedPostIdsProvider` ve `repostedPostIdsProvider` (kalıcı, animasyonlu kalp patlaması, çift dokunma)
- [x] Gönderi oluşturma: `PostComposer` (FAB ile açılır, etiket ve görsel desteği)
- [x] Gönderi detayı + gerçekçi sektör yorumları (`comments.json`) + yeni yorum yazma akışı
- [x] Yazar profil yönlendirmeleri (`/mentors/:id`, `/investors/:id`)
- **Kabul:** Yeni gönderi akışın en üstünde görünüyor ve uygulama yeniden açıldığında duruyor.

### 1.9 Profil, destek ve danışmanlık
- [ ] Profil paneli (`/profile`): bento düzeni (`DashboardTile`)
- [ ] Profil düzenleme + `ProfileCompletionCard`
- [ ] Maddi destek (`/support/funding`): onaysızsa `LockedOverlay`. Onaylıysa başvuru formu (tutar, amaç) + başvurularım listesi
- [ ] Danışmanlık (`/support/consultation`): onaysızsa kilitli. Onaylıysa konu seçimi → danışman listesi → tarih/saat seçimi → randevu oluşturma + randevularım
- [ ] Ayarlar (`/settings`): `ThemeModeSelector`, çıkış yap
- **Kabul:** Demo panelinden "Onaylı" seçildiğinde kilit animasyonla açılıyor.

### 1.10 Son kontrol
- [ ] Tüm ekranlarda loading/empty/error durumları
- [ ] Tüm ekranlar açık ve koyu temada kontrol edildi
- [ ] 360 dp ve metin ölçeği 1.3 kontrolü
- [ ] README: ekran görüntüleri, kurulum, mimari özeti
- [ ] `v0.1.0` etiketi

---

## Faz 2 — Ekstralar (etkisi yüksekten düşüğe)

- [ ] **2.1 Hukuki & Mali Yol Haritası:** `roadmap.json` adımları, kategoriye göre gruplama (hukuk/vergi/SGK/muhasebe), tamamla işareti (kalıcı), toplam ilerleme çubuğu, her adımda "Mali müşavire sor" → danışmanlık akışına o konuyla gider (onaysızsa kilitli). Girişimim sekmesinden ve profil panelinden erişilir. **Projenin çıkış problemine doğrudan cevap verdiği için öncelikli.**
- [ ] **2.2 "Hangi programa uygunum?" sihirbazı:** 5–6 soru (aşama, sektör, şirket kurulmuş mu, yurt dışı ilgisi, tutar ihtiyacı) → uygun programlar uygunluk sırasıyla listelenir
- [ ] **2.3 Uyum skoru:** `compatibilityScore` (`data-models` §5), `PersonCard` üzerinde gösterim, "Uyuma göre sırala" seçeneği
- [ ] **2.4 Kaydırmalı eşleşme:** Mentörler ekranında liste/kart görünümü geçişi. Kart görünümünde `flutter_card_swiper`: sağ → eşleşme isteği, sol → geç
- [ ] **2.5 Program takibi:** kaydet (`savedProgramIdsProvider`), "Kaydettiklerim" filtresi, geri sayım, "Takvime ekle" (`add_2_calendar`)
- [ ] **2.6 Profil tamamlama yönlendirmesi:** onaya başvurmadan önce eksiklerin gösterilmesi, %100 olunca kutlama animasyonu
- [ ] **2.7 Bildirim merkezi:** app bar ikonu + okunmamış sayısı. Eşleşme kabulü, son başvuruya 3 gün kalması ve onay sonucu için bildirimler (demo panelinden tetiklenir)
- [ ] **2.8 Sahte mesajlaşma:** kabul edilen eşleşmeler için sohbet ekranı, otomatik "karşı taraf yazıyor…" ve hazır yanıt
- [ ] **2.9 Rozetler:** Onaylı Girişimci, İlk Eşleşme, Topluluk Katkıcısı (5 gönderi), Yol Haritası Ustası. Profilde rozet rafı
- [ ] **2.10 Türkçe/İngilizce:** `flutter_localizations` + ARB dosyaları, ayarlardan dil seçimi

---

## Faz 3 — Cilalama

- [ ] Boş durumlar için Lottie animasyonları
- [ ] Liste animasyonlarının ve Hero geçişlerinin tüm ekranlarda tutarlılık kontrolü
- [ ] Kilit açılma animasyonu ve onay sonrası kutlama
- [ ] Erişilebilirlik turu (semantics, kontrast, tooltip)
- [ ] ⏸️ Renk paleti ve font kararı → `app_colors.dart` güncellemesi, tüm ekranların yeniden kontrolü
- [ ] Uygulama ikonu ve splash ekranı
- [ ] README güncellemesi + demo GIF'i, `v1.0.0` etiketi

---

## Notlar

> Agent'ın fark ettiği ama kapsam dışı kalan iyileştirmeler buraya eklenir.