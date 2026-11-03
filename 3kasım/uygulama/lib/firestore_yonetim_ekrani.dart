import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'models/ogrenci_model.dart';

class FirestoreYonetimEkrani extends StatefulWidget {
  const FirestoreYonetimEkrani({super.key});
  @override
  State<FirestoreYonetimEkrani> createState() => _FirestoreYonetimEkraniState();
}

class _FirestoreYonetimEkraniState extends State<FirestoreYonetimEkrani> {
  final FireStoreOgrenciServisi _servis = FireStoreOgrenciServisi();

  final TextEditingController _adsoyadKontrolcusu = TextEditingController();
  final TextEditingController _projeKontrolcusu = TextEditingController();
  final TextEditingController _notKontrolcusu = TextEditingController();

  @override
  void dispose() {
    //kullanacağımız zaman çalışması için
    _adsoyadKontrolcusu.dispose();
    _projeKontrolcusu.dispose();
    _notKontrolcusu.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Canlı Firestore ekranı"),
        backgroundColor: Colors.amber.shade600,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  TextField(
                    controller: _adsoyadKontrolcusu,
                    decoration: const InputDecoration(
                      labelText: "Öğrenci Adı Soyadı",
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    //SizedBox üstüne proje bölümü gelecek ama expended
                    width: 90,
                    child: TextField(
                      controller: _notKontrolcusu,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Sayısal Not",
                        prefixIcon: Icon(Icons.grade),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                  foregroundColor: Colors.brown,
                  minimumSize: const Size.fromHeight(44),
                ),
                onPressed: _yeniOgrenciKaydet,
                icon: const Icon(Icons.cloud_upload),
                label: const Text("Buluta Kaydet"),
              ),
            ),
          ),
        ],
      ),
      const Divider(thickness: 2),
      Expanded(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('ogrenciler')
              .orderBy('notu', descending: true)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text("Bulut hatası: ${snapshot.error}"));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("Henüz kayıtlı öğrenci yok"));
                }
                final List<DocumentSnapshot> dokumanlar = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: dokumanlar.length,
                  itemBuilder: (context, index) {
                    final doc = dokumanlar[index];
                    final ogrenci = OgrenciModel.fromFireStore(doc);
                    return Dismissible(
                      key: Key(ogrenci.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(right: 20),
                        color: Colors.red,
                        child: const Icon(
                          Icons.delete_forever,
                          color: Colors.white,
                        ),
                      ),
                      onDismissed: (direction) {
                        _servis.ogrenciSil(ogrenci.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("${ogrenci.adSoyad} kaydı silindi"),
                          ),
                        );
                      },
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: ogrenci.notu >= 80
                              ? Colors.green
                              : (ogrenci.notu >= 50
                                    ? Colors.orange
                                    : Colors.red),
                          child: Text(
                            '${ogrenci.notu}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(
                          ogrenci.adSoyad,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text('proje: ${ogrenci.projeAdi}'),
                        trailing: IconButton(
                          onPressed: () =>
                              _notuGuncelleDialog(ogrenci.id), //ödev
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.amberAccent,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
        ),
      ),
    );
  }

  void _yeniOgrenciKaydet() {
    final adSoyad = _adsoyadKontrolcusu.text.trim();
    final proje = _projeKontrolcusu.text.trim();
    final not = int.tryParse(_notKontrolcusu.text.trim()) ?? 0;

    if (adSoyad.isEmpty || proje.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen ad soyad ve proje adını giriniz')),
      );
      return;
    }
    _servis.ogrenciEkle(adSoyad: adSoyad, projeAdi: proje, notu: not);
    _adsoyadKontrolcusu.clear();
    _projeKontrolcusu.clear();
    _notKontrolcusu.clear();
  }
}

//yapılacaklar
// expanded içinde projeadı inputu açılacak
// _notGuncelleDialog fonksiyonu yazılaacak
// sayfalar parse edilecek ve sistem çalışır hale getirilecek
//yarın rastgele ödevini seçen öğrenci ekranında sınıfa gösterecek.
