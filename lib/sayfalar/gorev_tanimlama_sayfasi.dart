import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';


import 'package:zihin_bahcesi/providerlar/gorev_provider.dart';
import 'package:zihin_bahcesi/providerlar/kullanici_provider.dart';
import 'package:zihin_bahcesi/sayfalar/yeni_gorev_ekleme_sayfasi.dart';


import '../modeller/gorev.dart';
import 'gorev_yapma_ekrani.dart';

// StatelessWidget'ı ConsumerWidget'a çeviriyoruz.
// Bu, widget'ın provider'ları dinlemesini sağlar.
class GorevTanimlamaSayfasi extends ConsumerWidget {
  const GorevTanimlamaSayfasi({super.key});

  @override
  // build metoduna "WidgetRef ref" parametresini ekliyoruz.
  // "ref" objesi ile provider'lara ulaşacağız.
  Widget build(BuildContext context,WidgetRef ref) {
    // ref.watch ile gorevlerProvider'ı dinliyoruz ve listeyi alıyoruz.
    final gorevler = ref.watch(gorevlerProvider);
    final gorevlerNotifier = ref.read(gorevlerProvider.notifier);

    // Görevleri kategorilere göre filtreliyoruz.
    final zihinselGorevler = gorevler.where((g) => g.kategori == 'Zihinsel').toList();
    final fizikselGorevler = gorevler.where((g) => g.kategori == 'Fiziksel').toList();
    final yaraticiGorevler = gorevler.where((g) => g.kategori == 'Yaratıcı').toList();
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar( // AppBar'ı geri ekledim, çünkü tasarımda mevcut
        backgroundColor: const Color(0xFFF8F9FA),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Color(0xFF2D3436)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Görevi Seç',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF2D3436),
          ),
        ),
        centerTitle: true,

      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // _buildHeader() metodunu doğrudan bu alana taşıdım veya build içinde tanımladım
            // Başlık Bölümü
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Bugün Ne Yapsan?',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Kendini geliştirmek için bir görev seç',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Artık kategorilere göre filtreliyoruz ve yeni helper metotları kullanıyoruz
            _buildGorevKategorisi(context, ref, 'Zihinsel', zihinselGorevler, gorevlerNotifier),
            const SizedBox(height: 24), // Önceki kodda 25 idi, tutarlı olması için 24 yaptım
            _buildGorevKategorisi(context, ref, 'Fiziksel', fizikselGorevler, gorevlerNotifier),
            const SizedBox(height: 24),
            _buildGorevKategorisi(context, ref, 'Yaratıcı', yaraticiGorevler, gorevlerNotifier),
            const SizedBox(height: 24), // Önceki kodda 40 idi, tutarlı olması için 24 yaptım

             _buildOzelGorevEkle(context) //metodunu artık AppBar actions içinde kullanıyoruz, burada olmamalı.
             
            // Eğer özel görev ekleme butonu burada kalsın derseniz, AppBar actions'taki butonu kaldırın
            // ve bu metodu uygun şekilde buraya taşıyın.
          ],
        ),
      ),
    );
  }
  // Parametre tipini List<Map<String, String>>'den List<Gorev>'e değiştirdik.
  Widget _buildGorevKategorisi(BuildContext context, WidgetRef ref, String kategoriAdi, List<Gorev> gorevler, GorevlerNotifier gorevlerNotifier) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 8.0),
          child: Text(
            kategoriAdi,
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF2D3436),
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 145, // Kartların yüksekliği
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: gorevler.length,
            itemBuilder: (context, index) {
              final gorev = gorevler[index];
              return Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                    context,
                    MaterialPageRoute(
                    builder: (context) => GorevYapmaEkrani(secilenGorev: gorev),
                    ),
                    );
                  },
                  child: Container(
                    width: 150,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Stack( // İkonları üst üste bindirmek için Stack kullanıyoruz
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE0F7FA), // İkon arka plan rengi
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(gorev.ikon, color: const Color(0xFF00ACC1), size: 24),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              gorev.ad,
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF2D3436),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              gorev.sure,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF6C757D),
                              ),
                            ),
                          ],
                        ),

                        // --- YENİ EKLENECEK BÖLÜM: DÜZENLEME VE SİLME İKONLARI ---
                        if (gorev.isCustom) // Sadece özel görevler için göster
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    // DÜZENLEME İŞLEMİ BURAYA GELECEK
                                    _navigateToEditTask(context, gorev,ref);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(Icons.edit, size: 16, color: Colors.blue[600]),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                GestureDetector(
                                  onTap: () {
                                    // SİLME İŞLEMİ BURAYA GELECEK
                                    _showDeleteConfirmationDialog(context, gorev, gorevlerNotifier);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(Icons.delete, size: 16, color: Colors.red[600]),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        // --- YENİ EKLENECEK BÖLÜM BİTTİ ---
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
  void _showDeleteConfirmationDialog(BuildContext context, Gorev gorev, GorevlerNotifier gorevlerNotifier) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Görevi Sil'),
          content: Text('${gorev.ad} görevini silmek istediğinizden emin misiniz? Bu işlem geri alınamaz.'),
          actions: <Widget>[
            TextButton(
              child: const Text('İptal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Sil', style: TextStyle(color: Colors.red)),
              onPressed: () {
                gorevlerNotifier.gorevSil(gorev.id); // Görevi sil
                Navigator.of(context).pop(); // Diyaloğu kapat
                ScaffoldMessenger.of(context).showSnackBar( // Bildirim göster
                  SnackBar(
                    content: Text('${gorev.ad} görevi silindi.'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  // --- YENİ METOT: DÜZENLEME SAYFASINA YÖNLENDİRME ---
  void _navigateToEditTask(BuildContext context, Gorev gorev, WidgetRef ref) async {
    // Burada YeniGorevEklemeSayfasi'na gideceğiz ve mevcut görevi göndereceğiz
    // Bu sayfayı da bir sonraki adımda düzenleme için hazırlayacağız.
    final Gorev? updatedGorev = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => YeniGorevEklemeSayfasi(gorevToEdit: gorev),
      ),
    );

    // Eğer görev güncellenip geri dönüldüyse
    if (updatedGorev != null) {
      ref.read(gorevlerProvider.notifier).gorevGuncelle(updatedGorev);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${updatedGorev.ad} görevi güncellendi.'),
          backgroundColor: Colors.blue,
        ),
      );
    }
  }

  // Parametre tipini Map<String, String>'den Gorev'e değiştirdik.
  Widget _buildGorevKarti(BuildContext context, Gorev gorev, Color kategoriRengi,WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
        border: Border.all(color: kategoriRengi.withOpacity(0.2), width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            // Artık burada puanı güncellemiyoruz veya pop yapmıyoruz.
            // Kullanıcıyı yeni "Görev Yapma Ekranı"na yönlendiriyoruz
            // ve seçtiği görevi o ekrana bilgi olarak gönderiyoruz.
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GorevYapmaEkrani(secilenGorev: gorev),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: kategoriRengi.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                  // İKONLARI GÖSTERMEK İÇİN KULLANDIĞIN UZUN if/else YAPISINA ARTIK GEREK YOK!
                  // Çünkü Gorev objemizin içinde ikonun kendisi var.
                  child: Icon(gorev.ikon, color: kategoriRengi, size: 20),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(gorev.ad, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF2C3E50)), maxLines: 2, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(gorev.sure, style: TextStyle(fontSize: 12, color: Colors.grey[600], fontWeight: FontWeight.w500)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Text('💧', style: TextStyle(fontSize: 14)),
                        const SizedBox(width: 4),
                        // canSuyu artık bir int olduğu için .toString() ile metne çeviriyoruz.
                        Text('+${gorev.canSuyu}', style: TextStyle(fontSize: 12, color: Colors.blue[600], fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOzelGorevEkle(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF4CAF50), Color(0xFF388E3C)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: const Color(0xFF4CAF50).withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            // Yeni görev ekleme sayfasına yönlendiriyoruz.
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const YeniGorevEklemeSayfasi()),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.add_circle_outline, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Kendi Görevini Oluştur', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                      SizedBox(height: 4),
                      Text('Kişisel hedeflerini takip et', style: TextStyle(fontSize: 14, color: Colors.white70)),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios, color: Colors.white.withOpacity(0.8), size: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
