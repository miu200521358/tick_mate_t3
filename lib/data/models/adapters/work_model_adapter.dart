import 'package:hive/hive.dart';
import 'package:tick_mate_t3/data/datasources/local/hive_boxes.dart';
import 'package:tick_mate_t3/data/models/work_model.dart';

class WorkModelAdapter extends TypeAdapter<WorkModel> {
  @override
  final int typeId = HiveBoxes.workTypeId;

  @override
  WorkModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WorkModel(
      id: fields[0] as String,
      title: fields[1] as String,
      terms: (fields[2] as Map).cast<String, String>(),
      createdAt: fields[3] as DateTime,
      updatedAt: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, WorkModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.terms)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.updatedAt);
  }
}
