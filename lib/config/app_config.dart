import 'package:injectable/injectable.dart';

abstract class AppConfig {
  String get baseUrl;
  bool get isDebugMode;
  bool get showBetaBanner;
  String get apiVersion;
  // 他の環境依存設定があればここに追加
}
