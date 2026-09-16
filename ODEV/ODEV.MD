# SOLID Prensipleri ve Clean Code

## SOLID İhlallerinin Tespiti ve Clean Code Refactoring Ödevi

**Ad Soyad:** Esra Ergün
**Tarih:** 15.09.2026

---

# GÖREV 1: Mobil Akış Şeması (Flowchart) veya Sözde Kod

## A- Akış Şeması

![Görev 1 Flowchart](image.png)

## B- Sözde Kod

```text
BAŞLA

    Uygulamayı aç

    oturum ← Oturum durumunu kontrol et

    EĞER oturum geçerli DEĞİL İSE
        OKU kullanıcıAdı, şifre
        Giriş yap
    EĞER SONU

    YAZ menü

    sepet ← boş

    DÖNGÜ
        OKU seçilenÜrün, adet
        sepet'e seçilenÜrün ekle

        OKU başkaÜrünVarMı

        EĞER başkaÜrünVarMı = "Hayır" İSE
            Döngüden çık
        EĞER SONU

    DÖNGÜ SONU

    siparişTamam ← YANLIŞ

    DÖNGÜ (siparişTamam = YANLIŞ olduğu sürece)

        OKU onay
        // "Siparişi onayla" butonu

        paket ← { kullanıcıId, sepet, toplamTutar }

        DÖNGÜ
            yanıt ← Sunucuya gönder(paket)
            // arka planda

            EĞER yanıt başarılı İSE
                Döngüden çık
            DEĞİLSE
                YAZ "Bağlantı hatası, tekrar deneniyor"
            EĞER SONU

        DÖNGÜ SONU

        EĞER bakiye ≥ toplamTutar İSE
            // sunucu tarafında kontrol

            bakiye ← bakiye − toplamTutar

            Siparişi kaydet

            siparişTamam ← DOĞRU

        DEĞİLSE
            YAZ "Yetersiz bakiye"
            Bakiye yükleme ekranını göster

        EĞER SONU

    DÖNGÜ SONU

    YAZ "Siparişiniz alındı", siparişNo

BİTİR
```

---

# GÖREV 2: REST API Uç Noktası (Endpoint) & JSON

## 1. Sipariş Oluşturma Endpoint'i

**HTTP Metodu:** `POST`

**URL:** `/api/v1/siparisler`

### Header'lar

```http
POST /api/v1/siparisler HTTP/1.1
Host: api.kahvezinciri.com
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
Content-Type: application/json
Accept: application/json
```

### Örnek Request Body

```json
{
  "sube_id": 12,
  "urunler": [
    {
      "urun_id": 101,
      "kahve_adi": "Caffe Latte",
      "boyut": "Grande",
      "adet": 2,
      "birim_fiyat": 95.00
    },
    {
      "urun_id": 205,
      "kahve_adi": "Americano",
      "boyut": "Tall",
      "adet": 1,
      "birim_fiyat": 75.00
    }
  ],
  "toplam_tutar": 265.00,
  "para_birimi": "TRY"
}
```

### Başarılı Sonuç

**`201 Created`**

Yeni bir kaynak oluşturulduğu için `200 OK` yerine `201 Created` döner. `Location` header'ı oluşturulan siparişin adresini gösterebilir.

### Kullanıcı Giriş Yapmamışsa

**`401 Unauthorized`**

Token eksik, geçersiz veya süresi dolmuşsa bu kod döner.

---

## 2. Cüzdan Bakiye Sorgulama Endpoint'i

**HTTP Metodu:** `GET`

**URL:** `/api/v1/kullanici/bakiye`

GET isteğinin body'si yoktur. Kullanıcı token'dan tanındığı için URL'de kullanıcı ID'si gönderilmez.

### Request

```http
GET /api/v1/kullanici/bakiye HTTP/1.1
Host: api.kahvezinciri.com
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
Accept: application/json
```

### Örnek Response

**`200 OK`**

```json
{
  "bakiye": 185.50,
  "para_birimi": "TRY",
  "son_guncelleme": "2026-09-16T09:42:10Z"
}
```

### Sunucuda Beklenmeyen Hata

**`500 Internal Server Error`**

Güvenlik nedeniyle hata gövdesinde stack trace veya veritabanı detayları verilmez. Bunun yerine takip amacıyla bir referans kodu döndürülebilir.

### Mini Mülakat Sorusu

GET isteği idempotenttir, çünkü aynı bakiye sorgusu kaç kez gönderilirse gönderilsin sunucudaki durum değişmez.

POST ise genel olarak idempotent değildir. Aynı sipariş oluşturma isteğinin birden fazla kez gönderilmesi birden fazla sipariş oluşturabilir ve buna bağlı olarak işlemler tekrar gerçekleşebilir.

---

# GÖREV 3: Clean Code & SOLID Prensip Teşhisi

## 1. Single Responsibility Principle (SRP)

Sınıf birden fazla sorumluluğu aynı anda yapıyor: sepet hesaplama, ödeme yapma, veritabanına kaydetme ve SMS ile bildirim gönderme.

Bu yüzden bu sorumlulukları ayrı sınıflara bölmeliyiz. Örneğin **Sipariş Servisi, Ödeme Servisi, Veritabanı Servisi ve Bildirim Servisi** oluşturulabilir.

## 2. Open/Closed Principle (OCP)

Yeni bir müşteri tipi geldiğinde `if-else` kodunu değiştirmek zorunda kalıyoruz. Bu durum **OCP (Open/Closed Principle)** prensibine aykırıdır.

OCP'ye göre sınıf **değişikliğe kapalı, genişletmeye açık** olmalıdır.

---

# GÖREV 4: Git, Branching & GitHub Release Pratiği

#