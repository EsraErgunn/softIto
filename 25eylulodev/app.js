// Ürün verileri
const urunler = [ // Mağazadaki tüm ürünleri tutan dizi (her ürün bir nesne)
  { id: 1, ad: "Kablosuz Kulaklık", kategori: "Elektronik", fiyat: 899.9, puan: 4.5, gorsel: "🎧" }, // 1. ürün: kulaklık
  { id: 2, ad: "Akıllı Saat", kategori: "Elektronik", fiyat: 1999, puan: 4.2, gorsel: "⌚" }, // 2. ürün: akıllı saat
  { id: 3, ad: "Bluetooth Hoparlör", kategori: "Elektronik", fiyat: 649.5, puan: 4.0, gorsel: "🔊" }, // 3. ürün: hoparlör
  { id: 4, ad: "Spor Ayakkabı", kategori: "Giyim", fiyat: 1249, puan: 4.7, gorsel: "👟" }, // 4. ürün: ayakkabı
  { id: 5, ad: "Kot Ceket", kategori: "Giyim", fiyat: 749.9, puan: 4.1, gorsel: "🧥" }, // 5. ürün: ceket
  { id: 6, ad: "Pamuklu Tişört", kategori: "Giyim", fiyat: 199.9, puan: 4.3, gorsel: "👕" }, // 6. ürün: tişört
  { id: 7, ad: "Seramik Kupa", kategori: "Ev & Yaşam", fiyat: 89.9, puan: 4.6, gorsel: "☕" }, // 7. ürün: kupa
  { id: 8, ad: "Masa Lambası", kategori: "Ev & Yaşam", fiyat: 349, puan: 4.4, gorsel: "💡" }, // 8. ürün: lamba
  { id: 9, ad: "Saksı Bitkisi", kategori: "Ev & Yaşam", fiyat: 159.5, puan: 4.8, gorsel: "🪴" }, // 9. ürün: bitki
  { id: 10, ad: "Roman Seti", kategori: "Kitap", fiyat: 279, puan: 4.9, gorsel: "📚" }, // 10. ürün: roman seti
  { id: 11, ad: "Defter", kategori: "Kitap", fiyat: 59.9, puan: 4.2, gorsel: "📓" }, // 11. ürün: defter
  { id: 12, ad: "Sırt Çantası", kategori: "Aksesuar", fiyat: 549, puan: 4.5, gorsel: "🎒" }, // 12. ürün: çanta
]; // Ürün dizisinin sonu

const KARGO_UCRETI = 49.9; // Standart kargo ücreti (TL)
const UCRETSIZ_KARGO_LIMITI = 500; // Bu tutar ve üzerinde kargo ücretsiz

// Uygulama durumu
let sepet = JSON.parse(localStorage.getItem("sepet")) || []; // Kayıtlı sepeti tarayıcıdan okur, yoksa boş dizi
let seciliKategori = "Tümü"; // Şu an seçili olan kategori
let aramaMetni = ""; // Arama kutusuna yazılan metin
let siralama = "default"; // Seçili sıralama türü

// DOM elemanları
const urunlerEl = document.getElementById("products"); // Ürün kartlarının ekleneceği alan
const kategorilerEl = document.getElementById("categories"); // Kategori butonlarının alanı
const aramaEl = document.getElementById("search"); // Arama kutusu
const siralamaEl = document.getElementById("sort"); // Sıralama seçim kutusu
const bosSonucEl = document.getElementById("emptyResult"); // "Ürün bulunamadı" mesajı
const sepetEl = document.getElementById("cart"); // Sepet paneli
const overlayEl = document.getElementById("overlay"); // Arka plan karartma katmanı
const sepetListeEl = document.getElementById("cartItems"); // Sepetteki ürünlerin listesi
const sepetBosEl = document.getElementById("cartEmpty"); // "Sepetiniz boş" mesajı
const sepetSayiEl = document.getElementById("cartCount"); // Sepet adedi rozeti
const araToplamEl = document.getElementById("subtotal"); // Ara toplam yazısı
const kargoEl = document.getElementById("shipping"); // Kargo ücreti yazısı
const toplamEl = document.getElementById("total"); // Genel toplam yazısı
const odemeBtn = document.getElementById("checkout"); // "Siparişi Tamamla" butonu
const toastEl = document.getElementById("toast"); // Bildirim kutusu

const paraFormatla = (tutar) => // Sayıyı Türk lirası biçimine çeviren fonksiyon
  tutar.toLocaleString("tr-TR", { style: "currency", currency: "TRY" }); // Örn: 1999 -> "₺1.999,00"

const yildizlar = (puan) => // Puanı yıldız dizisine çeviren fonksiyon
  "★".repeat(Math.round(puan)) + "☆".repeat(5 - Math.round(puan)); // Dolu yıldızlar + boş yıldızlar (toplam 5)

// Kategoriler
function kategorileriGoster() { // Kategori butonlarını ekrana çizen fonksiyon
  const kategoriler = ["Tümü", ...new Set(urunler.map((u) => u.kategori))]; // Ürünlerden benzersiz kategori listesi çıkarır
  kategorilerEl.innerHTML = kategoriler // Kategori listesinden HTML üretip alana yazar
    .map( // Her kategori için bir buton oluşturur
      (k) => // k: kategori adı
        `<button class="chip ${k === seciliKategori ? "chip--active" : ""}" data-kategori="${k}">${k}</button>` // Seçili olana aktif sınıfı ekler
    ) // map sonu
    .join(""); // Butonları tek bir metinde birleştirir
} // kategorileriGoster fonksiyonunun sonu

// Ürünler
function filtrelenmisUrunler() { // Filtre, arama ve sıralamaya göre ürün listesini döndürür
  let liste = urunler.filter((u) => { // Ürünleri tek tek kontrol ederek filtreler
    const kategoriUygun = seciliKategori === "Tümü" || u.kategori === seciliKategori; // Kategori eşleşiyor mu?
    const aramaUygun = u.ad.toLocaleLowerCase("tr").includes(aramaMetni); // Ürün adı arama metnini içeriyor mu?
    return kategoriUygun && aramaUygun; // İkisi de uygunsa ürün listede kalır
  }); // filter sonu

  if (siralama === "price-asc") liste.sort((a, b) => a.fiyat - b.fiyat); // Fiyata göre artan sıralama
  if (siralama === "price-desc") liste.sort((a, b) => b.fiyat - a.fiyat); // Fiyata göre azalan sıralama
  if (siralama === "name") liste.sort((a, b) => a.ad.localeCompare(b.ad, "tr")); // Türkçe alfabeye göre isim sıralaması

  return liste; // Hazırlanan listeyi döndürür
} // filtrelenmisUrunler fonksiyonunun sonu

function urunleriGoster() { // Ürün kartlarını ekrana çizen fonksiyon
  const liste = filtrelenmisUrunler(); // Filtrelenmiş ürünleri alır
  bosSonucEl.hidden = liste.length > 0; // Ürün varsa "bulunamadı" mesajını gizler

  urunlerEl.innerHTML = liste // Ürün listesinden HTML üretip alana yazar
    .map( // Her ürün için bir kart oluşturur
      (u) => ` <!-- Ürün kartı şablonu başlangıcı -->
      <article class="product"> <!-- Ürün kartı -->
        <div class="product__image">${u.gorsel}</div> <!-- Ürün emojisi -->
        <div class="product__body"> <!-- Kartın yazı kısmı -->
          <span class="product__category">${u.kategori}</span> <!-- Kategori adı -->
          <h3 class="product__name">${u.ad}</h3> <!-- Ürün adı -->
          <span class="product__rating">${yildizlar(u.puan)} <small>(${u.puan})</small></span> <!-- Yıldızlar ve puan -->
          <div class="product__footer"> <!-- Fiyat ve buton alanı -->
            <span class="product__price">${paraFormatla(u.fiyat)}</span> <!-- Biçimlendirilmiş fiyat -->
            <button class="btn btn--primary" data-id="${u.id}">Sepete Ekle</button> <!-- data-id ile hangi ürün olduğu bilinir -->
          </div> <!-- product__footer sonu -->
        </div> <!-- product__body sonu -->
      </article>` // Ürün kartı şablonunun sonu
    ) // map sonu
    .join(""); // Kartları tek bir metinde birleştirir
} // urunleriGoster fonksiyonunun sonu

// Sepet işlemleri
function sepetiKaydet() { // Sepeti tarayıcı hafızasına kaydeden fonksiyon
  localStorage.setItem("sepet", JSON.stringify(sepet)); // Diziyi metne çevirip "sepet" anahtarıyla saklar
} // sepetiKaydet fonksiyonunun sonu

function sepeteEkle(id) { // Verilen id'deki ürünü sepete ekler
  const kalem = sepet.find((k) => k.id === id); // Ürün sepette zaten var mı diye bakar
  if (kalem) { // Ürün sepette varsa
    kalem.adet++; // Sadece adedini 1 artırır
  } else { // Ürün sepette yoksa
    sepet.push({ id, adet: 1 }); // Yeni kalem olarak 1 adet ekler
  } // if-else sonu
  const urun = urunler.find((u) => u.id === id); // Bildirimde adını göstermek için ürünü bulur
  bildirimGoster(`${urun.ad} sepete eklendi ✓`); // Kullanıcıya bildirim gösterir
  sepetiGuncelle(); // Sepet görünümünü ve toplamları yeniler
  sepetSayiEl.classList.add("bump"); // Rozete büyüme animasyonunu başlatır
} // sepeteEkle fonksiyonunun sonu

function adetDegistir(id, degisim) { // Sepetteki ürünün adedini artırır ya da azaltır
  const kalem = sepet.find((k) => k.id === id); // İlgili sepet kalemini bulur
  if (!kalem) return; // Bulunamazsa hiçbir şey yapmaz
  kalem.adet += degisim; // Adede +1 veya -1 ekler
  if (kalem.adet <= 0) { // Adet sıfıra düştüyse
    sepettenCikar(id); // Ürünü sepetten tamamen çıkarır
    return; // Fonksiyondan çıkar (güncelleme sepettenCikar içinde yapılır)
  } // if sonu
  sepetiGuncelle(); // Sepet görünümünü yeniler
} // adetDegistir fonksiyonunun sonu

function sepettenCikar(id) { // Ürünü sepetten tamamen siler
  sepet = sepet.filter((k) => k.id !== id); // Bu id dışındaki kalemleri tutar
  sepetiGuncelle(); // Sepet görünümünü yeniler
} // sepettenCikar fonksiyonunun sonu

function sepetiGuncelle() { // Sepet panelini, rozeti ve toplamları yeniden çizer
  sepetiKaydet(); // Önce güncel sepeti kaydeder

  const kalemler = sepet.map((k) => ({ ...urunler.find((u) => u.id === k.id), adet: k.adet })); // Sepet kalemlerini ürün bilgileriyle birleştirir
  const toplamAdet = kalemler.reduce((t, k) => t + k.adet, 0); // Sepetteki toplam ürün adedi
  const araToplam = kalemler.reduce((t, k) => t + k.fiyat * k.adet, 0); // Fiyat x adet toplamı
  const kargo = araToplam === 0 || araToplam >= UCRETSIZ_KARGO_LIMITI ? 0 : KARGO_UCRETI; // Sepet boşsa veya limit aşıldıysa kargo 0

  sepetSayiEl.textContent = toplamAdet; // Rozetteki sayıyı günceller
  sepetBosEl.hidden = kalemler.length > 0; // Sepette ürün varsa "boş" mesajını gizler
  odemeBtn.disabled = kalemler.length === 0; // Sepet boşsa sipariş butonunu pasif yapar

  sepetListeEl.innerHTML = kalemler // Sepet kalemlerinden HTML üretip listeye yazar
    .map( // Her kalem için bir liste satırı oluşturur
      (k) => ` <!-- Sepet satırı şablonu başlangıcı -->
      <li class="cart-item"> <!-- Sepetteki bir ürün satırı -->
        <span class="cart-item__image">${k.gorsel}</span> <!-- Ürün emojisi -->
        <div class="cart-item__info"> <!-- Ad ve tutar alanı -->
          <p class="cart-item__name">${k.ad}</p> <!-- Ürün adı -->
          <p class="cart-item__price">${paraFormatla(k.fiyat * k.adet)}</p> <!-- Bu kalemin toplam tutarı -->
        </div> <!-- cart-item__info sonu -->
        <div class="qty"> <!-- Adet kontrol alanı -->
          <button data-action="azalt" data-id="${k.id}">−</button> <!-- Adedi azaltma butonu -->
          <span>${k.adet}</span> <!-- Mevcut adet -->
          <button data-action="arttir" data-id="${k.id}">+</button> <!-- Adedi artırma butonu -->
        </div> <!-- qty sonu -->
        <button class="cart-item__remove" data-action="sil" data-id="${k.id}" aria-label="Ürünü kaldır">🗑</button> <!-- Ürünü silme butonu -->
      </li>` // Sepet satırı şablonunun sonu
    ) // map sonu
    .join(""); // Satırları tek bir metinde birleştirir

  araToplamEl.textContent = paraFormatla(araToplam); // Ara toplamı ekrana yazar
  kargoEl.textContent = kargo === 0 ? "Ücretsiz" : paraFormatla(kargo); // Kargo 0 ise "Ücretsiz" yazar
  toplamEl.textContent = paraFormatla(araToplam + kargo); // Genel toplamı ekrana yazar
} // sepetiGuncelle fonksiyonunun sonu

// Sepet paneli
function sepetiAc() { // Sepet panelini açan fonksiyon
  sepetEl.classList.add("cart--open"); // Paneli ekrana kaydırır
  overlayEl.classList.add("overlay--show"); // Arka planı karartır
} // sepetiAc fonksiyonunun sonu

function sepetiKapat() { // Sepet panelini kapatan fonksiyon
  sepetEl.classList.remove("cart--open"); // Paneli ekran dışına kaydırır
  overlayEl.classList.remove("overlay--show"); // Karartmayı kaldırır
} // sepetiKapat fonksiyonunun sonu

// Bildirim
let bildirimZamanlayici; // Bildirimi gizleyecek zamanlayıcının kimliği
function bildirimGoster(mesaj) { // Ekranın altında kısa bir mesaj gösterir
  toastEl.textContent = mesaj; // Mesaj metnini kutuya yazar
  toastEl.classList.add("toast--show"); // Kutuyu görünür yapar
  clearTimeout(bildirimZamanlayici); // Önceki zamanlayıcı varsa iptal eder
  bildirimZamanlayici = setTimeout(() => toastEl.classList.remove("toast--show"), 2000); // 2 saniye sonra kutuyu gizler
} // bildirimGoster fonksiyonunun sonu

// Olay dinleyicileri
sepetSayiEl.addEventListener("animationend", () => { // Rozet animasyonu bittiğinde
  sepetSayiEl.classList.remove("bump"); // Sınıfı kaldırır ki sonraki eklemede tekrar oynasın
}); // animationend dinleyicisinin sonu

kategorilerEl.addEventListener("click", (e) => { // Kategori alanına tıklanınca
  const kategori = e.target.dataset.kategori; // Tıklanan butonun kategori bilgisini alır
  if (!kategori) return; // Buton dışına tıklandıysa çıkar
  seciliKategori = kategori; // Seçili kategoriyi günceller
  kategorileriGoster(); // Aktif butonu göstermek için kategorileri yeniden çizer
  urunleriGoster(); // Ürünleri yeni kategoriye göre çizer
}); // kategori dinleyicisinin sonu

aramaEl.addEventListener("input", (e) => { // Arama kutusuna her harf yazıldığında
  aramaMetni = e.target.value.trim().toLocaleLowerCase("tr"); // Metni boşluksuz ve küçük harfe çevirip saklar
  urunleriGoster(); // Ürünleri aramaya göre yeniden çizer
}); // arama dinleyicisinin sonu

siralamaEl.addEventListener("change", (e) => { // Sıralama seçimi değiştiğinde
  siralama = e.target.value; // Yeni sıralama türünü saklar
  urunleriGoster(); // Ürünleri yeni sıraya göre çizer
}); // sıralama dinleyicisinin sonu

urunlerEl.addEventListener("click", (e) => { // Ürün alanına tıklanınca (olay delegasyonu)
  const id = Number(e.target.dataset.id); // Tıklanan butonun ürün id'sini sayıya çevirir
  if (id) sepeteEkle(id); // Geçerli bir id varsa ürünü sepete ekler
}); // ürün dinleyicisinin sonu

sepetListeEl.addEventListener("click", (e) => { // Sepet listesine tıklanınca
  const { action, id } = e.target.dataset; // Butonun işlem türünü ve ürün id'sini alır
  if (!action) return; // İşlem butonu değilse çıkar
  if (action === "arttir") adetDegistir(Number(id), 1); // "+" butonu: adedi 1 artırır
  if (action === "azalt") adetDegistir(Number(id), -1); // "−" butonu: adedi 1 azaltır
  if (action === "sil") sepettenCikar(Number(id)); // Çöp kutusu: ürünü siler
}); // sepet listesi dinleyicisinin sonu

document.getElementById("cartBtn").addEventListener("click", sepetiAc); // Sepet butonuna tıklanınca paneli açar
document.getElementById("closeCart").addEventListener("click", sepetiKapat); // ✕ butonuna tıklanınca paneli kapatır
overlayEl.addEventListener("click", sepetiKapat); // Karartılmış alana tıklanınca paneli kapatır
document.addEventListener("keydown", (e) => { // Klavyede bir tuşa basılınca
  if (e.key === "Escape") sepetiKapat(); // ESC tuşuysa paneli kapatır
}); // klavye dinleyicisinin sonu

document.getElementById("clearCart").addEventListener("click", () => { // "Sepeti Temizle" butonuna tıklanınca
  sepet = []; // Sepeti boşaltır
  sepetiGuncelle(); // Görünümü yeniler
}); // sepeti temizle dinleyicisinin sonu

odemeBtn.addEventListener("click", () => { // "Siparişi Tamamla" butonuna tıklanınca
  sepet = []; // Sipariş verildiği için sepeti boşaltır
  sepetiGuncelle(); // Görünümü yeniler
  sepetiKapat(); // Sepet panelini kapatır
  bildirimGoster("Siparişiniz alındı, teşekkür ederiz! 🎉"); // Teşekkür bildirimi gösterir
}); // sipariş dinleyicisinin sonu

// Başlangıç
kategorileriGoster(); // Sayfa açılınca kategori butonlarını çizer
urunleriGoster(); // Sayfa açılınca ürünleri çizer
sepetiGuncelle(); // Sayfa açılınca kayıtlı sepeti gösterir
