// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gorev.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GorevAdapter extends TypeAdapter<Gorev> {
  @override
  final int typeId = 0;

  @override
  Gorev read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Gorev(
      ad: fields[0] as String,
      kategori: fields[1] as String,
      sure: fields[2] as String,
      canSuyu: fields[3] as int,
      ikonKodu: fields[4] as int,
      ikonFontAilesi: fields[5] as String?,
      id: fields[6] as String,
      isCustom: fields[7] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Gorev obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.ad)
      ..writeByte(1)
      ..write(obj.kategori)
      ..writeByte(2)
      ..write(obj.sure)
      ..writeByte(3)
      ..write(obj.canSuyu)
      ..writeByte(4)
      ..write(obj.ikonKodu)
      ..writeByte(5)
      ..write(obj.ikonFontAilesi)
      ..writeByte(6)
      ..write(obj.id)
      ..writeByte(7)
      ..write(obj.isCustom);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GorevAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
