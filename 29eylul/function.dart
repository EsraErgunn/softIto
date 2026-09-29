typedef MetrikUyariKurali = bool Function(double deger);

void metrikDenetle({
  required String metrikAdi,
  required double mevcutDeger,
  required MetrikUyariKurali kural,
  required void Function(String mesaj) alertTetikleyci,
}){
  if(kural(mevcutDeger)){
    alertTetikleyci("Uyarı: $metrikAdi eşlik değerini aştı. Mevcut:$mevcutDeger");
  }else{
    print("$metrikAdi normal sınırlar içinde ($mevcutDeger)");
  }
}

void main() {
  // CPU %92.5: kural (80'den büyük mü?) true döner, uyarı tetiklenir
  metrikDenetle(
    metrikAdi: "CPU",
    mevcutDeger: 92.5,
    kural: (deger) => deger > 80,
    alertTetikleyci: (mesaj) => print(mesaj),
  );

  // RAM %45.0: kural false döner, "normal" mesajı yazdırılır
  metrikDenetle(
    metrikAdi: "RAM",
    mevcutDeger: 45.0,
    kural: (deger) => deger > 80,
    alertTetikleyci: (mesaj) => print(mesaj),
  );
}
