// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'snore_event.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SnoreEventAdapter extends TypeAdapter<SnoreEvent> {
  @override
  final int typeId = 1;

  @override
  SnoreEvent read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SnoreEvent(
      id: fields[0] as String,
      timestamp: fields[1] as DateTime,
      durationSeconds: fields[2] as int,
      peakDb: fields[3] as double,
      confidence: fields[4] as double,
    );
  }

  @override
  void write(BinaryWriter writer, SnoreEvent obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.timestamp)
      ..writeByte(2)
      ..write(obj.durationSeconds)
      ..writeByte(3)
      ..write(obj.peakDb)
      ..writeByte(4)
      ..write(obj.confidence);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SnoreEventAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
