import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'injection.config.dart';

/// アプリケーション全体で使用するDIコンテナ
final GetIt getIt = GetIt.instance;

/// DIコンテナを初期化する
@injectableInit
void configureDependencies() => getIt.init();
