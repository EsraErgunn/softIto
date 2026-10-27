import '../models/kategori.dart';
import '../models/urun.dart';
import 'i_urun_servisi.dart';

class MockUrunServisi implements IUrunServisi{
    final List<Urun> _urunDeposu = const [
        Urun(
            id: 1,
            baslik: "Macbook M5 Pro Laptop",
            aciklama: "Apple'ın M5 yonga setli en yeni laptop modeli.",
            fiyat: 179999,
            resimUrl: "https://picsum.photos/400/400",
            kategori: Kategori.elektronik,
            stokAdedi: 15,
        ),
        Urun(
            id: 2,
            baslik: "Apple 18 Pro Max",
            aciklama: "iPhone 18 Pro Max. Tıpkı iPhone 17 gibi, hem telefonlarda hem de akıllı saatlerde daha dayanıklı, titanyum üretildi.",
            fiyat: 99999,
            resimUrl: "https://picsum.photos/400/400",
            kategori: Kategori.elektronik,
            stokAdedi: 15,
        ),
        Urun(
            id: 3,
            baslik: "Şık kadın elbise",
            aciklama: "Kaliteli kumaştan üretilmiş şık kadın giyim",
            fiyat: 1499,
            resimUrl: "https://picsum.photos/400/400",
            kategori: Kategori.giyim,
            stokAdedi: 20,
        ),
        Urun(
            id: 4,
            baslik: "Spor ayakkabı",
            aciklama: "Nike marka spor ayakkabı. Kaliteli ve kullanışlı",
            fiyat: 3499,
            resimUrl: "https://picsum.photos/400/400",
            kategori: Kategori.ayakkabi,
            stokAdedi: 38,
        ),
        Urun(
            id: 5,
            baslik: "Şapka",
            aciklama: "Şık ve kullanışlı şapka",
            fiyat: 399,
            resimUrl: "https://picsum.photos/400/400",
            kategori: Kategori.aksesuar,
            stokAdedi: 23,
        ),
        Urun(
            id: 6,
            baslik: "Deri ceket",
            aciklama: "Zamansız şıklığı ve güçlü duruşuyla stilinize karakter katın. Modern kesimi ve kaliteli deri dokusuyla öne çıkan bu ceket, günlük kombinlerinize asi ve sofistike bir hava kazandırır. Her mevsim tarzınızı tamamlayan klasik bir parça.",
            fiyat: 4999,
            resimUrl: "https://picsum.photos/400/400",
            kategori: Kategori.giyim,
            stokAdedi: 5,
        ),
        Urun(
            id: 7,
            baslik: "Mavi Kot Pantolon",
            aciklama: "Zamansız tasarımı ve rahat kesimiyle her kombinin vazgeçilmez parçası. Klasik mavi denim dokusu, günlük stilinize modern ve özgün bir görünüm kazandırır. Tişörtlerden gömleklere kadar farklı parçalarla kolayca kombinleyebileceğiniz bu pantolonla tarzınızı tamamlayın.",
            fiyat: 1299,
            resimUrl: "https://picsum.photos/400/400",
            kategori: Kategori.giyim,
            stokAdedi: 12,
        ),
        Urun(
            id: 8,
            baslik: "Vans Old Skool",
            aciklama: "Zamansız tasarımı ve ikonik yan şeridiyle sokak stilinin vazgeçilmezlerinden biri. Dayanıklı kanvas ve süet detayları, rahat yapısı ve klasik görünümüyle günlük kombinlerinize özgün bir karakter katar. Tarzınızı her adımda yansıtın.",
            fiyat: 2499,
            resimUrl: "https://picsum.photos/400/400",
            kategori: Kategori.ayakkabi,
            stokAdedi: 7,
        ),
        Urun(
            id: 9,
            baslik: "Tektaş Yüzük",
            aciklama: "Zarafetin ve sonsuz sevginin simgesi. Işıltılı taşı ve zamansız tasarımıyla özel anlarınıza anlam katan tektaş yüzük, her bakışta unutulmaz bir güzelliği yansıtır. En değerli anlarınızı eşsiz bir ışıltıyla taçlandırın.",
            fiyat: 15999,
            resimUrl: "https://picsum.photos/400/400",
            kategori: Kategori.aksesuar,
            stokAdedi: 10,
        ),
    ];

    @override
    Future<List<Urun>> tumUrunleriGetir() async{
        await Future.delayed(const Duration(milliseconds:1500));
        return List.from(_urunDeposu);
    }

    @override
    Future<List<Urun>> kategoriyeGoreGetir(Kategori kategori) async{
        await Future.delayed(const Duration(milliseconds: 400));
        if(kategori==Kategori.hepsi){
            return List.from(_urunDeposu);
        }
        return _urunDeposu.where((u) => u.kategori==kategori).toList();
    }
    @override
    Future<List<Urun>> adaGoreAra(String aramaMetni) async {
        await Future.delayed(const Duration(milliseconds: 300));
        if(aramaMetni.trim().isEmpty){
            return List.from(_urunDeposu);
        }
        return _urunDeposu.where((urun){
            final baslikKucuk = urun.baslik.toLowerCase();
            final arananKucuk = aramaMetni.toLowerCase();
            return baslikKucuk.contains(arananKucuk);
        }).toList();

    }
    
}