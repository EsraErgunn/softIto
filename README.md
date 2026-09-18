# softIto

softIto bünyesinde yürütülen çalışmaların günlük olarak takip edildiği ve kontrol edilebildiği repodur.

## Amaç

Bu repo, yapılan işlerin gün gün kayıt altına alınması ve ilgili kişiler tarafından incelenebilmesi amacıyla oluşturulmuştur.

## Klasör Düzeni

Repo tarih temelli klasörlerden oluşur. Her gün için o günün tarihini taşıyan bir klasör açılır (`17eylul`, `18eylul`) ve o gün işlenen konulara ait dosyalar doğrudan bu klasörün içine konur.

Düzen şu şekilde ilerler:

- **Ders klasörü:** `18eylul` gibi, o gün derste yapılan çalışmaları tutar
- **Ödev klasörü:** aynı günün ödevi ayrı tutuluyorsa tarihin sonuna `odev` eklenir (`17eylulodev`)
- **Öncesi:** tarih takibine geçilmeden önceki çalışmalar `17eyluloncesi` altında toplanmıştır; kendi içinde konu klasörlerine ayrılır

Dosyalar konu adıyla isimlendirilir (`guvenli_form.html`, `normalizasyon.md`), böylece klasöre bakıldığında o gün neyin çalışıldığı adlardan anlaşılır.

## Kullanım

1. İlgili güne ait yeni bir klasör oluşturulur (örn. `19eylul`)
2. O güne ait dosyalar klasörün içine eklenir
3. Değişiklikler commit edilip GitHub'a push edilir

HTML dosyaları herhangi bir kurulum gerektirmez; tarayıcıda doğrudan açılarak görüntülenebilir. VS Code kullanılıyorsa Live Server eklentisi ile de çalıştırılabilir.

## Notlar

- Her commit mesajı, hangi güne ait değişiklik yapıldığını açıkça belirtmelidir (örn. `feat: 18 eylul dersleri`)
- `.env`, `.env.local` ve `.vscode/` dosyaları `.gitignore` ile takip dışı bırakılmıştır
