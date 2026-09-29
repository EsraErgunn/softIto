enum OlaySeviyesi {info,warning,error,critical}

String alarmKanalinBelirle(OlaySeviyesi seviye, int tekrarSayisi){
  return switch(seviye){
OlaySeviyesi.info => "dev-logs",
OlaySeviyesi.warning =>"dev-warning",
OlaySeviyesi.error when tekrarSayisi >=5 => "Sms veya Email (mükerrer hata)",
OlaySeviyesi.error => "Email:dev@site.com",
OlaySeviyesi.critical => "ACİL DURUM: Kriz odası otomatik node kapanışı"
  };
}

String httpKoduYorumlar(int kod){
  return switch(kod){
    >=200 && <300 => "2xx Başarılı istek",
    >=400 && <500 => "3xx istemci Hatası (client error)",
    >=500 && <600 => "5xx Başarılı istek (internal server error)", 
    _ => "Tanımsız Hata kodu",
  };
}

void main() {
  print("Switch Exporessions");
  print("Warning Kanalı              :${alarmKanalinBelirle(OlaySeviyesi.warning, 1)}");
  print("Tekil Error Kanalı          :${alarmKanalinBelirle(OlaySeviyesi.error, 2)}");
  print("5 kez Tekrarlanan Error Kanalı   :${alarmKanalinBelirle(OlaySeviyesi.error, 5)}");
  print("Kritik  Kanalı              :${alarmKanalinBelirle(OlaySeviyesi.critical, 1)}");

  print("HTTP 204 :   ${httpKoduYorumlar(204)}");
  print("HTTP 404 :   ${httpKoduYorumlar(404)}");
  print("HTTP 502 :   ${httpKoduYorumlar(502)}");
}

