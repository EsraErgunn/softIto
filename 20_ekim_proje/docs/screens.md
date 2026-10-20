# Ekran Envanteri

> Rotalar, erişim kuralları ve her ekranın kullandığı provider'lar. Yeni bir ekran eklendiğinde bu dosya da güncellenir.
> Erişim kontrolü `architecture` skill §6'daki `authGuard` ile yapılır.

## 1. Navigasyon haritası

```
/welcome ─► /role ─► /login ─► (girişimciyse) /onboarding
                                     │
                                     ▼
        ┌──────────── Alt bar (StatefulShellRoute) ────────────┐
        │ /mentors   /investors   /programs   /community        │
        └───────────────────────────────────────────────────────┘
              │            │            │             │
     /mentors/:id  /investors/:id  /programs/:id  /community/post/:id
                                                   /community/new

App bar avatarı ─► /profile (bento panel)
                     ├─ /profile/edit
                     ├─ /profile/startup          (StartupTabs)
                     ├─ /verification
                     ├─ /matches
                     ├─ /support/funding          (onay gerekli → kilitli)
                     ├─ /support/consultation     (onay gerekli → kilitli)
                     ├─ /settings
                     └─ /demo
```

## 2. Erişim kısaltmaları

| Kısaltma | Anlamı |
|---|---|
| **Herkes** | Giriş yapmamış kullanıcı dahil |
| **Giriş** | Giriş yapmış her rol |
| **Girişimci** | `role == entrepreneur` |
| **Onaylı** | `verificationStatus == approved`. Sayfa açılır ama onaysızsa `LockedOverlay` gösterilir |
| **Demo** | `kDemoPanelEnabled == true` |

## 3. MVP ekranları

| Rota | Ekran | Erişim | Provider'lar | Notlar |
|---|---|---|---|---|
| `/welcome` | WelcomePage | Herkes | — | 3 değer önerisi kartı, "Başla" |
| `/role` | RoleSelectPage | Herkes | — | 3 rol kartı, seçili kart vurgulu |
| `/login` | LoginPage | Herkes | `sessionProvider` | Ad + e-posta, format doğrulama |
| `/onboarding` | OnboardingPage | Girişimci, onboarding tamamlanmamış | `sessionProvider` | 3 adımlı `PageView` + adım göstergesi, geri gidilebilir |
| `/mentors` | MentorsPage | Giriş | `filteredMentorsProvider`, `mentorFilterProvider`, `matchRequestsProvider` | Arama çubuğu, filtre ikonu + aktif filtre rozeti, `PersonCard` listesi |
| `/mentors/:id` | MentorDetailPage | Giriş | `directoryProfileProvider(id)`, `matchRequestsProvider` | Hero avatar, `ContactCard`, alt alanda `MatchButton` |
| `/investors` | InvestorsPage | Giriş | `filteredInvestorsProvider`, `investorFilterProvider` | Mentör sayfasıyla aynı yapı, ek filtreler |
| `/investors/:id` | InvestorDetailPage | Giriş | `directoryProfileProvider(id)` | Bilet aralığı, hedef aşamalar |
| `/programs` | ProgramsPage | Giriş | `filteredProgramsProvider`, `programFilterProvider`, `savedProgramIdsProvider` | Son tarihe göre sıralı, tür chip'leri |
| `/programs/:id` | ProgramDetailPage | Giriş | `programProvider(id)`, `isApprovedProvider` | Koşullar listesi, "Başvur" (onay gerekiyorsa kilitli), demo veri notu |
| `/community` | CommunityPage | Giriş | `postsProvider`, `likedPostIdsProvider` | Aşağı çekerek yenileme, FAB → yeni gönderi |
| `/community/new` | PostComposerPage | Giriş | `postsProvider` | Tam ekran, karakter sayacı, etiket seçimi |
| `/community/post/:id` | PostDetailPage | Giriş | `postProvider(id)`, `commentsProvider(id)` | Yorum listesi + altta sabit yorum alanı |
| `/people/:id` | PersonProfilePage | Giriş | `authorProfileProvider(id)` | Mentör/yatırımcıysa dizin detayına yönlendirir, girişimciyse basit profil + gönderileri |
| `/profile` | ProfileDashboardPage | Giriş | `sessionProvider`, `profileCompletionProvider`, `matchRequestsProvider`, `savedProgramIdsProvider` | Bento panel, altta ayarlar ve demo satırları |
| `/profile/edit` | ProfileEditPage | Giriş | `sessionProvider` | Avatar, bio, şehir, girişim bilgileri |
| `/profile/startup` | StartupPage | Girişimci | `sessionProvider` | `StartupTabs`: sekmeler `hasBusinessPlan`'a göre |
| `/verification` | VerificationPage | Girişimci | `verificationProvider`, `sessionProvider` | Belge listesi + `VerificationTimeline` |
| `/matches` | MatchesPage | Giriş | `matchRequestsProvider` | 3 sekme: Bekleyen / Kabul edilen / Reddedilen |
| `/support/funding` | FundingSupportPage | Onaylı | `supportApplicationsProvider`, `isApprovedProvider` | `LockedOverlay`. Form + başvurularım |
| `/support/consultation` | ConsultationPage | Onaylı | `consultantsProvider`, `sessionsProvider`, `isApprovedProvider` | `LockedOverlay`. Konu → danışman → tarih → onay |
| `/settings` | SettingsPage | Giriş | `themeModeProvider`, `sessionProvider` | Tema seçimi, sürüm (5 dokunuş → demo), çıkış |
| `/demo` | DemoPanelPage | Demo | `sessionProvider`, `demoSettingsProvider`, `matchRequestsProvider` | `mock-data.md` §6 |

## 4. Faz 2 ekranları

| Rota | Ekran | Erişim | Notlar |
|---|---|---|---|
| `/roadmap` | RoadmapPage | Girişimci | Kategori grupları, ilerleme çubuğu, "Mali müşavire sor" |
| `/eligibility` | EligibilityWizardPage | Girişimci | Soru başına bir sayfa, sonunda uygun programlar |
| `/notifications` | NotificationsPage | Giriş | Okundu/okunmadı, tıklayınca `route`'a gider |
| `/matches/:id/chat` | ChatPage | Giriş, eşleşme `accepted` | Sahte mesajlaşma |
| `/badges` | BadgesPage | Giriş | Kazanılan ve kilitli rozetler |

## 5. Ekran durumları kontrol tablosu

Her ekran tamamlandığında doldurulur:

| Ekran | Loading | Empty | Error | Dark | 360dp |
|---|:-:|:-:|:-:|:-:|:-:|
| MentorsPage | ☐ | ☐ | ☐ | ☐ | ☐ |
| InvestorsPage | ☐ | ☐ | ☐ | ☐ | ☐ |
| ProgramsPage | ☐ | ☐ | ☐ | ☐ | ☐ |
| CommunityPage | ☐ | ☐ | ☐ | ☐ | ☐ |
| PostDetailPage | ☐ | ☐ | ☐ | ☐ | ☐ |
| ProfileDashboardPage | ☐ | — | ☐ | ☐ | ☐ |
| VerificationPage | ☐ | — | ☐ | ☐ | ☐ |
| MatchesPage | ☐ | ☐ | ☐ | ☐ | ☐ |
| FundingSupportPage | ☐ | ☐ | ☐ | ☐ | ☐ |
| ConsultationPage | ☐ | ☐ | ☐ | ☐ | ☐ |

## 6. Boş durum metinleri

| Ekran | Başlık | Açıklama | Buton |
|---|---|---|---|
| Mentörler (filtreli) | Sonuç bulunamadı | Filtrelerini değiştirerek tekrar dene. | Filtreleri temizle |
| Programlar (kayıtlı) | Henüz program kaydetmedin | Takip etmek istediğin programları kaydet, son tarihleri kaçırma. | Programlara göz at |
| Topluluk | İlk paylaşımı sen yap | Sorularını ve deneyimlerini paylaş, ağını büyüt. | Gönderi oluştur |
| Eşleşmeler | Henüz eşleşme isteğin yok | Sana uygun mentör ve yatırımcıları keşfet. | Mentörleri keşfet |
| Destek başvuruları | Başvurun bulunmuyor | Maddi destek için ilk başvurunu oluştur. | Başvuru yap |