import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

/// セキュアストレージデータソース
@lazySingleton
class SecureStorageDataSource {
  final FlutterSecureStorage _secureStorage;

  /// セキュアストレージキー
  static const String geminiApiKey = 'gemini_api_key';

  SecureStorageDataSource(this._secureStorage);

  /// Gemini APIキーを保存
  Future<void> saveGeminiApiKey(String apiKey) async {
    await _secureStorage.write(key: geminiApiKey, value: apiKey);
  }

  /// Gemini APIキーを取得
  Future<String?> getGeminiApiKey() async {
    return await _secureStorage.read(key: geminiApiKey);
  }

  /// Gemini APIキーを削除
  Future<void> deleteGeminiApiKey() async {
    await _secureStorage.delete(key: geminiApiKey);
  }
}
