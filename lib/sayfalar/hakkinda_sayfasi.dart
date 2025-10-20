


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HakkindaSayfasi extends StatelessWidget {
  const HakkindaSayfasi({super.key});

  @override
  Widget build(BuildContext context) {
    // Uygulama versiyonunu (şimdilik manuel olarak) belirleyelim
    const String appVersion = "1.0.0";

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Ayarlar ekranıyla uyumlu arka plan
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Uygulama Hakkında',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Uygulama İkonu (Opsiyonel - app_icon.png kullanabiliriz)
            Image.asset(
              'assets/icon/app_icon.png', // Uygulama ikonumuzun yolu
              height: 100,
              width: 100,
            ),
            const SizedBox(height: 20),

            // Uygulama Adı
            Text(
              'Zihin Bahçesi',
              style: GoogleFonts.inter(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF2D3436),
              ),
            ),
            const SizedBox(height: 8),

            // Versiyon Numarası
            Text(
              'Versiyon $appVersion',
              style: GoogleFonts.inter(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 30),

            // Açıklama Metni
            Text(
              'Zihin Bahçesi, dijital detoks yaparak odaklanmanıza ve kişisel gelişiminize yardımcı olmak için tasarlanmıştır. Tamamladığınız her görevle sadece zihninizi değil, sanal bahçenizi de büyütün.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 16,
                color: const Color(0xFF495057),
                height: 1.5, // Satır aralığı
              ),
            ),
            const SizedBox(height: 30),


            Text(
              'Geliştirici: Enes KARACA ',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),

            const SizedBox(height: 40),


            Text(
              '© 2025 Zihin Bahçesi. Tüm hakları saklıdır.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: Colors.grey[400],
              ),
            ),
          ],
        ),
      ),
    );
  }
}