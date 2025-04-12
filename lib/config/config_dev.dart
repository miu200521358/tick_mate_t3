import 'package:injectable/injectable.dart';
import 'package:tick_mate_t3/config/app_config.dart';

@Named('dev')
@LazySingleton(as: AppConfig)
class DevConfig implements AppConfig {
  @override
  String get baseUrl => 'https://dev.api.tickmate.example.com';

  @override
  bool get isDebugMode => true;

  @override
  bool get showBetaBanner => true;

  @override
  String get apiVersion => 'v1';
}
