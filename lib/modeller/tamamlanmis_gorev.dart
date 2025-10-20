import 'package:hive/hive.dart';

part 'tamamlanmis_gorev.g.dart';

@HiveType(typeId: 2) // ID'lerimiz 0 ve 1'i kullanıyordu, bu yüzden 2'yi kullanıyoruz.
class TamamlanmisGorev {
  @HiveField(0)
  final String ad;

  @HiveField(1)
  final DateTime tamamlanmaTarihi;

  TamamlanmisGorev({
    required this.ad,
    required this.tamamlanmaTarihi,
  });
}