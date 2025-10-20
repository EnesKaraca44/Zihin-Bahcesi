// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tamamlanmis_gorev.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TamamlanmisGorevAdapter extends TypeAdapter<TamamlanmisGorev> {
  @override
  final int typeId = 2;

  @override
  TamamlanmisGorev read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TamamlanmisGorev(
      ad: fields[0] as String,
      tamamlanmaTarihi: fields[1] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, TamamlanmisGorev obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.ad)
      ..writeByte(1)
      ..write(obj.tamamlanmaTarihi);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TamamlanmisGorevAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
