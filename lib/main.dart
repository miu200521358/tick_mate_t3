import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tick_mate_t3/config/app_config.dart';
import 'package:tick_mate_t3/config/config_dev.dart';
import 'package:tick_mate_t3/config/config_prod.dart';
import 'package:tick_mate_t3/config/config_stg.dart';
import 'package:tick_mate_t3/core/constants/app_constants.dart';
import 'package:tick_mate_t3/core/services/notification_service.dart';
import 'package:tick_mate_t3/data/hive_init.dart';
import 'package:tick_mate_t3/di/injection.dart';
import 'package:tick_mate_t3/domain/usecases/timer/create_timer_usecase.dart';
import 'package:tick_mate_t3/domain/usecases/timer/get_timers_usecase.dart';
import 'package:tick_mate_t3/presentation/bloc/app/app_bloc.dart';
import 'package:tick_mate_t3/presentation/bloc/app/app_event.dart';
import 'package:tick_mate_t3/presentation/bloc/app/app_state.dart';
import 'package:tick_mate_t3/presentation/bloc/settings/settings_bloc.dart';
import 'package:tick_mate_t3/presentation/bloc/timer/timer_bloc.dart';
import 'package:tick_mate_t3/presentation/bloc/timer/timer_event.dart';
import 'package:tick_mate_t3/presentation/screens/home/home_screen.dart';
// Settings screen is imported in home_screen.dart

void main() async {
  // Flutter Widgetの初期化を確実に
  WidgetsFlutterBinding.ensureInitialized();

  // .envファイルの読み込み
  await dotenv.load(fileName: '.env');

  // Hiveの初期化
  await HiveInit.initialize();

  // 依存性注入の設定
  configureDependencies();

  // 環境設定の読み込みと登録
  _setupConfig();

  // 通知サービスの初期化
  await _initializeNotifications();

  runApp(const MyApp());
}

// 通知初期化用の関数
Future<void> _initializeNotifications() async {
  try {
    final notificationService = getIt<NotificationService>();
    await notificationService.initialize();
    await notificationService.requestPermission();
    debugPrint('通知サービス初期化完了');
  } catch (e) {
    debugPrint('通知サービス初期化エラー: $e');
  }
}

// 設定登録用の関数を更新
void _setupConfig() {
  // 環境変数から環境を取得（.envファイルまたはプラットフォーム環境変数）
  final String environment =
      dotenv.env[AppConstants.ENV_KEY] ??
      const String.fromEnvironment(AppConstants.ENV_KEY, defaultValue: 'dev');

  late AppConfig config;
  switch (environment) {
    case 'prod':
      config = ProdConfig();
      break;
    case 'stg':
      config = StgConfig();
      break;
    case 'dev':
    default:
      config = DevConfig();
      break;
  }

  // .envファイルの値で設定を上書きすることも可能
  // ただし、実際の実装では、APIキーなどのセキュアな値は
  // flutter_secure_storageを使用することを推奨

  // get_it にシングルトンとして登録
  // AppConfigが既に登録されているかチェック
  if (!getIt.isRegistered<AppConfig>()) {
    getIt.registerSingleton<AppConfig>(config);
  } else {
    // 既存の登録を上書き
    getIt.unregister<AppConfig>();
    getIt.registerSingleton<AppConfig>(config);
  }

  // ignore: avoid_print
  print(
    'Initialized with environment: $environment, baseUrl: ${config.baseUrl}, '
    'debug: ${config.isDebugMode}, betaBanner: ${config.showBetaBanner}',
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AppBloc()..add(const AppStarted())),
        BlocProvider(
          create:
              (context) => TimerBloc(
                getTimersUseCase: getIt<GetTimersUseCase>(),
                createTimerUseCase: getIt<CreateTimerUseCase>(),
              )..add(const TimersLoaded()),
        ),
        BlocProvider(create: (context) => SettingsBloc(getIt(), getIt())),
      ],
      child: BlocBuilder<AppBloc, AppState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'Tick Mate',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            ),
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
