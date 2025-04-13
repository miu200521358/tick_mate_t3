// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_setting_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserSettingModelAdapter extends TypeAdapter<UserSettingModel> {
  @override
  final int typeId = 6;

  @override
  UserSettingModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserSettingModel(
      id: fields[0] as String,
      language: fields[1] as String?,
      themeMode: fields[2] as int?,
      createdAt: fields[3] as DateTime,
      updatedAt: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, UserSettingModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.language)
      ..writeByte(2)
      ..write(obj.themeMode)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserSettingModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
