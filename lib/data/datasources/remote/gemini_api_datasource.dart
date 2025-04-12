import 'package:injectable/injectable.dart';
import 'package:tick_mate_t3/data/datasources/remote/gemini_api_client.dart';

/// Gemini API データソース
@lazySingleton
class GeminiApiDataSource {
  final GeminiApiClient _apiClient;

  GeminiApiDataSource(this._apiClient);

  /// メッセージを生成
  Future<String> generateMessage({
    required String prompt,
    int maxTokens = 200,
  }) async {
    return await _apiClient.generateMessage(
      prompt: prompt,
      maxTokens: maxTokens,
    );
  }

  /// テキストを翻訳
  Future<String> translateText({
    required String text,
    required String targetLanguage,
  }) async {
    return await _apiClient.translateText(
      text: text,
      targetLanguage: targetLanguage,
    );
  }
}
