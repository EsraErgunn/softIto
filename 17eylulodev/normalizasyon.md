# Öğrenci – Bölüm – Ders İlişkilerinin 3NF'e Göre Normalizasyonu

> Soru: Öğrenci, Bölüm ve Ders ilişkilerini 3NF kurallarına uygun olarak normalize edip DDL sorgularını yazın.

---

## Normalize Edilmemiş Tablo

Tüm veriler tek bir tabloda tutulduğunda:

```
OgrenciKayit(OgrenciNo, Ad, Soyad, Email, BolumKodu, BolumAdi, Fakulte,
             DersKodu, DersAdi, Kredi, DonemKodu, DonemAdi, Not)
```

**Örnek veri:**

| OgrenciNo | Ad | BolumKodu | BolumAdi | DersKodu | DersAdi | Kredi | Not |
|-----------|-------|-----------|------------------|----------|-------------|-------|-----|
| 2201 | Esra | BIL | Bilgisayar Müh. | MAT101 | Matematik I | 5 | 85 |
| 2201 | Esra | BIL | Bilgisayar Müh. | FIZ102 | Fizik I | 4 | 70 |
| 2305 | Can | BIL | Bilgisayar Müh. | MAT101 | Matematik I | 5 | 60 |

Bu tablonun birincil anahtarı `(OgrenciNo, DersKodu)` ikilisinden oluşan bileşik bir anahtardır. Bir öğrenci birden fazla ders aldığı ve bir dersi birden fazla öğrenci aldığı için hiçbir sütun tek başına satırı benzersiz biçimde tanımlayamaz.
not: 3nf e uyması için 1NF ve 2NF e uyuyor olması gerek. ilk önce o şartları sağlarız.

---

## DDL Sorguları (PostgreSQL)

```sql
CREATE TABLE Bolum (
    BolumId    SERIAL PRIMARY KEY,
    BolumKodu  VARCHAR(10)  NOT NULL UNIQUE,
    BolumAdi   VARCHAR(100) NOT NULL,
    Fakulte    VARCHAR(100) NOT NULL
);

CREATE TABLE Ogrenci (
    OgrenciId  SERIAL PRIMARY KEY,
    OgrenciNo  VARCHAR(15)  NOT NULL UNIQUE,
    Ad         VARCHAR(50)  NOT NULL,
    Soyad      VARCHAR(50)  NOT NULL,
    Email      VARCHAR(120) NOT NULL UNIQUE,
    KayitYili  SMALLINT     NOT NULL CHECK (KayitYili >= 1950),
    BolumId    INT          NOT NULL,
    CONSTRAINT FK_Ogrenci_Bolum FOREIGN KEY (BolumId)
        REFERENCES Bolum (BolumId)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

CREATE TABLE Ders (
    DersId    SERIAL PRIMARY KEY,
    DersKodu  VARCHAR(10)  NOT NULL UNIQUE,
    DersAdi   VARCHAR(100) NOT NULL,
    Kredi     SMALLINT     NOT NULL CHECK (Kredi BETWEEN 1 AND 10),
    BolumId   INT          NOT NULL,
    CONSTRAINT FK_Ders_Bolum FOREIGN KEY (BolumId)
        REFERENCES Bolum (BolumId)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

CREATE TABLE OgrenciDers (
    OgrenciId  INT          NOT NULL,
    DersId     INT          NOT NULL,
    DonemKodu  VARCHAR(10)  NOT NULL,              -- örn. '2025-GUZ'
    Puan       NUMERIC(5,2) CHECK (Puan BETWEEN 0 AND 100),
    CONSTRAINT PK_OgrenciDers PRIMARY KEY (OgrenciId, DersId, DonemKodu),
    CONSTRAINT FK_OD_Ogrenci FOREIGN KEY (OgrenciId)
        REFERENCES Ogrenci (OgrenciId) ON DELETE CASCADE,
    CONSTRAINT FK_OD_Ders FOREIGN KEY (DersId)
        REFERENCES Ders (DersId) ON DELETE RESTRICT
);

CREATE INDEX IX_Ogrenci_BolumId ON Ogrenci (BolumId);
CREATE INDEX IX_Ders_BolumId    ON Ders (BolumId);
CREATE INDEX IX_OD_DersId       ON OgrenciDers (DersId);
```