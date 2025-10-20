// lib/sayfalar/navigasyon_sayfasi.dart

import 'package:flutter/material.dart';
import 'package:zihin_bahcesi/sayfalar/bahce_gelisim_ekrani.dart';
import 'package:zihin_bahcesi/sayfalar/gorev_tanimlama_sayfasi.dart';
import 'package:zihin_bahcesi/sayfalar/istatistik_ekrani.dart';

class NavigasyonSayfasi extends StatefulWidget {
  const NavigasyonSayfasi({super.key});

  @override
  State<NavigasyonSayfasi> createState() => _NavigasyonSayfasiState();
}

class _NavigasyonSayfasiState extends State<NavigasyonSayfasi> {
  // Uygulama açıldığında Bahçe ekranının (index 1) seçili gelmesini sağlıyoruz.
  int _selectedIndex = 1;

  // Sahte sayfaları, bizim gerçek ekranlarımızla değiştiriyoruz.
  static const List<Widget> _sayfalar = <Widget>[
    GorevTanimlamaSayfasi(), // Index 0
    BahceGelisimEkrani(),   // Index 1 (Ana Sayfamız)
    IstatistikEkrani(),     // Index 2
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _sayfalar[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        // Senin kodunla aynı, sadece ikonları ve sırayı güncelledik.
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_rounded),
            label: 'Görevler',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.spa_rounded),
            label: 'Bahçe',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_rounded),
            label: 'İstatistikler',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green, // Seçili ikonun rengi
        onTap: _onItemTapped,
        backgroundColor: Colors.white,
        elevation: 10,
        type: BottomNavigationBarType.fixed, // Tüm etiketlerin görünmesini sağlar
      ),
    );
  }
}