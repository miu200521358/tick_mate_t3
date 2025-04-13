import 'package:injectable/injectable.dart';
import 'package:tick_mate/config/app_config.dart';

@Named('prod')
@LazySingleton(as: AppConfig)
class ProdConfig implements AppConfig {
  @override
  String get baseUrl => 'https://api.tickmate.example.com';

  @override
  bool get isDebugMode => false;

  @override
  bool get showBetaBanner => false;

  @override
  String get apiVersion => 'v1';
}
