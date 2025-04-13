import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:tick_mate/data/datasources/local/hive_boxes.dart';
import 'package:tick_mate/data/models/user_setting_model.dart';
import 'package:tick_mate/domain/entities/user_setting_entity.dart';
import 'package:tick_mate/domain/repositories/user_setting_repository.dart';

@LazySingleton(as: UserSettingRepository)
class UserSettingRepositoryImpl implements UserSettingRepository {
  UserSettingRepositoryImpl()
    : _userSettingBox = Hive.box<UserSettingModel>(HiveBoxes.userSettingBox);

  final Box<UserSettingModel> _userSettingBox;

  @override
  Future<UserSettingEntity?> getUserSetting() async {
    if (_userSettingBox.isEmpty) {
      return null;
    }
    return _userSettingBox.values.first.toEntity();
  }

  @override
  Future<void> saveUserSetting(UserSettingEntity userSetting) async {
    final model = UserSettingModel.fromEntity(userSetting);
    await _userSettingBox.put(model.id, model);
  }

  @override
  Future<void> updateLanguage(String id, String? language) async {
    final userSetting = _userSettingBox.get(id);
    if (userSetting == null) {
      return;
    }

    final updatedUserSetting = UserSettingModel(
      id: userSetting.id,
      language: language,
      themeMode: userSetting.themeMode,
      createdAt: userSetting.createdAt,
      updatedAt: DateTime.now(),
    );

    await _userSettingBox.put(id, updatedUserSetting);
  }

  @override
  Future<void> updateThemeMode(String id, int themeMode) async {
    final userSetting = _userSettingBox.get(id);
    if (userSetting == null) {
      return;
    }

    final updatedUserSetting = UserSettingModel(
      id: userSetting.id,
      language: userSetting.language,
      themeMode: themeMode,
      createdAt: userSetting.createdAt,
      updatedAt: DateTime.now(),
    );

    await _userSettingBox.put(id, updatedUserSetting);
  }
}
