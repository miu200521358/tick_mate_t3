import 'package:hive/hive.dart';
import 'package:tick_mate_t3/data/datasources/local/hive_boxes.dart';
import 'package:tick_mate_t3/data/models/character_model.dart';

class CharacterModelAdapter extends TypeAdapter<CharacterModel> {
  @override
  final int typeId = HiveBoxes.characterTypeId;

  @override
  CharacterModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CharacterModel(
      id: fields[0] as String,
      name: fields[1] as String,
      workId: fields[2] as String,
      promptText: fields[3] as String,
      parameters: (fields[4] as Map).cast<String, dynamic>(),
      createdAt: fields[5] as DateTime,
      updatedAt: fields[6] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, CharacterModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.workId)
      ..writeByte(3)
      ..write(obj.promptText)
      ..writeByte(4)
      ..write(obj.parameters)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.updatedAt);
  }
}
