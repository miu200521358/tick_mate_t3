import 'package:tick_mate/data/datasources/local/secure_storage_datasource.dart';
import 'package:tick_mate/data/datasources/remote/base_api_client.dart';

/// Gemini API用クライアント
class GeminiApiClient extends BaseApiClient {
  GeminiApiClient(super.httpClient, super.config, this._secureStorage);

  final SecureStorageDataSource _secureStorage;

  /// Gemini APIのベースURL
  static const String baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models';

  /// APIキーを取得してURLに付加
  Future<String> _getUrlWithApiKey(String endpoint) async {
    final apiKey = await _secureStorage.getGeminiApiKey();
    if (apiKey == null) {
      throw Exception('Gemini APIキーが設定されていません');
    }
    return '$baseUrl/$endpoint?key=$apiKey';
  }

  /// メッセージを生成
  Future<String> generateMessage({
    required String prompt,
    int maxTokens = 200,
  }) async {
    final url = await _getUrlWithApiKey('gemini-pro:generateContent');

    final response = await post(
      url,
      data: {
        'contents': [
          {
            'parts': [
              {'text': prompt},
            ],
          },
        ],
        'generationConfig': {'maxOutputTokens': maxTokens},
      },
    );

    return response['candidates'][0]['content']['parts'][0]['text'] as String;
  }

  /// テキストを翻訳
  Future<String> translateText({
    required String text,
    required String targetLanguage,
  }) async {
    final url = await _getUrlWithApiKey('gemini-pro:generateContent');

    final prompt = 'Translate the following text to $targetLanguage:\n\n$text';

    final response = await post(
      url,
      data: {
        'contents': [
          {
            'parts': [
              {'text': prompt},
            ],
          },
        ],
      },
    );

    return response['candidates'][0]['content']['parts'][0]['text'] as String;
  }
}
