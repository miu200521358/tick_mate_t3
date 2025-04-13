import 'package:hive/hive.dart';
import 'package:tick_mate/data/datasources/local/hive_boxes.dart';
import 'package:tick_mate/data/models/subscription_model.dart';

class SubscriptionModelAdapter extends TypeAdapter<SubscriptionModel> {
  @override
  final int typeId = HiveBoxes.subscriptionTypeId;

  @override
  SubscriptionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SubscriptionModel(
      id: fields[0] as String,
      planType: fields[1] as int,
      additionalTimerCount: fields[2] as int,
      expiryDate: fields[3] as DateTime?,
      userId: fields[4] as String,
      createdAt: fields[5] as DateTime,
      updatedAt: fields[6] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, SubscriptionModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.planType)
      ..writeByte(2)
      ..write(obj.additionalTimerCount)
      ..writeByte(3)
      ..write(obj.expiryDate)
      ..writeByte(4)
      ..write(obj.userId)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.updatedAt);
  }
}
