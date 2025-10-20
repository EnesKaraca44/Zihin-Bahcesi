import 'package:flutter/material.dart';
import 'package:zihin_bahcesi/sayfalar/gorev_tanimlama_sayfasi.dart';
import 'package:zihin_bahcesi/sayfalar/navigasyon_sayfasi.dart';

import 'bahce_gelisim_ekrani.dart';

class HosGeldinSayfasi extends StatelessWidget {
  const HosGeldinSayfasi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Açık gri arka plan
      body: SafeArea(
        child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Sade ve modern görsel alan
              Container(
                width: double.infinity,
                height: 280,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFE8F5E9), // Açık yeşil
                      Color(0xFFF1F8E9), // Açık limon yeşili
                      Color(0xFFFFF9E6), // Çok açık sarı
                    ],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Dekoratif daireler - arka planda
                    Positioned(
                      top: 30,
                      right: 40,
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: const Color(0xFF4CAF50).withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 50,
                      left: 30,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: const Color(0xFF66BB6A).withOpacity(0.08),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    // Ana icon/simge - merkez
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.5),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF4CAF50).withOpacity(0.2),
                                blurRadius: 30,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.eco,
                            size: 80,
                            color: Color(0xFF4CAF50),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Zihin Bahçesi',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2E7D32),
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Ana başlık - Büyük ve siyah
              const Text(
                'Telefonu bırak, hayatı yakala',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 24),

              // Açıklama metni - Daha küçük
              Text(
                'Telefonu bırakmak sana zaman kazandırır. Bu zamanı anlamlı aktivitelerle doldurarak zihnini ve ruhunu besle.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),

              // Alıntı - Büyük ve siyah
              Text(
                '"Tamamladığın her gerçek dünya görevi, sanal bahçendeki bir filizi yeşertsin."',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  height: 1.4,
                  fontStyle: FontStyle.italic,
                ),
              ),
            const SizedBox(height: 60),

              // Başla butonu
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50), // Parlak yeşil
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                    elevation: 2,
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                      MaterialPageRoute(builder: (context) => const NavigasyonSayfasi()),
                    );
                  },
                  child: const Text(
                    'Başla',
                    style: TextStyle(
                      fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}