// ---------- ÜRÜNLER (LSP) ----------
// kargoUcretiHesapla() tabandan kaldırıldı. Eski kodda bu metot
// Urun'de tanımlıydı ve DijitalUrun onu throw ederek eziyordu.
abstract class Urun {
  final String id;
  final String ad;
  final double fiyat;
  int stok;

  Urun(this.id, this.ad, this.fiyat, this.stok);
}

// Kargo ücreti hesaplayabilen ürünler bu arayüzü uygular.
abstract class Kargolanabilir {
  double kargoUcretiHesapla();
}

class FizikselUrun extends Urun implements Kargolanabilir {
  FizikselUrun(super.id, super.ad, super.fiyat, super.stok);

  @override
  double kargoUcretiHesapla() => 29.90;
}

// Kargolanabilir'i uygulamaz, bu yüzden kimse ona kargo sormaz.
class DijitalUrun extends Urun {
  DijitalUrun(super.id, super.ad, super.fiyat, super.stok);
}

// ---------- ÖDEME YÖNTEMLERİ (OCP) ----------
// Eski koddaki 4 dallı if/else zinciri yerine her yöntem kendi sınıfında.
abstract class OdemeYontemi {
  void tahsilEt(double tutar);
}

class KrediKartiOdemesi implements OdemeYontemi {
  @override
  void tahsilEt(double tutar) => print('$tutar TL Kredi kartindan POS ile cekildi.');
}

class HavaleOdemesi implements OdemeYontemi {
  @override
  void tahsilEt(double tutar) => print('$tutar TL Havale kontrol edildi.');
}

class KapidaOdeme implements OdemeYontemi {
  @override
  void tahsilEt(double tutar) =>
      print('$tutar TL Kapida odeme tahsil edilecek (Komisyon +15 TL).');
}

class CryptoOdemesi implements OdemeYontemi {
  @override
  void tahsilEt(double tutar) => print('$tutar TL USDT transferi onaylandi.');
}

// ---------- İNDİRİM KURALLARI (OCP) ----------
abstract class IndirimKurali {
  double uygula(double tutar);
}

class YuzdeIndirimi implements IndirimKurali {
  final double carpan;
  YuzdeIndirimi(this.carpan);

  @override
  double uygula(double tutar) => tutar * carpan;
}

class TutarIndirimi implements IndirimKurali {
  final double tutar;
  TutarIndirimi(this.tutar);

  @override
  double uygula(double toplam) => toplam - tutar;
}

class IndirimYok implements IndirimKurali {
  @override
  double uygula(double tutar) => tutar;
}

// ---------- SERVİS ARAYÜZLERİ (ISP) ----------
// Eski ISiparisIslemleri arayüzü 6 ilgisiz metodu tek çatıda topluyordu.
// Artık her sorumluluk kendi küçük arayüzünde.
abstract class SiparisDeposu {
  void kaydet(String orderId, double tutar);
}

abstract class Bildirimci {
  void gonder(String hedef, String mesaj);
}

abstract class FaturaServisi {
  void yazdir(String orderId);
}

abstract class KargoServisi {
  void gonder(String orderId, String adres);
}

// ---------- SOMUT SERVİSLER ----------
class SqliteSiparisDeposu implements SiparisDeposu {
  @override
  void kaydet(String orderId, double tutar) =>
      print("DB calistirildi: INSERT INTO siparisler VALUES ('$orderId', $tutar)");
}

class SmtpMailBildirimcisi implements Bildirimci {
  @override
  void gonder(String hedef, String mesaj) => print('SMTP Mail gonderildi: $hedef');
}

class NetgsmSmsBildirimcisi implements Bildirimci {
  @override
  void gonder(String hedef, String mesaj) => print('SMS iletildi: $hedef');
}

class PdfFaturaServisi implements FaturaServisi {
  @override
  void yazdir(String orderId) => print('Fatura PDF cikarildi: $orderId');
}

class MngKargoServisi implements KargoServisi {
  @override
  void gonder(String orderId, String adres) =>
      print('MNG Kargo takip fis basildi: $adres');
}

// ---------- SİPARİŞ YÖNETİCİSİ (SRP + DIP) ----------
// SRP: Bu sınıf sadece akışı yönetir; kaydetme, mail, SMS, fatura ve
//      kargo işlerini kendisi yapmaz, ilgili servise devreder.
// DIP: Bağımlılıkları içeride new'lemez, kurucudan arayüz olarak alır.
class SiparisYoneticisi {
  static const double kdvOrani = 0.20;

  final SiparisDeposu depo;
  final FaturaServisi faturaServisi;
  final KargoServisi kargoServisi;
  final Bildirimci mailBildirimcisi;
  final Bildirimci smsBildirimcisi;
  final Map<String, OdemeYontemi> odemeYontemleri;
  final Map<String, IndirimKurali> kuponlar;

  SiparisYoneticisi({
    required this.depo,
    required this.faturaServisi,
    required this.kargoServisi,
    required this.mailBildirimcisi,
    required this.smsBildirimcisi,
    required this.odemeYontemleri,
    required this.kuponlar,
  });

  void siparisTamamla({
    required String orderId,
    required List<Urun> sepet,
    required String odemeTipi,
    required String musteriAdi,
    required String email,
    required String tel,
    required String adres,
    required String kuponKodu,
  }) {
    double toplam = 0;

    for (final urun in sepet) {
      if (urun.stok <= 0) {
        print('Hata: ${urun.ad} tukenmis!');
        return;
      }
      toplam += urun.fiyat;
      if (urun is Kargolanabilir) {
        toplam += (urun as Kargolanabilir).kargoUcretiHesapla();
      }
      urun.stok--;
    }

    final indirim = kuponlar[kuponKodu] ?? IndirimYok();
    toplam = indirim.uygula(toplam);

    final kdv = toplam * kdvOrani;
    final sonTutar = toplam + kdv;

    final odeme = odemeYontemleri[odemeTipi];
    if (odeme == null) {
      print('Gecersiz odeme yontemi');
      return;
    }
    odeme.tahsilEt(sonTutar);

    depo.kaydet(orderId, sonTutar);
    faturaServisi.yazdir(orderId);
    mailBildirimcisi.gonder(
        email, 'Sayin $musteriAdi, siparisiniz alindi. Tutar: $sonTutar TL');
    smsBildirimcisi.gonder(tel, 'Siparisiniz onaylandi: $orderId');
    kargoServisi.gonder(orderId, adres);
  }
}

// ---------- MAIN ----------
void main() {
  final siparisci = SiparisYoneticisi(
    depo: SqliteSiparisDeposu(),
    faturaServisi: PdfFaturaServisi(),
    kargoServisi: MngKargoServisi(),
    mailBildirimcisi: SmtpMailBildirimcisi(),
    smsBildirimcisi: NetgsmSmsBildirimcisi(),
    odemeYontemleri: {
      'KREDI_KARTI': KrediKartiOdemesi(),
      'HAVALE': HavaleOdemesi(),
      'KAPIDA_ODEME': KapidaOdeme(),
      'CRYPTO': CryptoOdemesi(),
    },
    kuponlar: {
      'INDIRIM10': YuzdeIndirimi(0.90),
      'YAZ20': YuzdeIndirimi(0.80),
      'SEPETTE50': TutarIndirimi(50),
    },
  );

  final urun1 = FizikselUrun('1', 'Kablosuz Mouse', 450.0, 5);
  final urun2 = DijitalUrun('2', 'Flutter Kursu E-Kitap', 150.0, 100);

  final sepet = <Urun>[urun1, urun2];

  siparisci.siparisTamamla(
    orderId: 'SP-9921',
    sepet: sepet,
    odemeTipi: 'KREDI_KARTI',
    musteriAdi: 'Selahaddin',
    email: 'selahaddin@kodvance.com',
    tel: '05551112233',
    adres: 'Kadikoy / Istanbul',
    kuponKodu: 'INDIRIM10',
  );
}
