# Mock Veri Rehberi

> `data-models` skill'inin ek dosyasıdır. Mock JSON yazarken, mock repository oluştururken veya demo panelini geliştirirken oku.

## 1. Dosyalar

```
assets/mock/
├── demo_users.json        # Demo panelinde seçilebilen hazır kullanıcılar
├── mentors.json           # 12 mentör
├── investors.json         # 10 yatırımcı
├── programs.json          # 15 program (≈10 yurt içi, ≈5 yurt dışı)
├── posts.json             # 20 gönderi
├── comments.json          # 40 yorum
├── consultants.json       # 5 danışman (hukuk, muhasebe, vergi, SGK, yatırım)
└── roadmap.json           # Faz 2: hukuki & mali yol haritası adımları
```

`pubspec.yaml`:

```yaml
flutter:
  assets:
    - assets/mock/
    - assets/images/
    - assets/lottie/
```

## 2. İçerik kuralları

- **Kişiler hayalidir.** Gerçek kişi adı kullanma. Türkçe, çeşitli ve gerçekçi isimler ver (ör. "Selin Aydoğan", "Kerem Yalçın").
- **Programlarda** gerçek kurum adları (TÜBİTAK, KOSGEB, Horizon Europe…) kullanılabilir. **Tutarlar, tarihler ve koşullar örnek amaçlıdır.** Program detay sayfasının altında küçük bir not gösterilir: *"Demo veridir, güncel koşullar için kurumun sitesini kontrol edin."*
- **Sektör dağılımı dengeli olmalı:** her sektörden en az 1 mentör bulunsun. Filtreler boş sonuç vermesin, ama en az bir filtre kombinasyonu boş durumu göstersin.
- **Avatar:** internet gerekmez. `avatarAsset` alanı boş bırakılırsa `VerifiedAvatar` baş harfleri gösterir. Birkaç kayıt `assets/images/avatars/` altındaki görselleri kullanabilir.
- Mentör ve yatırımcıların yaklaşık %70'i `isVerified: true` olsun.
- Metinler kısa ve gerçekçi olsun: bio 1–2 cümle, gönderi 1–4 cümle.

## 3. Göreli tarihler

Sabit tarih yazılırsa demo birkaç hafta sonra eskir ("tüm programların süresi dolmuş" gibi). Bu yüzden JSON'da **göreli alanlar** kullanılır, repository bunları gerçek `DateTime`'a çevirir:

| JSON alanı | Dönüştüğü alan | Hesaplama |
|---|---|---|
| `deadlineInDays` | `deadline` | `today + n gün` (en az 1 program negatif olsun → süresi dolmuş; 2 program 1–6 arası → yaklaşıyor) |
| `createdMinutesAgo` | `createdAt` | `now - n dakika` |

```dart
Map<String, dynamic> resolveRelativeDates(Map<String, dynamic> json, DateTime now) {
  final copy = {...json};
  if (copy.remove('deadlineInDays') case final int days) {
    copy['deadline'] = DateTime(now.year, now.month, now.day + days).toIso8601String();
  }
  if (copy.remove('createdMinutesAgo') case final int mins) {
    copy['createdAt'] = now.subtract(Duration(minutes: mins)).toIso8601String();
  }
  return copy;
}
```

## 4. JSON örnekleri

### demo_users.json

```json
[
  {
    "id": "usr_001",
    "name": "Elif Karaca",
    "role": "entrepreneur",
    "email": "elif@ornek.com",
    "city": "İzmir",
    "bio": "Tarımda sulama verimliliği üzerine çalışıyorum.",
    "verificationStatus": "notStarted",
    "hasBusinessPlan": false,
    "businessProfile": {
      "startupName": "Damla Tarım",
      "sector": "agriculture",
      "stage": "idea",
      "teamSize": 2,
      "needs": ["legal", "tax"]
    }
  },
  {
    "id": "usr_002",
    "name": "Mert Özkan",
    "role": "entrepreneur",
    "email": "mert@ornek.com",
    "city": "İstanbul",
    "verificationStatus": "approved",
    "hasBusinessPlan": true,
    "businessProfile": {
      "startupName": "Faturix",
      "sector": "fintech",
      "stage": "earlyRevenue",
      "teamSize": 5,
      "businessPlanFileName": "faturix_is_plani.pdf",
      "needs": ["accounting", "investment"]
    }
  },
  {
    "id": "usr_003",
    "name": "Ayşe Demirtaş",
    "role": "mentor",
    "email": "ayse@ornek.com",
    "city": "Ankara",
    "verificationStatus": "approved"
  }
]
```

Üç persona sunumda tüm akışları gösterir: iş planı olmayan ve onaysız girişimci, iş planı olan ve onaylı girişimci, mentör.

### mentors.json

```json
[
  {
    "kind": "mentor",
    "id": "mnt_001",
    "name": "Selin Aydoğan",
    "bio": "15 yıllık fintech deneyimi, iki başarılı exit.",
    "city": "İstanbul",
    "isVerified": true,
    "contact": { "email": "selin@ornek.com", "linkedinUrl": "https://linkedin.com/in/ornek" },
    "title": "Fintech Danışmanı",
    "expertise": ["fintech", "saas"],
    "topics": ["investment", "legal"],
    "yearsOfExperience": 15
  }
]
```

### investors.json

```json
[
  {
    "kind": "investor",
    "id": "inv_001",
    "name": "Kerem Yalçın",
    "bio": "Erken aşama sağlık ve eğitim girişimlerine yatırım yapıyorum.",
    "city": "Ankara",
    "isVerified": true,
    "contact": { "email": "kerem@ornek.com", "phone": "+90 500 000 00 00" },
    "firm": "Anadolu Melek Ağı",
    "investorType": "angel",
    "ticketMin": 250000,
    "ticketMax": 1500000,
    "sectors": ["health", "education"],
    "stages": ["prototype", "earlyRevenue"]
  }
]
```

### programs.json

```json
[
  {
    "id": "prg_001",
    "title": "Bireysel Genç Girişim (BiGG)",
    "provider": "TÜBİTAK",
    "type": "grant",
    "scope": "domestic",
    "amountMax": 900000,
    "deadlineInDays": 21,
    "summary": "Teknoloji tabanlı fikirlerin iş planına ve şirkete dönüşmesine destek.",
    "eligibility": ["Fikir aşamasında olmak", "Henüz şirket kurmamış olmak"],
    "targetStages": ["idea", "prototype"],
    "sectors": [],
    "requiresVerification": false,
    "tags": ["teknoloji", "erken aşama"]
  },
  {
    "id": "prg_011",
    "title": "EIC Accelerator",
    "provider": "Avrupa Komisyonu",
    "type": "grant",
    "scope": "international",
    "country": "AB",
    "amountMax": 75000000,
    "deadlineInDays": 4,
    "summary": "Yüksek etkili yenilikçi şirketlere hibe ve öz sermaye desteği.",
    "eligibility": ["Kurulmuş şirket", "Ölçeklenebilir inovasyon"],
    "targetStages": ["earlyRevenue", "growth"],
    "sectors": [],
    "requiresVerification": true,
    "tags": ["avrupa", "ölçeklenme"]
  }
]
```

### posts.json

```json
[
  {
    "id": "pst_001",
    "author": { "id": "mnt_001", "name": "Selin Aydoğan", "role": "mentor", "isVerified": true },
    "content": "Şirket kurmadan önce mali müşavirinizle hangi soruları konuşmalısınız? Yorumlara yazın, derleyip paylaşacağım.",
    "tags": ["hukuk", "muhasebe"],
    "createdMinutesAgo": 45,
    "likeCount": 18,
    "commentCount": 4
  }
]
```

### roadmap.json (Faz 2)

```json
[
  { "id": "rdm_01", "order": 1, "category": "legal", "title": "Şirket türünü seç", "description": "Şahıs, limited ve anonim şirket farkları." },
  { "id": "rdm_02", "order": 2, "category": "tax", "title": "Vergi kaydını yaptır", "description": "Vergi dairesine kayıt ve vergi levhası." },
  { "id": "rdm_03", "order": 3, "category": "sgk", "title": "SGK işyeri tescili", "description": "Çalışan alacaksan işyeri tescil süreci." }
]
```

## 5. Mock repository şablonu

```dart
class MockDirectoryRepository implements DirectoryRepository {
  MockDirectoryRepository(this._ref);
  final Ref _ref;

  List<Mentor>? _mentors; // bellek önbelleği

  @override
  Future<List<Mentor>> getMentors() async {
    await _simulateNetwork();
    return _mentors ??= await _load('assets/mock/mentors.json')
        .then((list) => list.map((j) => DirectoryProfile.fromJson(j) as Mentor).toList());
  }

  Future<void> _simulateNetwork() async {
    final demo = _ref.read(demoSettingsProvider);
    await Future.delayed(demo.latency);
    if (demo.simulateErrors) {
      throw const AppException('Bağlantı kurulamadı. Lütfen tekrar deneyin.');
    }
  }

  Future<List<Map<String, dynamic>>> _load(String path) async {
    final raw = await rootBundle.loadString(path);
    final now = DateTime.now();
    return (jsonDecode(raw) as List)
        .cast<Map<String, dynamic>>()
        .map((j) => resolveRelativeDates(j, now))
        .toList();
  }
}
```

**Kurallar**
- JSON yalnızca bir kez okunur, sonra bellekteki liste kullanılır.
- Yazma işlemleri (yeni gönderi, eşleşme isteği) bellekteki listeye **yeni bir liste oluşturarak** uygulanır. Kalıcı olması gerekenler `shared_preferences`'a da yazılır.
- Kullanıcının oluşturduğu gönderiler, açılışta JSON'dakilerle birleştirilir ve `createdAt`'e göre yeniden eskiye sıralanır.
- Her public metot `_simulateNetwork()` ile başlar.

## 6. Demo paneli aksiyonları

Rota: `/demo`. Profil sayfasındaki "Demo Paneli" satırından, ya da uygulama sürümü yazısına 5 kez dokunarak açılır.

| Grup | Aksiyon |
|---|---|
| **Kullanıcı** | Hazır persona seç (`demo_users.json`) · Rolü değiştir |
| **Onay** | Durumu ayarla: Başvuru yok / İncelemede / Onaylı / Reddedildi (red gerekçesiyle birlikte) |
| **İş planı** | `hasBusinessPlan` aç/kapat → sekmeler anında değişir |
| **Eşleşme** | Bekleyen tüm istekleri kabul et · Rastgele birini reddet |
| **Ağ** | Gecikme: 0 / 600 / 2000 ms · Hata simülasyonu aç/kapat |
| **Veri** | Tüm kalıcı veriyi sıfırla (onay penceresiyle) |

Her aksiyondan sonra kısa bir `SnackBar` gösterilir: "Durum: Onaylı olarak ayarlandı".