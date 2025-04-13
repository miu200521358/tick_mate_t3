import 'package:injectable/injectable.dart';
import 'package:tick_mate/config/app_config.dart';

@Named('stg')
@LazySingleton(as: AppConfig)
class StgConfig implements AppConfig {
  @override
  String get baseUrl => 'https://stg.api.tickmate.example.com';

  @override
  bool get isDebugMode => false;

  @override
  bool get showBetaBanner => true;

  @override
  String get apiVersion => 'v1';
}
