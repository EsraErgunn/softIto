<h1 align="center">CSS Soruları</h1>

**Ad-Soyad:** Esra Ergün &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; **Tarih:** 23.09.2026

---

## 1) Flexbox ile CSS Grid arasındaki mimari fark nedir ve ne zaman hangisi seçilmelidir?

**Flexbox**, yalnızca tek bir eksende (yatay ya da dikey) yerleşim sağlar. İçeriğe göre şekillenir ve alanın nasıl dağıtılacağına odaklanır.

- Navigasyon menüleri, buton grupları veya yan yana / alt alta sıralanan küçük öğelerde kullanılır.
- Boyutu önceden bilinmeyen ve sığmadığı durumda alt satıra akması (`flex-wrap`) istenen dinamik içeriklerde tercih edilir.

**Grid**, hem satır hem de sütun eksenine odaklanır. Önce genel bir şablon tanımlanır, ardından elemanlar bu ızgaranın hücrelerine yerleştirilir.

- Header, sidebar, ana içerik ve footer alanlarının konumlandırıldığı ana sayfa şablonlarında kullanılır.
- E-ticaret ürün listeleri, fotoğraf galerileri veya hem satır hem sütun hizalaması gerektiren modern dashboard'larda tercih edilir.

---

## 2) CSS Grid'deki `fr` (fractional unit) birimi, geleneksel yüzde (`%`) birimine göre neden daha güvenlidir?

`fr` birimi, yüzde (`%`) birimine kıyasla özellikle **boşluk yönetimi** ve **esneklik** açısından çok daha güvenli ve hatasız sonuçlar verir.

- Yüzde (`%`) kullanırken `gap` tanımlandığında, tarayıcı toplam genişliği hesaplarken boşlukları hesaba katmaz.
- `fr` birimi ise önce boşlukları toplam alandan düşer, ardından kalan alanı oransal olarak dağıtır.
- `%` birimi ebeveynin toplam genişliğini baz alırken, `fr` birimi **kullanılabilir boş alanı (free space)** baz alır. Bu da elemanların konteyner dışına taşmasını engeller.

Kısacası `%` birimi toplam boyuta, `fr` birimi ise kalan alana odaklanır. Bu sayede `calc()` fonksiyonlarına veya karmaşık hesaplamalara gerek kalmadan duyarlı (responsive) tasarımlar yapılabilir.

---

## 3) Neden "Desktop-First" (`max-width`) yerine "Mobile-First" (`min-width`) mimarisi tercih edilir?

Günümüzde Mobile-First yaklaşımı standart hâline gelmiştir. Bunun arkasında birkaç mimari sebep vardır:

1. **Performans ve kaynak yönetimi:** Mobil cihazlar; masaüstü bilgisayarlara göre daha sınırlı işlemci gücüne, belleğe ve daha yavaş ağ bağlantılarına sahiptir. Mobile-First yaklaşımında tarayıcı en yalın ve hafif CSS kodunu önce işler. Desktop-First yaklaşımında ise mobil cihazlara gereksiz yere büyük masaüstü stilleri gönderilerek performans düşürülür.

2. **Doğal CSS kaskad akışı:** `min-width` sorguları küçük ekrandan büyüğe doğru sıralandığında kod mantığı daha temiz akar. Temel stiller mobil için baştan yazılır, ekran büyüdükçe yeni kurallar eklenir. `max-width` kullanımında ise büyük ekran stillerini yazıp bunları mobil için geri almak gerekir; bu da kod karmaşasına yol açar.

3. **İçerik odaklı tasarım (Progressive Enhancement):** Küçük bir ekranla tasarıma başlamak, geliştiriciyi en önemli içeriğin ne olduğuna odaklanmaya zorlar. Ekran genişledikçe ek özellikler kademeli olarak eklenir.

4. **Kullanıcı kitlesi:** Web trafiğinin büyük çoğunluğu mobil cihazlardan geldiği için, ana hedef kitlenin ilk deneyimi yaşadığı platforma göre tasarım yapmak hem iş hem de kullanıcı deneyimi açısından en mantıklı tercihtir.

---

## 4) CSS3'te `transition` ve `animation` yazarken neden `top`, `left`, `width` yerine `transform` ve `opacity` tercih edilmelidir?

Bu özelliklerin tercih edilmesinin temel sebebi **tarayıcı performansıdır**.

Tarayıcılar bir web sayfasını görselleştirirken üç aşamadan geçer:

| Aşama | Açıklama |
|---|---|
| **Layout** | Elemanların konum ve boyutlarının hesaplanması |
| **Paint** | Piksellerin çizilmesi |
| **Composite** | Katmanların birleştirilerek ekrana basılması |

- `top`, `left` veya `width` gibi özellikleri değiştirmek, tarayıcının sayfadaki diğer elemanların konumunu yeniden hesaplamasını ve ardından pikselleri yeniden çizmesini tetikler. Bu süreç işlemci (CPU) üzerinde büyük bir yük oluşturur; animasyonlarda takılmalara ve düşük kare hızına (*jank*) yol açar.
- `transform` (örneğin `translate` veya `scale`) ve `opacity` ise yalnızca **Composite** aşamasını etkiler ve bu işlemler doğrudan ekran kartı (GPU) tarafından yürütülür.

Tarayıcı sayfa yerleşimini yeniden hesaplamak zorunda kalmadığı için, bu özelliklerle yapılan animasyonlar son derece akıcı ve yüksek performanslı çalışır.

---

## 5) CSS Grid'de `auto-fit` ile `minmax()` birleşimi nasıl çalışır ve responsive tasarım açısından ne avantaj sağlar?

`auto-fit` ile `minmax()` birleşimi, **medya sorgularına ihtiyaç duymadan** tamamen otomatik ve akışkan ızgara yapıları oluşturmayı sağlar.

```css
grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
```

- **`minmax(250px, 1fr)`:** Her sütunun en az 250px genişliğe sahip olmasını, ekranda fazladan alan kalırsa bu alanı `1fr` oranında esneyerek paylaşmasını sağlar.
- **`auto-fit`:** Tarayıcıya, bu minimum boyuttaki sütunlardan satıra sığabildiği kadarını yerleştirmesini söyler.

Ekran daraldıkça sığmayan sütunlar otomatik olarak alt satıra geçer; ekran genişledikçe yeni sütunlar aynı satıra yerleşir.

**Avantajı:** Farklı ekran boyutları için (768px, 1024px, 1200px gibi) ayrı ayrı medya sorgusu yazma zorunluluğunu ortadan kaldırır, kod tekrarını önler ve kart tabanlı tasarımların (ürün listeleri, fotoğraf galerileri vb.) hatasız biçimde ölçeklenmesini sağlar.

---

## 6) `grid-template-areas` özelliğinin sağladığı en büyük kurumsal avantaj nedir?

En büyük kurumsal avantajı, kodun **okunabilirliğini** ve **sürdürülebilirliğini** radikal şekilde artırarak büyük ekiplerin ortak projelerde hızlı ve hatasız çalışabilmesine olanak tanımasıdır.

```css
grid-template-areas:
  "header  header"
  "sidebar content"
  "footer  footer";
```

- Satır/sütun indeksleri veya karmaşık sayısal değerler yerine, sayfa iskeletinin adeta bir haritası çizilir (`header`, `sidebar`, `content`, `footer` gibi anlamlı isimlerle).
- Projeye yeni katılan bir geliştirici, sayfa mimarisini saniyeler içinde kavrayabilir.
- Tasarım değişiklikleri (örneğin sidebar'ın sağdan sola alınması veya mobil/masaüstü yerleşim farkları) yalnızca şablondaki alan adlarının yeri değiştirilerek güvenle yapılabilir.

Bu da bakım maliyetlerini düşürür ve ekip içi iletişimi güçlendirir.

---

## 7) CSS'te `clamp()` fonksiyonunun 3 parametresi ne anlama gelir?

`clamp(minimum, preferred, maximum)` fonksiyonu, bir değerin (örneğin font boyutu veya genişlik) belirli sınırlar içinde dinamik olarak değişmesini sağlar.

```css
font-size: clamp(1rem, 2.5vw, 2rem);
```

- **Minimum (Alt Sınır):** Değerin düşebileceği en küçük boyuttur. Ekran ne kadar küçülürse küçülsün değer bu sınırın altına inmez.
- **Preferred (Tercih Edilen / Esnek Değer):** Ekran boyutuna göre değişen ideal değerdir; genellikle `vw` gibi viewport birimleri veya yüzde kullanılır.
- **Maximum (Üst Sınır):** Değerin çıkabileceği en büyük boyuttur. Ekran ne kadar büyürse büyüsün değer bu sınırı aşmaz.

---

## 8) Bir CSS animasyonunun sonsuza kadar kesintisiz çalışması için hangi CSS kuralı kullanılır?

Bunun için `animation-iteration-count` özelliğine `infinite` değeri verilir:

```css
animation-iteration-count: infinite;
```

---

## 9) Flutter'da CSS Grid'in ve Flexbox'ın doğrudan karşılığı olan widget'lar nelerdir?

| CSS | Flutter Karşılığı |
|---|---|
| **Flexbox** | `Row` (yatay eksen) ve `Column` (dikey eksen). Genel kapsayıcı olarak `Flex` widget'ı kullanılır. |
| **CSS Grid** | Çok sütunlu ve iki boyutlu yapılar için `GridView` (özellikle `GridView.count` veya `GridView.builder`), tablo yapıları için `Table` widget'ı kullanılır. |

---

## 10) React Native'de CSS Grid kullanılabilir mi? Kullanılamıyorsa çok sütunlu ızgara yapısı nasıl oluşturulabilir?

**Hayır.** React Native doğrudan CSS Grid'i desteklemez; çünkü arka planda yerleşim için **Yoga** adlı bir Flexbox motoru kullanır.

**Çok sütunlu ızgara oluşturma yöntemleri:**

1. **Flexbox ile:** `flexDirection: 'row'` ve `flexWrap: 'wrap'` özellikleriyle elemanlar sarılır; öğe genişlikleri yüzde veya `Dimensions` ile hesaplanmış değerlerle ayarlanır.
2. **FlatList ile:** `FlatList` bileşeninin `numColumns` özelliği kullanılarak çok sütunlu listeler (ızgaralar) oluşturulur.
3. **Üçüncü parti kütüphaneler:** Gelişmiş grid yapıları için `react-native-super-grid` gibi popüler topluluk kütüphanelerinden yararlanılabilir.
