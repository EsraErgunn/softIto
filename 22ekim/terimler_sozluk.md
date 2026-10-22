Const
1) Ne işe yarar: İçine girilen değerleri derleme zamanında tek bir kere yazılarak değişmez olarak üretir.

2) Neden kullanılır: Bir widget const olarak tanımlanırsa setState olduğunda flutter bu widget'ı yeniden üretmez. CPU ve pil tasarrufu sağlar.

final
1) Ne işe yarar: Çalışma zamanında değeri bir kez atanan ve sonrasında referansı asla değiştirilmeyen değişkenler.
*- const ve finak farkı: Const derlenirken bilinmek zorunda(const pi,=,3.14) final ise çalışma anında belirlenebilir(final DateTime now = DateTime.now()). ---Model sınıflarında alanlar her zaman final olmalıdır.-----**

late
1) Ne işe yarar: Değişken tanımlandığı anda değil, ilk kullanıldığında veya initState anında başlatılacağı zaman kullanılır.

required
1) Ne işe yarar: İsimlendirilmiş parametrelerde o parametrenin(değişkenin) mutlaka verilmesi gerektiğini belirtir. Vermezsek hata verir.

@override
1) Ne işe yarar: Alt sınıfın, üst sınıftan devraldığı metodu ezdiğini belirtir.
2) Faydası: Eğer üst metod adını yanlış yazarsanız (örnek build yazarsanız) derleyici @override sayesinde bunu anında hata olarak yakalar.

Null-aware operatörleri (? ?? !)
?. - place?.title  -> Eğer place null ise hata vermez direk null olarak döner. Aksi halde place içindeki title değerini döner.
?? - if null : final id = state.userId ?? 10; -> Sol taraf null ise sağdaki (hardcıde olan değer) otomatik olarak atanır.
! (null / force) : final id = state.userId!; -> Bu kod derleyiciye "bana güven bu değer o anda kesinlikle null değil" der. Eğer null gelir ise uygulama anında çöker. (ÇOK DİKKATLİ KULLANILMALI)

Spread Operatörü (...) (hoca çok seviyor)
1) Ne işe yarar : Bir listenin elemanlarını tek tek çıkarıp bulunduğu üst listenin içine ekler. Column ve ListView içinde dinamik kart dizini kullanmak için en temiz yöntemdir.
...listeAdi.map((p) => _buildCard(p)). (ayrıntıılı sorularını çöz)

initState()
Ne zaman çalışır : Widget ağaca fiziksel olarak ilk başladığında yalnızca 1 kere çalışır.
Ne yapar: ScrollController başlatmaları ve ilk api istekleri burada kurulur.
Kural: İçinde doğrudan BuildContext ile Navigator çağrılmaz çünkü widget ağaca tam oturmamıştır. (ilk öğrenci zili çalar inir state sonrasında öğretmen zili çalar ve öğrencileri toplar gibi düşünülebilir)


didChangeDependencies()
Ne zaman çalışır: initState()'ten hemen sonra ve widget dinlendiği bir (örnek: Theme.of (context) ) değiştiğinde otamatik tetikler.
Ne yapar: BuildContext güvenli bir şekilde erişerek tema ve ya ekran boyutu bağımlılıkları ile ilgili ilk yüklemeler burada yapılır.

build(BUildContext context) 
Ne zaman çalışır: Sayfa ilk açıldığında , setState() çağrıldığında veya üst widget yeni bir inşa ağaç boyama geldiğinde saniyesinde defalarca çalışır.
Kural: build() metodu tamamen saf olmalıdır. Asla içinde setState() api isteği yada controller başlatma yapılmalıdır. Asla içinde setState() api isteği yada controller başlatma yapılmamalıdır. Sadece UI döndürmelidir.

dispose()
Ne zaman çalışır: Widget hafızadan atılmadan hemen önce son bir kez çalışır.
Ne yapılır: _controller.dispose() stream dinleyicilerin iptalleri burada yapılır. super.dispose() un mutlaka son satırda çalıştırılması gerekir.

setState() (Bu yapı çok önemli diğer dillerde de var.)
1) Arka planda ne yapar.State'in bağlı olduğu StatefulElement nesnesine "ben değiştim, build et" sinyali yollar.
2) Nerede kullanılır. Sayfa genelinde çizdirmez. Sadece onu dinleyem küçük ValueListenableBuilder'a sinyal gönderilir.

ValueNotifier<T>
1) Arka planda ne iş yapar. ChangeNotifier sınıfından türer. Belleğinde tek bir nesne referansı tutar(T _value)
2) Tetikleme Değer atandığında (set value(T value)), eğer yeni değer eski değere eşit değilse (_value! = newValue), kayıtlı olan fonksiyonu çağrılır. (addListener(() {}))

InheritedWidget (react da da angular da da bunda sıkıntı var.)
1) Ne yapar: widget ağacında alttaki childların, oradaki onlarca widgeti

Material 3 Tasarım Dili Renk algoritması ve temalar
onPrimary: Ana rengin üstüne yazılacak rengi(okunabilirlik açısından)
primaryContainer:Ana rengin yumuşak pastel arkaplan tonunun üstüne yazılacak yazı (okunabilirlik açısından)
surface: Sayfada arka plan tuvali
onsurface: Sayfa üstündeki ana metin rengi
outlineVariant: İnce sınır ve ayrım çizgilerinin rengi

ThemeMode.system
color:Colors.black.withOpacity(0.8) // 1 ile 255 arasında istiyor 0.8 gibi değerde derleme hatasında çökme alırsınız
color:Colors.black.withOpacity(186) //Bu olur. Kesinlikle 1 ila 255 sayıları arasında tam sayı olarak girilmelidir.
color:Colors.black.withValues(alpha: 186/255) // double sayı olarak girilmelidir. **Güncel ve doğru yöntemdir.**

Arayüz Düzen ve Liste Bileşenleri

Expended ve Flexible
Expanded: Kalan boş alanın TAMAMINI kaplamaya zorlar.
Flexible: Kalan boş alanı paylaştırır. (flex: 1 , flex: 2)
Flex: yanyana iki expended varas birine flex2 diğerine flex 1 verir. Bu sayede ekran boyutuna göre otomatik olarak ayarlar.

stack ve Positioned.
Ne yapar: Widget'ları z ekseninde üst üste bindirir.
Positioned: Yalnızca 1 stack içinde çalışır.
top:10 , right:10 vererek bir resmin sağ üst köşesine bildirim rozeti eklemenizi sağlar.

ListView.builder.
Klasik ListView(children:[...],) içindeki örnek vermek gerekirse 10.000 elemanın tamamını daha sayfa açılmadan belleğe yükler ve doğal olarak telefon donar.
Listview.builder ise geri dönüşümlü görünüm alanı mantığını kullanarak ekranda sadece o an eğer 5 kart görünecek ise sadece 5 kartı ram belleğe yükler. kullanıcı aşağıya kaydıkça yukarıda kalanlar bellekten düşürülüp altta kalanlar belleğe taze olarak yeni olarak üretilir.

shrinkWrap: true
Bir ListView bir dikey kaydırıcının (singleChildScrollView) içine konursa Vertical viewport hatası verir.
shrinkWrap true verilerek bu çözülrbilir ancak:Listview'un sonsuza kayma (sonusz scroll) özelliği kaybolur. 
**Sadece 3 5 elemanınız varsa bunu kullanmalısınız.**

Inkwell ve GestureDetector
GestureDetector: Tıklama ve çift tıklama sürükleme olaylarını yakalar ama GÖRSEL HİÇBİR TEPKİ VERMEZ.
Inkwell: Tıklandığı an parmağın altından dışa doğru yayılan bir su dalgası efekti verir.

ÖNEMLİ KURAL: Inkwell'in arkasında mutlaka bir material widget olmak zorundadır. Aksi taktirde su dalgası arkadaki tuvali görmediği için hiçbir şekilde görünmez.

Form Mimarisi

GlobalKey<FormState>

Widget içindeki Form düğümüne doğrudan dışardan erişilemiyor. Bu yüzden Wisgetin en üstüne koyduğumuz globalKey değişkeni sayesinde formun Validate (geçerli) durumunu ve içindeki değerleri (Değişkenleri) dışarıdan okuyoruz.

_formKey.currentState?.validate() çağrıldığında o formun altındaki tüm TextFormField validator bloklarını sırasıyla çalıştırır.

validator :(String ?  value)

fonksiyonda bir hata bulursa geriye String olarak hata metni gönderir.Bu metin otomatik olarak kırmızı renkte ve inputun altında belirir. Eğer veri geçerliyse null döner. Flutter için bu alanda hata yok demektir .null gelmesi.

Animasyon motoru

AnimatedContainer: Genişlik yükseklik padding border renk ve gölge oynatır.
AnimatedOpacity: Görünürlüğü 0.0 ila 1.0 arasında yumuşakça soldurur.
AnimatedScale: Widget merkezinden dışarıya doğru büyütüp küçültür.
AnimatedAlign: Widget kutunun içinde sağdan sola yukarıdan aşağıya karşı konumunu değiştirir.

Curves
İvmelenme Karakteri
Curves.linear: Sabit hız (robotik haraketler)
Curves.easeInOut: Yavaş başlar ortalarda hızlanır yavaşca durur.
Curves.bounceOut: Hedefe çarptığında top gibi 2 3 kez yaylanarak seker.
Curves.elasticInOut: Lastik gibi ileri geri titreyerek yerine oturur.


Gorouter

context.go('/profil'): Route yönlendirmesidir. Rota tablosunda hiyerarşiyi takip eder , sayfayı temizleyebilir.

context.push('/profil/5'): Stack yönlendirmesidir. Kullanıcı nereden gelirse gelsin mevcut sayfanın tepesine yeni bir katman ekler ve dönüş için bir geri ok butonu ekler. 

context.pop(): Sayfanın en üstteki yığınını kapatır.
state.pathParameters["id"]: Gorouter içinde tanımladığımız /:id yapılarına erişmek için kullanılır

/profil?user=berat
state.uri.queryParameters["user"] : Opsiyonel filtreleme yada arama zamanlarında kullanılır.

not: shellrouter da değişiklik deyince menüde değişiklik yapılıyor . sayfanın geri kalan yeri de gorouter olarak geçiyor.

**Not: Bu dosya, dersin formatına birebir uyan, pedagojik akışa ve hoca üslubuna sadık kalınarak hazırlanmış bir referanstır.**

Cihaz içi yerel depolama mimarileri
SharedPreferences: 
  Küçük kullanıcı ayarları
  Düşük güvenliklidir.
  Okuma yazma hızları: Okuma hızı orta / yazma hızı yavaş

FlutterSecureStorage: 
  Şifre Token vb. Saklama
  En yüksek güvence
  Okuma yazma hızları: Orta

Hive/Isar: 
  Yüksek performanslı nesne depolama
  Orta (isteğe bağlı şifreleme açabilir)
  Aşırı hızlı okuma yazma (En iyi performans)
  



