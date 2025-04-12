import 'package:hive/hive.dart';
import 'package:tick_mate_t3/data/datasources/local/hive_boxes.dart';
import 'package:tick_mate_t3/data/models/timer_model.dart';

class TimerModelAdapter extends TypeAdapter<TimerModel> {
  @override
  final int typeId = HiveBoxes.timerTypeId;

  @override
  TimerModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TimerModel(
      id: fields[0] as String,
      title: fields[1] as String,
      dateTime: fields[2] as DateTime?,
      timeRange: fields[3] as String?,
      timerType: fields[4] as int,
      repeatType: fields[5] as int,
      characterIds: (fields[6] as List).cast<String>(),
      notificationSound: fields[7] as String?,
      location: fields[8] as String?,
      useCurrentLocation: fields[9] as bool,
      createdAt: fields[10] as DateTime,
      updatedAt: fields[11] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, TimerModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.dateTime)
      ..writeByte(3)
      ..write(obj.timeRange)
      ..writeByte(4)
      ..write(obj.timerType)
      ..writeByte(5)
      ..write(obj.repeatType)
      ..writeByte(6)
      ..write(obj.characterIds)
      ..writeByte(7)
      ..write(obj.notificationSound)
      ..writeByte(8)
      ..write(obj.location)
      ..writeByte(9)
      ..write(obj.useCurrentLocation)
      ..writeByte(10)
      ..write(obj.createdAt)
      ..writeByte(11)
      ..write(obj.updatedAt);
  }
}
