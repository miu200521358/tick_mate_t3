// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'migration_info_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MigrationInfoModelAdapter extends TypeAdapter<MigrationInfoModel> {
  @override
  final int typeId = 7;

  @override
  MigrationInfoModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MigrationInfoModel(
      schemaVersion: fields[0] as int,
    );
  }

  @override
  void write(BinaryWriter writer, MigrationInfoModel obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.schemaVersion);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MigrationInfoModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
