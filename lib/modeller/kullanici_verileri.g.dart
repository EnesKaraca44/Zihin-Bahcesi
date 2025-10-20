// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kullanici_verileri.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class KullaniciVerileriAdapter extends TypeAdapter<KullaniciVerileri> {
  @override
  final int typeId = 1;

  @override
  KullaniciVerileri read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return KullaniciVerileri(
      id: fields[8] as String,
      tamamlananGorevSayisi: fields[0] as int,
      canSuyu: fields[1] as int,
      fideler: fields[2] as int,
      cicekler: fields[3] as int,
      kullaniciAdi: fields[9] as String,
      bahceAdi: fields[10] as String,
      agaclar: fields[4] as int,
      tamamlananGorevler: (fields[5] as List?)?.cast<TamamlanmisGorev>(),
      sesAcik: fields[6] as bool,
      bildirimlerAcik: fields[7] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, KullaniciVerileri obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.tamamlananGorevSayisi)
      ..writeByte(1)
      ..write(obj.canSuyu)
      ..writeByte(2)
      ..write(obj.fideler)
      ..writeByte(3)
      ..write(obj.cicekler)
      ..writeByte(4)
      ..write(obj.agaclar)
      ..writeByte(5)
      ..write(obj.tamamlananGorevler)
      ..writeByte(6)
      ..write(obj.sesAcik)
      ..writeByte(7)
      ..write(obj.bildirimlerAcik)
      ..writeByte(8)
      ..write(obj.id)
      ..writeByte(9)
      ..write(obj.kullaniciAdi)
      ..writeByte(10)
      ..write(obj.bahceAdi);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KullaniciVerileriAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
