// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sleep_session.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SleepSessionAdapter extends TypeAdapter<SleepSession> {
  @override
  final int typeId = 0;

  @override
  SleepSession read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SleepSession(
      id: fields[0] as String,
      startTime: fields[1] as DateTime,
      endTime: fields[2] as DateTime?,
      sleepScore: fields[3] as int,
      totalSnoreMinutes: fields[4] as int,
      snoreEventCount: fields[5] as int,
      averageNoiseDb: fields[6] as double,
      audioFilePath: fields[7] as String?,
      snoreEvents: (fields[8] as List).cast<SnoreEvent>(),
      calendarEventIds: (fields[9] as List).cast<String>(),
      sleepStages: (fields[10] as Map).cast<String, double>(),
      userNotes: fields[11] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, SleepSession obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.startTime)
      ..writeByte(2)
      ..write(obj.endTime)
      ..writeByte(3)
      ..write(obj.sleepScore)
      ..writeByte(4)
      ..write(obj.totalSnoreMinutes)
      ..writeByte(5)
      ..write(obj.snoreEventCount)
      ..writeByte(6)
      ..write(obj.averageNoiseDb)
      ..writeByte(7)
      ..write(obj.audioFilePath)
      ..writeByte(8)
      ..write(obj.snoreEvents)
      ..writeByte(9)
      ..write(obj.calendarEventIds)
      ..writeByte(10)
      ..write(obj.sleepStages)
      ..writeByte(11)
      ..write(obj.userNotes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SleepSessionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
