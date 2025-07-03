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
      driverName: fields[0] as String,
      pickupLocation: fields[1] as String,
      pickupTime: fields[2] as DateTime,
      status: fields[3] as String,
      trackingAccepted: fields[4] as bool,
      notes: fields[5] as String,
      alertShown: fields[6] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Load obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.driverName)
      ..writeByte(1)
      ..write(obj.pickupLocation)
      ..writeByte(2)
      ..write(obj.pickupTime)
      ..writeByte(3)
      ..write(obj.status)
      ..writeByte(4)
      ..write(obj.trackingAccepted)
      ..writeByte(5)
      ..write(obj.notes)
      ..writeByte(6)
      ..write(obj.alertShown);
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
