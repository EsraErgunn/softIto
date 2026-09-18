# softIto

softIto bünyesinde yürütülen çalışmaların günlük olarak takip edildiği ve kontrol edilebildiği repodur.

## Amaç

Bu repo, yapılan işlerin gün gün kayıt altına alınması ve ilgili kişiler tarafından incelenebilmesi amacıyla oluşturulmuştur.

## Klasör Yapısı

Her gün için tarih adını taşıyan bir klasör açılır ve o güne ait dosyalar ilgili klasörün içine eklenir:

```
softIto/
├── 17eyluloncesi/          # 17 Eylül öncesi çalışmalar
│   ├── 1. Gün/
│   │   └── Esra Ergün (Ödev).pdf
│   ├── ODEV/
│   │   ├── ODEV.MD         # KahveGo: akış şeması, REST API, SOLID, Git
│   │   └── image.png
│   ├── SOLID/
│   │   └── solid.dart      # SOLID prensipleri örnekleri (Dart)
│   └── profile.html
├── 17eylul/
│   ├── index.html          # softito
│   └── index1.html         # kodvance-mobil Teknoloji Bülteni
├── 17eylulodev/
│   ├── mobil_tanitim.html  # Mobil tanıtım sayfası
│   └── normalizasyon.md    # Öğrenci–Bölüm–Ders ilişkilerinin 3NF normalizasyonu
├── 18eylul/
│   ├── klavye_degiskenler.html  # Mobil sanal klavye: inputmode, autocapitalize, enterkeyhint
│   ├── guvenli_form.html        # Regex pattern ile form doğrulama + honeypot
│   └── mobil_odeme.html         # Paytr 3D Secure mobil ödeme sayfası
├── .gitignore
└── README.md
```

## İçerik Özeti

| Klasör | Konu |
|--------|------|
| `17eyluloncesi` | Mobil akış şeması, REST API tasarımı, SOLID & Clean Code, Git/GitHub |
| `17eylul` | Temel HTML sayfa yapısı, bülten sayfası |
| `17eylulodev` | Mobil tanıtım sayfası, veritabanı normalizasyonu (1NF → 3NF, PostgreSQL DDL) |
| `18eylul` | Mobil form teknikleri: klavye türleri, regex doğrulama, 3D Secure ödeme akışı |

## Kullanım

1. İlgili güne ait yeni bir klasör oluşturulur (örn. `19eylul`)
2. O güne ait dosyalar klasörün içine eklenir
3. Değişiklikler commit edilip GitHub'a push edilir

HTML dosyaları herhangi bir kurulum gerektirmez; tarayıcıda doğrudan açılarak görüntülenebilir. VS Code kullanılıyorsa Live Server eklentisi ile de çalıştırılabilir.

## Notlar

- Klasör isimlendirmesi `18eylul` gibi tarih temellidir; günün çalışmaları o klasörde toplanır
- Her commit mesajı, hangi güne ait değişiklik yapıldığını açıkça belirtmelidir (örn. `feat: 18 eylul dersleri`)
- `.env`, `.env.local` ve `.vscode/` dosyaları `.gitignore` ile takip dışı bırakılmıştır
