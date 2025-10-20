import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';


part 'gorev.g.dart';

@HiveType(typeId: 0) // Hive'a bu sınıfı tanıması için bir kimlik numarası (ID) veriyoruz.
class Gorev{
  @HiveField(0) // Her alana benzersiz bir numara veriyoruz.
  late String ad;

  @HiveField(1)
  late  String kategori;

  @HiveField(2)
  late String sure;

  @HiveField(3)
  late int canSuyu;

// IconData Hive tarafından direkt olarak kaydedilemez.
  // Bu yüzden ikonu, kaydedilebilen bir string'e (kod noktasına) çevirip saklayacağız.
  @HiveField(4)
  late int ikonKodu;

  @HiveField(5)
  String? ikonFontAilesi;

  @HiveField(6)
  late String id;

  @HiveField(7)
  late bool isCustom;

   Gorev({
    required this.ad,
    required this.kategori,
    required this.sure,
    required this.canSuyu,
    required this.ikonKodu,
     this.ikonFontAilesi,
    required this.id,
    required this.isCustom,
  }) ;

  // Getter hala IconData döndürüyor, böylece uygulamada kullanım kolaylığı devam ediyor.
  IconData get ikon => IconData(ikonKodu, fontFamily: ikonFontAilesi ?? 'MaterialIcons');
}