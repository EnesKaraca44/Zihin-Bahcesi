
import 'package:hive/hive.dart';
import 'package:zihin_bahcesi/modeller/tamamlanmis_gorev.dart';

part 'kullanici_verileri.g.dart'; // Yardımcı dosya için satır

@HiveType(typeId: 1) // Farklı bir kimlik numarası (ID) veriyoruz (0'ı Gorev kullanıyor).
 class KullaniciVerileri {

  @HiveField(0)
   int tamamlananGorevSayisi;

  @HiveField(1)
   int canSuyu;

  @HiveField(2)
   int fideler;

  @HiveField(3)
  int cicekler;

  @HiveField(4)
  int agaclar;

  @HiveField(5)
   List<TamamlanmisGorev> tamamlananGorevler;

  @HiveField(6)
  bool sesAcik;

  @HiveField(7)
  bool bildirimlerAcik;
  @HiveField(8)
 String id;
  @HiveField(9) // Numarayı sıralı artır
  String kullaniciAdi;

  @HiveField(10) // Numarayı sıralı artır
  String bahceAdi;

  KullaniciVerileri({
    required this.id,
    this.tamamlananGorevSayisi = 0, // Varsayılan değer 0
    this.canSuyu = 0,               // Varsayılan değer 0
    this.fideler = 0,               // Varsayılan değer 0
    this.cicekler = 0,              // Varsayılan değer 0
    this.kullaniciAdi = "Enes Karaca"
        "", // <-- Varsayılan değer ekle
    this.bahceAdi = "Zihin Bahçem",
    this.agaclar = 0,               // Varsayılan değer 0
    List<TamamlanmisGorev>? tamamlananGorevler, // Nullable alıp aşağıda başlatıyoruz
    this.sesAcik = true,            // Varsayılan değer true
    this.bildirimlerAcik = true,   // Varsayılan değer true
  }) : this.tamamlananGorevler = tamamlananGorevler ?? []; // Boş liste ile başlatma

  // Bu, uygulamanın ilk açılışındaki başlangıç durumumuz olacak.
 /* KullaniciVerileri.initial(required this.id)
      : tamamlananGorevSayisi = 0,
        canSuyu = 0,
        fideler = 0,
        cicekler = 0,
        agaclar = 0,
        tamamlananGorevler = const [],
        sesAcik = true,
        bildirimlerAcik = true;*/



  // Bu metot, verileri güncellerken hayatımızı kolaylaştıracak.
  KullaniciVerileri copyWith({
    String? id,
    int? tamamlananGorevSayisi,
    int? canSuyu,
    int? fideler,
    int? cicekler,
    int? agaclar,
    List<TamamlanmisGorev>? tamamlananGorevler,
    bool? sesAcik, // <-- YENİ PARAMETRE
    bool? bildirimlerAcik,
    String? kullaniciAdi, // <-- Yeni parametre ekle
    String? bahceAdi,
  }) {
    return KullaniciVerileri(
      id: id ?? this.id,
      tamamlananGorevSayisi: tamamlananGorevSayisi ?? this.tamamlananGorevSayisi,
      canSuyu: canSuyu ?? this.canSuyu,
      fideler: fideler ?? this.fideler,
      cicekler: cicekler ?? this.cicekler,
      agaclar: agaclar ?? this.agaclar,
      tamamlananGorevler: tamamlananGorevler ?? this.tamamlananGorevler,
      sesAcik: sesAcik ?? this.sesAcik, // <-- ATAMA YAPILDI
      bildirimlerAcik: bildirimlerAcik ?? this.bildirimlerAcik,
      kullaniciAdi: kullaniciAdi ?? this.kullaniciAdi, // <-- Atama yap
      bahceAdi: bahceAdi ?? this.bahceAdi,
    );
  }
}