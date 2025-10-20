import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../modeller/gorev.dart';
import '../providerlar/kullanici_provider.dart';

class GorevYapmaEkrani extends ConsumerStatefulWidget {
  final Gorev secilenGorev;

  const GorevYapmaEkrani({super.key, required this.secilenGorev});

  @override
  ConsumerState<GorevYapmaEkrani> createState() => _GorevYapmaEkraniState();
}

class _GorevYapmaEkraniState extends ConsumerState<GorevYapmaEkrani> {
  Timer? _timer;
  late int _kalanSure; // Kalan süreyi saniye cinsinden tutacağız.
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    // Bu metot, ekran ilk açıldığında SADECE BİR KEZ çalışır.
    // Görevin süresini (örn: "20 dk") saniyeye çevirip sayacı başlatıyoruz.
    _kalanSure = (int.tryParse(widget.secilenGorev.sure.split(' ')[0]) ?? 1) * 60;
    _zamanlayiciyiBaslat();
  }

  void _zamanlayiciyiBaslat() {
    // Her 1 saniyede bir çalışan bir zamanlayıcı oluşturuyoruz.
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_kalanSure > 0) {
        // setState(), Flutter'a "veri değişti, ekranı yeniden çiz" komutunu verir.
        setState(() {
          _kalanSure--;
        });
      } else {
        timer.cancel(); // Süre bitince zamanlayıcıyı durdururuz.
        setState(() {}); // Butonun aktif olması için son bir kez ekranı yenile.
      }
    });
  }

  @override
  void dispose() {
    // Bu metot, ekran kapatıldığında çalışır.
    // Zamanlayıcıyı iptal etmek, hafızada gereksiz yer kaplamasını önler. ÇOK ÖNEMLİ!
    _timer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    // Kalan saniyeyi dakika ve saniye olarak formatlayalım
    final dakika = (_kalanSure / 60).floor().toString().padLeft(2, '0');
    final saniye = (_kalanSure % 60).toString().padLeft(2, '0');
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: 24,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Görev Takibi',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Odaklanma Zamanı Başlığı
            const Text(
              'Odaklanma Zamanı',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            // Görev Açıklaması
            Text(
              'Göreviniz: ${widget.secilenGorev.ad}',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

            // Zamanlayıcı Kutuları
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTimeBox(
                  context,
                  "00",
                  'Saat',
                ),
                const SizedBox(width: 16),
                _buildTimeBox(
                  context,
                 dakika,
                  'Dakika',
                ),
                const SizedBox(width: 16),
                _buildTimeBox(
                  context,
                saniye,
                  'Saniye',
                ),
              ],
            ),
            const SizedBox(height: 60),

            // Görevi Tamamla Butonu
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: _kalanSure == 0
                    ? () async { // 1. Fonksiyonu 'async' yaptık
                  // Önce veriyi güncelle
                  ref.read(kullaniciVerileriProvider.notifier).gorevTamamla(widget.secilenGorev);

                  // --- 2. SES ÇALMA KODUNU BURAYA EKLEDİK ---
                  try {
                    // 'assets/sounds/success.mp3' dosyasını çalmayı dene
                    await _audioPlayer.play(AssetSource('sounds/success.mp3'));
                  } catch (e) {
                    // Eğer bir hata olursa (dosya bulunamazsa vs.) konsola yazdır
                    print("Ses çalınırken hata oluştu: $e");
                  }
                  // --- SES KODU BİTTİ ---

                  // Sayfaları kapat (Bu kısım aynı kalıyor)
                  // 'mounted' kontrolü, sayfa kapanmadan önce işlem yapmaya çalışmayı önler.
                  if (mounted) Navigator.pop(context);
                  if (mounted) Navigator.pop(context);
                }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 5,
                ),
                child: const Text(
                  'Görevi Tamamla',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Görevi İptal Et Butonu
            TextButton(
              onPressed: () {
                // Zamanlayıcıyı durdurup bir önceki sayfaya (Görev Listesine) dönüyoruz.
                _timer?.cancel();
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey[700],
              ),
              child: const Text(
                'Görevi İptal Et',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Zaman kutularını oluşturan yardımcı metod
  Widget _buildTimeBox(BuildContext context, String value, String label) {
    return Container(
      width: 90,
      height: 100,
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C3E50),
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

