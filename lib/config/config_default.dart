import 'package:injectable/injectable.dart';
import 'package:tick_mate/config/app_config.dart';

/// デフォルト環境の設定
/// 環境が明示的に指定されていない場合に使用される設定
@LazySingleton(as: AppConfig)
class DefaultConfig implements AppConfig {
  @override
  String get baseUrl => 'https://dev.api.tickmate.example.com';

  @override
  bool get isDebugMode => true;

  @override
  bool get showBetaBanner => true;

  @override
  String get apiVersion => 'v1';
}
