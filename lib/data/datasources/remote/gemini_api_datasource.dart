import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:tick_mate_t3/data/datasources/local/secure_storage_datasource.dart';

/// Gemini API データソース
@lazySingleton
class GeminiApiDataSource {
  final Dio _dio;
  final SecureStorageDataSource _secureStorage;

  GeminiApiDataSource(this._dio, this._secureStorage);

  /// Gemini APIのベースURL
  static const String baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models';

  /// メッセージを生成
  Future<String> generateMessage({
    required String prompt,
    int maxTokens = 200,
  }) async {
    final apiKey = await _secureStorage.getGeminiApiKey();
    if (apiKey == null) {
      throw Exception('Gemini APIキーが設定されていません');
    }

    final response = await _dio.post(
      '$baseUrl/gemini-pro:generateContent?key=$apiKey',
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

    if (response.statusCode == 200) {
      final data = response.data;
      return data['candidates'][0]['content']['parts'][0]['text'] as String;
    } else {
      throw Exception('メッセージ生成に失敗しました: ${response.statusCode}');
    }
  }

  /// テキストを翻訳
  Future<String> translateText({
    required String text,
    required String targetLanguage,
  }) async {
    final apiKey = await _secureStorage.getGeminiApiKey();
    if (apiKey == null) {
      throw Exception('Gemini APIキーが設定されていません');
    }

    final prompt = 'Translate the following text to $targetLanguage:\n\n$text';

    final response = await _dio.post(
      '$baseUrl/gemini-pro:generateContent?key=$apiKey',
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

    if (response.statusCode == 200) {
      final data = response.data;
      return data['candidates'][0]['content']['parts'][0]['text'] as String;
    } else {
      throw Exception('翻訳に失敗しました: ${response.statusCode}');
    }
  }
}
