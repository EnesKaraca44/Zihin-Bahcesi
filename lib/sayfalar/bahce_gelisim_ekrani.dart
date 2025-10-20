import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:zihin_bahcesi/providerlar/kullanici_provider.dart';
import 'package:zihin_bahcesi/sayfalar/gorev_tanimlama_sayfasi.dart';

import '../modeller/kullanici_verileri.dart';
import 'ayarlar_ekrani.dart';
import 'istatistik_ekrani.dart';

class BahceGelisimEkrani extends ConsumerStatefulWidget {
  const BahceGelisimEkrani({super.key});

  @override
  ConsumerState<BahceGelisimEkrani> createState() => _BahceGelisimEkraniState();
}

class _BahceGelisimEkraniState extends ConsumerState<BahceGelisimEkrani> with TickerProviderStateMixin {

 /* late final AnimationController _lottieController;

  @override
  void initState() {
    super.initState();
    _lottieController = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _lottieController.dispose();
    super.dispose();
  }

  void _gorevTanimlamaSayfasiniAc(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const GorevTanimlamaSayfasi()),
    );
  }

  // Bitki görselini oluşturan metod - Sadece icon ile daha kompakt
  Widget _buildPlantVisual(int tamamlananGorevSayisi) {
    IconData plantIcon;
    Color plantColor;
    double plantSize;

    if (tamamlananGorevSayisi >= 7) {
      // 🌺 Yeşil Çiçek
      plantIcon = Icons.local_florist;
      plantColor = const Color(0xFF4CAF50); // Yeşil
      plantSize = 80.0;
    } else if (tamamlananGorevSayisi >= 4) {
      // 🌿 Yapraklar
      plantIcon = Icons.eco;
      plantColor = const Color(0xFF66BB6A);
      plantSize = 65.0;
    } else if (tamamlananGorevSayisi >= 1) {
      // 🌱 Filiz
      plantIcon = Icons.grass;
      plantColor = const Color(0xFF8BC34A);
      plantSize = 50.0;
    } else {
      // 🪴 Boş saksı
      plantIcon = Icons.yard_outlined;
      plantColor = const Color(0xFF795548);
      plantSize = 40.0;
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 800),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return ScaleTransition(
          scale: animation,
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
      child: Icon(
        plantIcon,
        key: ValueKey<int>(tamamlananGorevSayisi),
        size: plantSize,
        color: plantColor,
      ),
    );
  } */


  String _getGuncelResimYolu(int tamamlananGorevSayisi) {
    // İsimlendirmelerin senin dosya isimlerinle eşleştiğinden emin ol!
    if (tamamlananGorevSayisi <= 0) {
      return ''; // Başlangıçta boş
    } else if (tamamlananGorevSayisi <= 2) { // 1-2 görev
      return 'assets/images/fide_1.jpeg';
    } else if (tamamlananGorevSayisi <= 4) { // 3-4 görev
      return 'assets/images/fide_2.jpeg';
    } else if (tamamlananGorevSayisi <= 6) { // 5-6 görev
      return 'assets/images/cicek_1.jpeg';
    } else if (tamamlananGorevSayisi <= 8) { // 7-8 görev
      return 'assets/images/cicek_2.jpeg';
    } else if (tamamlananGorevSayisi <= 10) { // 9-10 görev
      return 'assets/images/cicek_3.jpeg';
    } else if (tamamlananGorevSayisi <= 12) { // 11-12 görev
      return 'assets/images/agac_1.jpeg';
    } else if (tamamlananGorevSayisi <= 14) { // 13-14 görev
      return 'assets/images/agac_2.png';
    } else if (tamamlananGorevSayisi <= 16) { // 15-16 görev
      return 'assets/images/agac_3.jpeg';
    } else if (tamamlananGorevSayisi <= 18) { // 17-18 görev
      return 'assets/images/agac_4.jpeg';
    } else if (tamamlananGorevSayisi <= 20) { // 19-20 görev
      return 'assets/images/agac_5.jpeg';
    } else { // 21 ve üzeri görev
      return 'assets/images/agac_6.jpeg'; // En büyük ağaç
    }
  }

  // Açıklama metodu (opsiyonel, isteğine göre güncelleyebilirsin)
  String _getDurumAciklamasi(int tamamlananGorevSayisi) {
    if (tamamlananGorevSayisi > 20) {
      return 'Görkemli Bir Bahçen Var!';
    } else if (tamamlananGorevSayisi > 10) {
      return 'Ağacın Büyüyor!';
    } else if (tamamlananGorevSayisi > 4) {
      return 'Bahçen Çiçek Açıyor!';
    } else if (tamamlananGorevSayisi >= 1) {
      return 'İlk Fidelerin Yeşerdi!';
    } else {
      return 'Bahçeni Geliştirmeye Başla!';
    }
  }

  @override
  Widget build(BuildContext context) {
    final kullaniciVerileri = ref.watch(kullaniciVerileriProvider);
    final String resimYolu = _getGuncelResimYolu(kullaniciVerileri.tamamlananGorevSayisi);
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text('Bahçe', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart_rounded, color: Colors.black, size: 28),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const IstatistikEkrani())),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.black, size: 28),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AyarlarEkrani())),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- BAHÇE ALANI (JPEG RESİM GÖSTERİLİYOR) ---
                  Container(
                    width: double.infinity,
                    height: 250,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.lightGreen[100], // Açık yeşil arka plan
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [if (resimYolu.isNotEmpty)
                        Image.asset(
                          resimYolu,
                          // width: double.infinity, // StackFit.expand varken gerekmeyebilir
                          // height: bahceYukseklik, // StackFit.expand varken gerekmeyebilir
                          fit: BoxFit.cover, // <-- ALANI KAPLA
                          errorBuilder: (context, error, stackTrace) {
                            print("HATA: Resim yüklenemedi: $resimYolu, Hata: $error");
                            return const Center(child: Text('Resim Yüklenemedi', style: TextStyle(color: Colors.red)));
                          },
                        )
                      else // Resim yolu boşsa (0 görev)
                        const Center(
                          child: Icon(
                            Icons.yard_outlined,
                            size: 80,
                            color: Colors.brown,
                          ),
                        ),
                        // --- CAN SUYU GÖSTERGESİ BURADA KULLANILIYOR ---
                        Positioned(
                          top: 10,
                          right: 10,
                          // CanSuyuGostergesi widget'ını burada çağırıyoruz
                          child: CanSuyuGostergesi(canSuyu: kullaniciVerileri.canSuyu),
                        ),

                        // --- JPEG RESİM GÖSTERME KISMI ---


                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text('Bahçeniz', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black)),
                  const SizedBox(height: 10),
                  Text(
                    _getDurumAciklamasi(kullaniciVerileri.tamamlananGorevSayisi),
                    style: const TextStyle(fontSize: 15, color: Color(0xFF6B7280), height: 1.5),
                  ),
                  const SizedBox(height: 24),

                  // --- Tamamlanan Görevler Kartı ---
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Tamamlanan Görevler',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF6B7280),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          kullaniciVerileri.tamamlananGorevSayisi.toString(),
                          style: const TextStyle(
                            fontSize: 44,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // --- Gelişim Durumu Kartları ---
                  Row(
                    children: [
                      Expanded(
                        child: _buildProgressCard(
                          'Fideler',
                          kullaniciVerileri.fideler.toString(),
                          Icons.eco,
                          const Color(0xFF4CAF50),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildProgressCard(
                          'Çiçekler',
                          kullaniciVerileri.cicekler.toString(),
                          Icons.local_florist,
                          const Color(0xFFE91E63),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildProgressCard(
                          'Ağaçlar',
                          kullaniciVerileri.agaclar.toString(),
                          Icons.park,
                          const Color(0xFF8BC34A),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // --- Yeni Görev Seç Butonu ---
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const GorevTanimlamaSayfasi())),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_task, size: 22),
                      SizedBox(width: 8),
                      Text(
                        'Yeni Görev Seç',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard(String title, String count, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 26,
          ),
          const SizedBox(height: 8),
          Text(
            count,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF6B7280),
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
class CanSuyuGostergesi extends StatelessWidget {
  final int canSuyu;
  const CanSuyuGostergesi({Key? key, required this.canSuyu}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.water_drop, color: Colors.white, size: 20),
          const SizedBox(width: 6),
          Text(
            '$canSuyu',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}