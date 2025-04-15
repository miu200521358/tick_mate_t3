// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timer_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TimerModelAdapter extends TypeAdapter<TimerModel> {
  @override
  final int typeId = 1;

  @override
  TimerModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TimerModel(
      id: fields[0] as String,
      title: fields[1] as String,
      timeSpecificationType: fields[2] as int,
      dateTime: fields[3] as DateTime?,
      startTimeOfDayHour: fields[4] as int?,
      startTimeOfDayMinute: fields[5] as int?,
      endTimeOfDayHour: fields[6] as int?,
      endTimeOfDayMinute: fields[7] as int?,
      timeRange: fields[8] as String?,
      timerType: fields[9] as int,
      repeatType: fields[10] as int,
      characterIds: (fields[11] as List).cast<String>(),
      notificationSound: fields[12] as String?,
      location: fields[13] as String?,
      useCurrentLocation: fields[14] as bool,
      createdAt: fields[15] as DateTime,
      updatedAt: fields[16] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, TimerModel obj) {
    writer
      ..writeByte(17)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.timeSpecificationType)
      ..writeByte(3)
      ..write(obj.dateTime)
      ..writeByte(4)
      ..write(obj.startTimeOfDayHour)
      ..writeByte(5)
      ..write(obj.startTimeOfDayMinute)
      ..writeByte(6)
      ..write(obj.endTimeOfDayHour)
      ..writeByte(7)
      ..write(obj.endTimeOfDayMinute)
      ..writeByte(8)
      ..write(obj.timeRange)
      ..writeByte(9)
      ..write(obj.timerType)
      ..writeByte(10)
      ..write(obj.repeatType)
      ..writeByte(11)
      ..write(obj.characterIds)
      ..writeByte(12)
      ..write(obj.notificationSound)
      ..writeByte(13)
      ..write(obj.location)
      ..writeByte(14)
      ..write(obj.useCurrentLocation)
      ..writeByte(15)
      ..write(obj.createdAt)
      ..writeByte(16)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimerModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
