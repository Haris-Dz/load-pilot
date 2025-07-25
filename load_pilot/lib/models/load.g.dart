// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'load.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LoadAdapter extends TypeAdapter<Load> {
  @override
  final int typeId = 0;

  @override
  Load read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Load(
      truckNumber: fields[0] as String,
      notes: fields[1] as String?,
      alertShown: fields[2] as bool,
      colorValue: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Load obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.truckNumber)
      ..writeByte(1)
      ..write(obj.notes)
      ..writeByte(2)
      ..write(obj.alertShown)
      ..writeByte(3)
      ..write(obj.colorValue);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoadAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
