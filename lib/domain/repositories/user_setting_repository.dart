import '../entities/user_setting_entity.dart';

/// ユーザー設定リポジトリインターフェース
abstract class UserSettingRepository {
  /// ユーザー設定を取得
  Future<UserSettingEntity?> getUserSetting();

  /// ユーザー設定を保存
  Future<void> saveUserSetting(UserSettingEntity userSetting);

  /// 言語設定を更新
  Future<void> updateLanguage(String id, String? language);

  /// テーマモードを更新
  Future<void> updateThemeMode(String id, int themeMode);
}
