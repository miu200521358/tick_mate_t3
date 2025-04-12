import 'package:tick_mate_t3/config/app_config.dart';

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
