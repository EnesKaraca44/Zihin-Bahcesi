import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../modeller/tamamlanmis_gorev.dart';
import '../providerlar/kullanici_provider.dart';

class IstatistikEkrani extends ConsumerStatefulWidget {
  const IstatistikEkrani({super.key});

  @override
  ConsumerState<IstatistikEkrani> createState() => _IstatistikEkraniState();
}

class _IstatistikEkraniState extends ConsumerState<IstatistikEkrani> {
  bool isWeekly = true; // Haftalık seçili

  // Bu sabit değişkenlere artık ihtiyacımız yok, çünkü veriyi provider'dan alacağız.
  //int completedTasks = 12; // Tamamlanan görev sayısı
 // int gardenPlants = 25; // Bahçedeki bitki sayısı

  @override
  Widget build(BuildContext context) {
    // Riverpod'dan anlık kullanıcı verilerini çekiyoruz. Her değişimde ekran yeniden çizilir.
    final kullaniciVerileri = ref.watch(kullaniciVerileriProvider);

    // Bahçedeki toplam bitki sayısını hesaplıyoruz.
    final toplamBitkiSayisi =
        kullaniciVerileri.fideler + kullaniciVerileri.cicekler + kullaniciVerileri.agaclar;

    // --- GRAFİK VERİSİ İŞLEME MANTIĞI ---
    final int gunSayisiFiltre = isWeekly ? 7 : 30;
    final grafikVerileri = _gunlukVerileriHesapla(kullaniciVerileri.tamamlananGorevler, isWeekly ? 7 : 30);
    final gorevSayilari = <String, int>{};
    final bugun = DateTime.now();
    final zamanAraligi = Duration(days: gunSayisiFiltre);

    for (final gorev in kullaniciVerileri.tamamlananGorevler) {
      // Sadece belirlenen zaman aralığındaki görevleri say
      if (bugun.difference(gorev.tamamlanmaTarihi) < zamanAraligi) {
        gorevSayilari[gorev.ad] = (gorevSayilari[gorev.ad] ?? 0) + 1;
      }
    }
    final siraliGorevler = gorevSayilari.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    final enCokYapilanSayisi = siraliGorevler.isNotEmpty ? siraliGorevler.first.value : 1;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F9FA),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Color(0xFF2D3436),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'İstatistikler',
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
            // Zaman periyodu seçici
            _buildTimePeriodSelector(),
            const SizedBox(height: 24),
            
            // Tamamlanan görevler kartı
            _buildCompletedTasksCard(kullaniciVerileri.tamamlananGorevSayisi,grafikVerileri, isWeekly),
            const SizedBox(height: 20),
            
            // En çok tamamlanan görevler kartı
            _buildMostCompletedTasksCard(siraliGorevler, enCokYapilanSayisi,isWeekly),
            const SizedBox(height: 20),
            
            // Bahçedeki bitki sayısı kartı
            _buildGardenPlantsCard(toplamBitkiSayisi),

          ],
        ),
      ),
    );
  }
  List<double> _gunlukVerileriHesapla(List<TamamlanmisGorev> tamamlananGorevler, int gunSayisi) {
    // gunSayisi kadar elemanı olan bir liste oluştur (7 veya 30)
    final List<double> gunlukSayilar = List.filled(gunSayisi, 0.0);
    final bugun = DateTime.now();
    // Sadece bugünün başlangıcını alalım (saat, dakika sıfırlanmış)
    final bugununBasi = DateTime(bugun.year, bugun.month, bugun.day);

    for (final gorev in tamamlananGorevler) {
      // Görevin bugünden ne kadar gün önce tamamlandığını hesapla
      final gorevGunuBasi = DateTime(gorev.tamamlanmaTarihi.year, gorev.tamamlanmaTarihi.month, gorev.tamamlanmaTarihi.day);
      final fark = bugununBasi.difference(gorevGunuBasi).inDays;

      // Eğer görev belirlenen gün aralığı içindeyse (0 = bugün, 1 = dün...)
      if (fark >= 0 && fark < gunSayisi) {
        // Listenin sonundan başlayarak doğru güne ekle (son index = bugün)
        final index = (gunSayisi - 1) - fark;
        gunlukSayilar[index]++;
      }
    }
    return gunlukSayilar;
  }
  Widget _buildTimePeriodSelector() {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE9ECEF)),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => isWeekly = true),
              child: Container(
                decoration: BoxDecoration(
                  color: isWeekly ? const Color(0xFFE9ECEF) : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    'Haftalık',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: isWeekly 
                        ? const Color(0xFF2D3436) 
                        : const Color(0xFF6C757D),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => isWeekly = false),
              child: Container(
                decoration: BoxDecoration(
                  color: !isWeekly ? const Color(0xFFE9ECEF) : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    'Aylık',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: !isWeekly 
                        ? const Color(0xFF2D3436) 
                        : const Color(0xFF6C757D),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Bu metot artık tamamlanan görev sayısını parametre olarak alıyor
  Widget _buildCompletedTasksCard(int completedTasks,List<double>grafikVerileri, bool isWeekly) {
    // Grafik için maksimum Y değerini dinamik hesapla
    final double enYuksekBar = grafikVerileri.isEmpty ? 5.0 : grafikVerileri.reduce((a, b) => a > b ? a : b);
    final double maxY = (enYuksekBar * 1.2).clamp(5, 1000).toDouble();
    final int gunSayisi = grafikVerileri.length; // 7 veya 30
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tamamlanan Görevler',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF2D3436),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            isWeekly ? 'Son 7 Gün' : 'Son 30 Gün',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF6C757D),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            '$completedTasks',
            style: GoogleFonts.inter(
              fontSize: 36,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF2D3436),
            ),
          ),
          const SizedBox(height: 20),
          // Haftalık günler placeholder
          SizedBox(
            height: 100, // Grafik için bir yükseklik verelim
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxY, // Maksimum yüksekliği dinamik yap
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (value, meta) => _getBottomTitles(value, meta, gunSayisi), interval: gunSayisi > 7 ? 5 : 1)),
                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: FlGridData(show: false),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(gunSayisi, (index) {
                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: grafikVerileri[index],
                        color: const Color(0xFF00B894),
                        width:gunSayisi > 7 ? 6 : 12,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getBottomTitles(double value, TitleMeta meta,int gunSayisi) {
    const style = TextStyle(
      color: Color(0xFF6C757D),
      fontWeight: FontWeight.w500,
      fontSize: 14,
    );
    String text=" ";
    if (gunSayisi == 7) {
      switch (value.toInt()) {
        case 0: text = 'Pzt'; break;
        case 1: text = 'Sal'; break;
        case 2: text = 'Çar'; break;
        case 3: text = 'Per'; break;
        case 4: text = 'Cum'; break;
        case 5: text = 'Cmt'; break;
        case 6: text = 'Paz'; break;
      }
    }
    // Aylık görünüm için (örneğin her 5 günde bir gün numarasını göster)
    else if (gunSayisi == 30) {
      final dayIndex = (gunSayisi - 1) - value.toInt(); // 0 = bugün, 1 = dün ... 29 = 29 gün önce
      final date = DateTime.now().subtract(Duration(days: dayIndex));
      // Sadece 1., 5., 10., 15., 20., 25., 30. günlerin etiketini göster
      if ( (dayIndex + 1) % 5 == 0 || dayIndex == 0) {
        text = '${date.day}'; // Sadece gün numarasını yaz
      }
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(text, style: style),
    );
  }

  Widget _buildDayLabel(String day, bool isSelected) {
    return Text(
      day,
      style: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: isSelected 
          ? const Color(0xFF00B894) 
          : const Color(0xFF6C757D),
      ),
    );
  }

  Widget _buildMostCompletedTasksCard(List<MapEntry<String, int>> siraliGorevler, int enCokYapilanSayisi,bool isWeekly) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'En Çok Tamamlanan Görevler',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF2D3436),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            isWeekly ? 'Son 7 Gün' : 'Son 30 Gün',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF6C757D),
            ),
          ),
          const SizedBox(height: 24),
          // Buradaki sabit görevleri kaldırdık, yerine dinamik listeyi kullanıyoruz.
          if (siraliGorevler.isEmpty) // Eğer hiç görev yoksa mesaj göster
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Text(
                'Henüz hiç görev tamamlamadın.',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: const Color(0xFF6C757D),
                ),
              ),
            )
          else
          // İlk 3 veya daha az görevi alıp çubukları oluşturuyoruz
            ...siraliGorevler.take(3).map((gorevEntry) {
              final gorevAdi = gorevEntry.key;
              final sayi = gorevEntry.value;
              final progress = enCokYapilanSayisi > 0 ? sayi / enCokYapilanSayisi : 0.0;
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: _buildTaskProgressBar(gorevAdi, sayi, progress),
              );
            }).toList(),
        ],
      ),
    );
  }

  Widget _buildTaskProgressBar(String taskName, int count, double progress) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                taskName,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF2D3436),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: const Color(0xFFE9ECEF),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: progress,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF00B894),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Text(
          '$count',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF2D3436),
          ),
        ),
      ],
    );
  }

  Widget _buildGardenPlantsCard(int gardenPlants) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bahçedeki Bitki Sayısı',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF2D3436),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            '$gardenPlants',
            style: GoogleFonts.inter(
              fontSize: 36,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF2D3436),
            ),
          ),
        ],
      ),
    );
  }
}

