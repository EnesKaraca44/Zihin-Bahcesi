import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Veritabanı kutumuz ve anahtarımız için isimler
const String _temaKutusu = 'temaKutusu';
const String _temaAnahtari = 'isDarkMode';

// Bu, tema durumunu (açık/koyu) yöneten "beyin" sınıfımız.
class TemaNotifier extends StateNotifier<ThemeMode> {
  TemaNotifier() : super(ThemeMode.light) { // Başlangıçta varsayılan tema açık mod.
    _verileriYukle(); // ve hemen kaydedilmiş tema tercihini yükle.
  }

  // Hive'dan kaydedilmiş tema tercihini yükleyen fonksiyon
  Future<void> _verileriYukle() async {
    final box = await Hive.openBox<bool>(_temaKutusu);
    // 'isDarkMode' anahtarıyla kaydedilmiş bir değer var mı diye bak.
    // Değer 'true' ise koyu tema, değilse (null veya false ise) açık tema kullanılır.
    final isDarkMode = box.get(_temaAnahtari) ?? false;
    state = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    await box.close();
  }

  // Mevcut tema tercihini Hive'a kaydeden fonksiyon
  Future<void> _verileriKaydet(bool isDarkMode) async {
    final box = await Hive.openBox<bool>(_temaKutusu);
    await box.put(_temaAnahtari, isDarkMode);
    await box.close();
  }

  // Temayı değiştiren ve tercihi kaydeden ana fonksiyonumuz
  Future<void> temayiDegistir(bool isDarkMode) async {
    state = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    await _verileriKaydet(isDarkMode);
  }
}

// UI'ın (arayüzün) TemaNotifier'ımıza erişmesini sağlayan Provider.
final temaProvider = StateNotifierProvider<TemaNotifier, ThemeMode>((ref) {
  return TemaNotifier();
});