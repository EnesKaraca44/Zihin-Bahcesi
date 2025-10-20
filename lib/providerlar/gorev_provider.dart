

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:hive/hive.dart';
import 'package:zihin_bahcesi/modeller/gorev.dart';
import 'package:uuid/uuid.dart';

// Veritabanı kutumuz ve anahtarımız için isimler
const String _gorevlerKutusu = 'gorevlerKutusu';
const String _gorevlerAnahtari = 'gorevler';
final _uuid = Uuid();

// Bu, görev listesini yöneten "beyin" sınıfımız olacak.
class GorevlerNotifier extends StateNotifier<List<Gorev>> {
  GorevlerNotifier() : super([]) {
    // Başlangıçta boş bir liste ile başlar
    _verileriYukle(); // ve hemen veritabanından görevleri yükler.
  }

  // Varsayılan görevler listesi. Sadece uygulama ilk kez açıldığında kullanılır.
  final List<Gorev> _varsayilanGorevler = [
    Gorev(id: 'default_1',
        ad: 'Kitap Oku',
        kategori: 'Zihinsel',
        sure: '20 dk',
        canSuyu: 20,
        ikonKodu: Icons.menu_book.codePoint,
        ikonFontAilesi: Icons.menu_book.fontFamily!,
        isCustom: false),
    Gorev(id: 'default_2',
        ad: 'Yeni Dil Öğren',
        kategori: 'Zihinsel',
        sure: '15 dk',
        canSuyu: 25,
        ikonKodu: Icons.language.codePoint,
        ikonFontAilesi: Icons.language.fontFamily!,
        isCustom: false),
    Gorev(id: 'default_3',
        ad: 'Bulmaca Çöz',
        kategori: 'Zihinsel',
        sure: '10 dk',
        canSuyu: 15,
        ikonKodu: Icons.extension.codePoint,
        ikonFontAilesi: Icons.extension.fontFamily!,
        isCustom: false),
    Gorev(id: 'default_4',
        ad: 'Meditasyon Yap',
        kategori: 'Zihinsel',
        sure: '10 dk',
        canSuyu: 18,
        ikonKodu: Icons.self_improvement.codePoint,
        ikonFontAilesi: Icons.self_improvement.fontFamily!,
        isCustom: false),

    // Fiziksel
    Gorev(id: 'default_5',
        ad: 'Koşu Yap',
        kategori: 'Fiziksel',
        sure: '30 dk',
        canSuyu: 30,
        ikonKodu: Icons.directions_run.codePoint,
        ikonFontAilesi: Icons.directions_run.fontFamily!,
        isCustom: false),
    Gorev(id: 'default_6',
        ad: 'Yoga Yap',
        kategori: 'Fiziksel',
        sure: '25 dk',
        canSuyu: 25,
        ikonKodu: Icons.accessibility_new.codePoint,
        ikonFontAilesi: Icons.accessibility_new.fontFamily!,
        isCustom: false),
    Gorev(id: 'default_7',
        ad: 'Ev Egzersizi',
        kategori: 'Fiziksel',
        sure: '20 dk',
        canSuyu: 22,
        ikonKodu: Icons.home_work.codePoint,
        ikonFontAilesi: Icons.home_work.fontFamily!,
        isCustom: false),
    Gorev(id: 'default_8',
        ad: 'Yürüyüş Yap',
        kategori: 'Fiziksel',
        sure: '15 dk',
        canSuyu: 18,
        ikonKodu: Icons.directions_walk.codePoint,
        ikonFontAilesi: Icons.directions_walk.fontFamily!,
        isCustom: false),

    // Yaratıcı
    Gorev(id: 'default_9',
        ad: 'Resim Çiz',
        kategori: 'Yaratıcı',
        sure: '25 dk',
        canSuyu: 28,
        ikonKodu: Icons.brush.codePoint,
        ikonFontAilesi: Icons.brush.fontFamily!,
        isCustom: false),
    Gorev(id: 'default_10',
        ad: 'Müzik Dinle',
        kategori: 'Yaratıcı',
        sure: '15 dk',
        canSuyu: 12,
        ikonKodu: Icons.music_note.codePoint,
        ikonFontAilesi: Icons.music_note.fontFamily!,
        isCustom: false),
    Gorev(id: 'default_11',
        ad: 'Yazı Yaz',
        kategori: 'Yaratıcı',
        sure: '20 dk',
        canSuyu: 24,
        ikonKodu: Icons.edit.codePoint,
        ikonFontAilesi: Icons.edit.fontFamily!,
        isCustom: false),
    Gorev(id: 'default_12',
        ad: 'Fotoğraf Çek',
        kategori: 'Yaratıcı',
        sure: '30 dk',
        canSuyu: 20,
        ikonKodu: Icons.camera_alt.codePoint,
        ikonFontAilesi: Icons.camera_alt.fontFamily!,
        isCustom: false),
  ];

  Future<Box<Gorev>> _getBox() async {
    if (!Hive.isBoxOpen(_gorevlerKutusu)) {
      await Hive.openBox<Gorev>(_gorevlerKutusu);
    }
    return Hive.box<Gorev>(_gorevlerKutusu);
  }

  // Hive'dan verileri yükleyen fonksiyon
  Future<void> _verileriYukle() async {
    try {
      final box = await _getBox();
      print('[GorevProvider] Veriler yükleniyor. Kutudaki görev sayısı: ${box
          .length}');

      // Kutu boşsa, varsayılan görevleri ekle
      if (box.isEmpty) {
        print('[GorevProvider] Kutu boş, varsayılan görevler ekleniyor...');
        // putAll kullanmak daha verimli olabilir
        final Map<String, Gorev> defaultMap = {
          for (var v in _varsayilanGorevler) v.id: v
        };
        await box.putAll(defaultMap);
        state =
            _varsayilanGorevler.toList(); // Listeyi kopyalayarak state'e ata
        print(
            '[GorevProvider] Varsayılan görevler eklendi. State güncellendi: ${state
                .length} görev');
      } else {
        // Kutu boş değilse, tüm değerleri al ve state'i güncelle
        final gorevler = box.values.toList();
        state = gorevler;
        print(
            '[GorevProvider] Kutudan görevler yüklendi. State güncellendi: ${state
                .length} görev');
      }
    } catch (e) {
      print('[GorevProvider] Veri yüklenirken HATA oluştu: $e');
      // Hata durumunda varsayılanları yüklemeyi dene? Veya boş liste bırak?
      state = _varsayilanGorevler.toList(); // Güvenlik için varsayılanlara dön
    }
    // Kutuyu açık bırakalım
  }

  Future<void> gorevEkle(Gorev eklenecekGorev) async { // Parametre zaten tam nesne
    try {
      final box = await _getBox();
      // Gelen nesneyi, kendi ID'si ile doğrudan kaydet
      await box.put(eklenecekGorev.id, eklenecekGorev);
      state = [...state, eklenecekGorev];
      print('[GorevProvider] Görev eklendi: ${eklenecekGorev.ad}. Toplam görev: ${state.length}');
    } catch (e) {
      print('[GorevProvider] Görev eklenirken HATA oluştu: $e');
      // Hata durumunda state'i güncellememek daha doğru olabilir.
      // Veya kullanıcıya bir hata mesajı gösterilebilir.
    }
  }


  Future<void> gorevSil(String id) async {
    try {
      final box = await _getBox();
      await box.delete(id);
      state = state.where((gorev) => gorev.id != id).toList();
      print('[GorevProvider] Görev silindi: $id. Kalan görev: ${state.length}');
    } catch (e) {
      print('[GorevProvider] Görev silinirken HATA oluştu: $e');
    }
  }


  Future<void> gorevGuncelle(Gorev guncellenecekGorev) async {
    try {
      final box = await _getBox();
      await box.put(guncellenecekGorev.id, guncellenecekGorev);
      state = [
        for (final gorev in state)
          if (gorev.id == guncellenecekGorev.id) guncellenecekGorev else
            gorev
      ];
      print('[GorevProvider] Görev güncellendi: ${guncellenecekGorev.ad}');
    } catch (e) {
      print('[GorevProvider] Görev güncellenirken HATA oluştu: $e');
    }
  }

  // Mevcut görev listesini Hive'a kaydeden fonksiyon
  Future<void> _verileriKaydet(List<Gorev> gorevler) async {
    final box = await Hive.openBox<List>(_gorevlerKutusu);
    await box.put(_gorevlerAnahtari, gorevler);
    await box.close();
  }


  Future<void> verileriSifirla() async {
    try {
      final box = await _getBox();
      print('[GorevProvider] Veriler sıfırlanıyor. Önceki görev sayısı: ${box
          .length}');
      await box.clear(); // Önce kutuyu temizle
      print('[GorevProvider] Kutu temizlendi.');
      // Sonra varsayılanları tekrar ekle
      final Map<String, Gorev> defaultMap = {
        for (var v in _varsayilanGorevler) v.id: v
      };
      await box.putAll(defaultMap);
      state = _varsayilanGorevler.toList(); // State'i varsayılanlarla güncelle
      print(
          '[GorevProvider] Varsayılan görevler geri yüklendi. State güncellendi: ${state
              .length} görev');
    } catch (e) {
      print('[GorevProvider] Veriler sıfırlanırken HATA oluştu: $e');
      state = _varsayilanGorevler.toList(); // Hata durumunda varsayılanlara dön
    }
  }
}


// Yeni ve güçlü provider'ımız. Artık bir StateNotifierProvider.
final gorevlerProvider = StateNotifierProvider<GorevlerNotifier, List<Gorev>>((ref) {
  return GorevlerNotifier();
});