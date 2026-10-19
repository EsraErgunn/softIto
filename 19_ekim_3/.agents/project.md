# Fitness Su Takip Uygulaması
Bu döküman Flutter projesinde geliştirme yapacak olan Ajan (antigravity) yapay zeka ve yazılım geliştiriciler için bağlayıcı bir klavuzdur. Projede üretilen her kod satırı burdaki kurallara UYMAK ZORUNDADIR.


## 1. Proje Özeti ve Teknolojiler
-**Uygulama adı:** Susadım (akıllı su egzersiz ve kalori takibi uygulaması)
-**Hedef Platform:** Ios ve android öncelikli ardından web ve masaüstü platformları.
-**Flutter SDK:** 3.29.0
-**Dart SDK:** 3.0.0
-**Tasarım dili:** Material 3, Sistem Karanlık ve Aydınlık Mod Desteği (Koyu Tema: gece spor salonu paleti, dark obsidian & neon; Aydınlık Tema: açık enerji ve ferah spor paleti; sistem ayarına duyarlı ve kullanıcı tarafından değiştirilebilir Light/Dark/System modu);
-**Tema Mimarisi:** ValueNotifier tabanlı ThemeController ile reaktif tema değişimi; renkler ve stiller AppColors ve AppTheme üzerinden yönetilecektir.
-**Yeni Özellik:**Burada bir haftalık takip sistemi eklenecek su egzersiz ve kalori takibi yap ona göre rozetlerle ödül verilecek belli bir puana ulaştığında kullanıcıya bir hayvan hediye edilecek .
---

## Mimari Yapı: Özellik bazlı
kodlar kesinlikle tek bir yerde toplanmayacaktır. Her modül kendi feature klasöründe kodlanacaktır.

```text
lib/
core/
extension'lar
        constans/app_colors.dart
        theme/app_theme.dart

  features/
        water_traker/
            controller/
            models/
            view/
            widget/
        workout/
            controller/
            models/
            view/
            widget/
        achivement/
            controller/
            models/
            view/
            widget/

    main.dart
```

#### sadece uygulama başlatma ve tema bölümleri    


## 3 Kırmızı çizgiler kod kalite standartları
1 - **State Yönetim Standartları:**
Sayfa düzeyinde ağır `setState` KULLANILMAYACAKTIR.
Sadece yerel arayüz durumunu yöneten (örneğin buton animasyonları vb.) StatefulWidget kabul edilir.

2 - **UI ve Performans Kuralları:**
Statik tüm widget'larda `const` zorunludur.
Renk ve metin stilleri kesinlikle tema dosyalarına yazılacaktır.
Büyük build metodları yasaktır; 40 satırı geçen build metodları özel widgetlara yazılacaktır.

3- **Yasaklı Paketler:**
Projeye onay olmadan harici ağır state paketleri EKLENMEYECEKTİR.
Dart'ın ve Flutter'ın yerel çekirdek apilerini kullanmak esastır.

## 4 Geliştirme analiz ve test komutları
Ajan yaptığı herhangi bir kod değişikliğinden sonra mutlaka alttaki komutların çalıştığını doğrulamalıdır.

* **Statik kod analizi (0 uyarı ve 0 hata şart):**
```bash 
flutter analyze
```
* **Birim ve widget testleri:**
```bash
flutter test
```
* **Projeyi çalıştırma:**
```bash
flutter run
```


## 5 Ajanın çıktı ve yanıt verme standartları
**Açıklamalar:** Türkçe teknik terimlerin özünü bozmadan net ve doğrudan olacaktır.
**Değişiklik Sunumları:** Örnek 500 satırlık bir dosyada 3 satır değiştiyse tüm dosyayı baştan sona basma; hedef satırları ve diff yapısını göster.
**Dosya Yolları:** Bahsedilen ve üretilen her dosya için mutlaka projeye göre tıklanabilir link ver. 
**Doğrulama:** Kod yazdıktan sonra kullanıcıya "Şimdi flutter analyze ile kontrol edebilirsin" şeklinde doğrulama yönergeleri ver.

