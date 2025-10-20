import 'package:flutter_riverpod/legacy.dart';
import 'package:hive/hive.dart';

import '../modeller/gorev.dart';
import '../modeller/kullanici_verileri.dart';
import '../modeller/tamamlanmis_gorev.dart';
import 'package:uuid/uuid.dart';

// Veritabanı kutumuz için bir isim tanımlıyoruz
const String _kullaniciVerileriKutusu = 'kullaniciVerileriKutusu';
const String _kullaniciVerileriAnahtari = 'kullaniciVerileri';
final _uuid = Uuid(); // Uuid nesnesini bir kere oluşturup kullanıyoruz

class KullaniciVerileriNotifier extends StateNotifier<KullaniciVerileri> {
// Kutuyu sınıf içinde tutalım ki sürekli açıp kapatmayalım
  Box<KullaniciVerileri>? _box;
  // Başlangıç verilerini belirterek Notifier'ı başlatıyoruz.
  // Constructor'ımızı 'async' hale getiriyoruz çünkü veritabanından veri okuyacağız.
  // `super(const KullaniciVerileri.initial())` ile başlangıçta sıfır değerleri veriyoruz,
  // ancak hemen ardından veritabanından gelen gerçek verilerle güncelleyeceğiz
  KullaniciVerileriNotifier() : super( KullaniciVerileri(id: _uuid.v4())) {
    _verileriYukle(); // Notifier oluşturulduğunda verileri yükle.
  }

  // Veritabanından verileri yükleyen asenkron fonksiyon
  Future<void> _verileriYukle() async {
    print('[KullaniciProvider] Hive başlatılıyor ve veri yükleniyor...');
    try {
      // Kutuyu aç ve _box değişkenine ata
      _box = Hive.box<KullaniciVerileri>(_kullaniciVerileriKutusu);
      print('[KullaniciProvider] Hive kutusu başarıyla açıldı.');

      // Kutudan veriyi oku
      final kaydedilmisVeriler = _box!.get(_kullaniciVerileriAnahtari);

      if (kaydedilmisVeriler != null) {
        // State'i sadece veritabanından gelen geçerli veriyle güncelle
        state = kaydedilmisVeriler;
        print('[KullaniciProvider] Kayıtlı veri bulundu ve state yüklendi: ${state.tamamlananGorevSayisi} görev.');
      } else {
        print('[KullaniciProvider] Kayıtlı veri bulunamadı. Başlangıç verisi oluşturuluyor ve kaydediliyor.');
        // Başlangıç verisini oluştur ve state'i ayarla
        final initialData = KullaniciVerileri(id: _uuid.v4());
        state = initialData;
        // Başlangıç verisini kaydetmeyi dene
        await _verileriKaydet(initialData);
      }
    } catch (e, s) { // Detaylı hata yakalama
      print('[KullaniciProvider] Hive başlatma/yükleme sırasında KRİTİK HATA oluştu: $e');
      print('Stack Trace: $s');
      // Hata durumunda state'i sıfırlanmış olarak bırak
      state = KullaniciVerileri(id: _uuid.v4());
    }
  }

  // Verileri veritabanına kaydeden asenkron fonksiyon
  Future<void> _verileriKaydet(KullaniciVerileri veriler) async {
    // Kutunun açık olduğundan emin ol, değilse işlemi atla veya hata ver
    if (_box == null || !_box!.isOpen) {
      print('[KullaniciProvider] HATA: Veri kaydedilemedi, Hive kutusu kapalı veya başlatılamadı.');
      return; // Kutuyu açmaya çalışma, _init'in görevi
    }

    print('[KullaniciProvider] Veriler kaydediliyor: ${veriler.tamamlananGorevSayisi} görev.');
    try {
      // Veriyi kutuya yaz
      await _box!.put(_kullaniciVerileriAnahtari, veriler);
      // Değişiklikleri diske hemen yazmayı zorla
      await _box!.flush();
      print('[KullaniciProvider] Veriler başarıyla kaydedildi ve diske yazıldı.');
    } catch (e, s) { // Detaylı hata yakalama
      print('[KullaniciProvider] Veri kaydedilirken KRİTİK HATA oluştu: $e');
      print('Stack Trace: $s');
      // Burada kullanıcıya bir hata mesajı göstermek iyi olabilir.
    }
  }

  Future<void> updateKullaniciVerileri({
    String? kullaniciAdi,
    String? bahceAdi,
    bool? sesAcik,
    bool? bildirimlerAcik,
  }) async {
    print('[KullaniciProvider] updateKullaniciVerileri çağrıldı.');
    final yeniState = state.copyWith(
      kullaniciAdi: kullaniciAdi,
      bahceAdi: bahceAdi,
      sesAcik: sesAcik,
      bildirimlerAcik: bildirimlerAcik,
    );
    state = yeniState;
    await _verileriKaydet(yeniState);
  }

  // 2. Bu, dışarıdan çağıracağımız ve verileri güncelleyecek olan fonksiyon.
  Future<void> gorevTamamla(Gorev tamamlananGorev) async {
    print('[KullaniciProvider] gorevTamamla çağrıldı: ${tamamlananGorev.ad}');
    final yeniTamamlananGorevSayisi = state.tamamlananGorevSayisi + 1;
    int yeniFide = state.fideler;
    int yeniCicek = state.cicekler;
    int yeniAgac = state.agaclar;

    if (yeniTamamlananGorevSayisi % 3 == 1) { yeniFide++; }
    else if (yeniTamamlananGorevSayisi % 3 == 2) { yeniCicek++; }
    else { yeniAgac++; }

    final yeniState = state.copyWith(
      tamamlananGorevSayisi: yeniTamamlananGorevSayisi,
      canSuyu: state.canSuyu + tamamlananGorev.canSuyu,
      fideler: yeniFide,
      cicekler: yeniCicek,
      agaclar: yeniAgac,
      tamamlananGorevler: [
        ...state.tamamlananGorevler,
        TamamlanmisGorev(
          ad: tamamlananGorev.ad,
          tamamlanmaTarihi: DateTime.now(),
        ),
      ],
    );
    state = yeniState;
    await _verileriKaydet(yeniState); // Kaydetme fonksiyonunu çağır
  }

  Future<void> verileriSifirla() async {
    print('[KullaniciProvider] verileriSifirla çağrıldı.');
    if (_box == null || !_box!.isOpen) {
      print('[KullaniciProvider] HATA: Veri sıfırlanamadı, Hive kutusu kapalı veya başlatılamadı.');
      return;
    }
    try {
      await _box!.clear();
      print('[KullaniciProvider] Kullanıcı verileri kutusu temizlendi.');
      final initialData = KullaniciVerileri(id: _uuid.v4());
      state = initialData;
      await _verileriKaydet(initialData);
      print('[KullaniciProvider] Başlangıç verileri geri yüklendi ve kaydedildi.');
    } catch (e, s) { // Detaylı hata yakalama
      print('[KullaniciProvider] Veriler sıfırlanırken KRİTİK HATA oluştu: $e');
      print('Stack Trace: $s');
      state = KullaniciVerileri(id: _uuid.v4()); // Hata durumunda sıfırla
    }
  }

  @override
  void dispose() {
    print('[KullaniciProvider] Provider dispose ediliyor, Hive kutusu kapatılıyor.');
    _box?.close(); // Kutuyu kapat
    super.dispose();
  }
}




// 4. Bu, UI'ın (arayüzün) Notifier'ımıza erişmesini sağlayan Provider.
final kullaniciVerileriProvider =
StateNotifierProvider<KullaniciVerileriNotifier, KullaniciVerileri>((ref) {
  return KullaniciVerileriNotifier();
});