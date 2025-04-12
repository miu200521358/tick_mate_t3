import 'package:hive/hive.dart';
import 'package:tick_mate_t3/data/datasources/local/hive_boxes.dart';
import 'package:tick_mate_t3/data/models/notification_history_model.dart';

class NotificationHistoryModelAdapter
    extends TypeAdapter<NotificationHistoryModel> {
  @override
  final int typeId = HiveBoxes.notificationHistoryTypeId;

  @override
  NotificationHistoryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NotificationHistoryModel(
      id: fields[0] as String,
      timerId: fields[1] as String,
      characterId: fields[2] as String,
      message: fields[3] as String,
      notificationTime: fields[4] as DateTime,
      createdAt: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, NotificationHistoryModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.timerId)
      ..writeByte(2)
      ..write(obj.characterId)
      ..writeByte(3)
      ..write(obj.message)
      ..writeByte(4)
      ..write(obj.notificationTime)
      ..writeByte(5)
      ..write(obj.createdAt);
  }
}
