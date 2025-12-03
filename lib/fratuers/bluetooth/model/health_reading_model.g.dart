// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_reading_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HealthReadingModelAdapter extends TypeAdapter<HealthReadingModel> {
  @override
  final int typeId = 0;

  @override
  HealthReadingModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HealthReadingModel(
      userId: fields[0] as String,
      timestamp: fields[1] as String,
      heartRate: fields[2] as int,
      oxygen: fields[3] as int,
      temperature: fields[4] as double,
      steps: fields[5] as int,
      lat: fields[6] as double,
      lon: fields[7] as double,
      position: fields[8] as int,
      sos: fields[9] as int,
      shake: fields[10] as int,
      isSynced: fields[11] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, HealthReadingModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.timestamp)
      ..writeByte(2)
      ..write(obj.heartRate)
      ..writeByte(3)
      ..write(obj.oxygen)
      ..writeByte(4)
      ..write(obj.temperature)
      ..writeByte(5)
      ..write(obj.steps)
      ..writeByte(6)
      ..write(obj.lat)
      ..writeByte(7)
      ..write(obj.lon)
      ..writeByte(8)
      ..write(obj.position)
      ..writeByte(9)
      ..write(obj.sos)
      ..writeByte(10)
      ..write(obj.shake)
      ..writeByte(11)
      ..write(obj.isSynced);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HealthReadingModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
