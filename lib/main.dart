import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tick_mate/config/app_config.dart';
import 'package:tick_mate/config/config_dev.dart';
import 'package:tick_mate/config/config_prod.dart';
import 'package:tick_mate/config/config_stg.dart';
import 'package:tick_mate/core/constants/app_constants.dart'; // Moved up
import 'package:tick_mate/core/error/exceptions.dart';
import 'package:tick_mate/core/services/migration_service.dart';
import 'package:tick_mate/core/services/notification_service.dart';
import 'package:tick_mate/core/utils/dummy_data_utils.dart';
import 'package:tick_mate/data/hive_init.dart';
import 'package:tick_mate/di/injection.dart';
import 'package:tick_mate/domain/usecases/notification/create_notification_usecase.dart';
import 'package:tick_mate/domain/usecases/timer/create_timer_usecase.dart';
import 'package:tick_mate/domain/usecases/timer/get_timers_usecase.dart';
import 'package:tick_mate/firebase_options.dart';
import 'package:tick_mate/gen/l10n/app_localizations.dart';
import 'package:tick_mate/presentation/bloc/app/app_bloc.dart';
import 'package:tick_mate/presentation/bloc/app/app_event.dart';
import 'package:tick_mate/presentation/bloc/settings/settings_bloc.dart';
import 'package:tick_mate/presentation/bloc/timer/timer_bloc.dart';
import 'package:tick_mate/presentation/bloc/timer/timer_event.dart';
import 'package:tick_mate/presentation/screens/home/home_screen.dart';
// Settings screen is imported in home_screen.dart

void main() async {
  // Flutter Widgetの初期化を確実に
  WidgetsFlutterBinding.ensureInitialized();

  // 環境に応じた.envファイルの読み込み
  String envFile = '.env';
  // コマンドラインフラグからflavor/環境を取得（flutter run --flavor dev など）
  const flavor = String.fromEnvironment('FLAVOR', defaultValue: 'dev');

  // flavorに応じた環境設定ファイルをロード
  if (flavor.isNotEmpty) {
    envFile = '.env.$flavor';
  }

  // 環境設定ファイルの読み込み
  try {
    await dotenv.load(fileName: envFile);
    debugPrint('環境設定ファイルを読み込みました: $envFile');
  } catch (e) {
    debugPrint('環境設定ファイルの読み込みに失敗しました: $e');
    debugPrint('環境: $flavor, ファイル: $envFile を読み込めませんでした');

    // pubspec.yamlにアセットが正しく登録されているか確認するメッセージ
    debugPrint('注意: pubspec.yamlのassetsセクションに "$envFile" が登録されていることを確認してください');

    // フォールバックとして.envを試す
    try {
      await dotenv.load(fileName: '.env');
      debugPrint('フォールバック設定ファイルを読み込みました: .env');
    } catch (e) {
      debugPrint('フォールバック設定ファイルの読み込みにも失敗しました: $e');
      debugPrint('すべての環境設定ファイルの読み込みに失敗しました。デフォルト値を使用します。');
    }
  }

  // Firebaseの初期化
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Firebase Analyticsの初期化
  FirebaseAnalytics.instance; // インスタンスを初期化

  // 依存性注入の設定
  configureDependencies();

  // 環境設定の読み込みと登録 - Crashlyticsの初期化前に必須
  _setupConfig();

  // AppConfigが確実に登録されていることを確認
  if (!getIt.isRegistered<AppConfig>()) {
    debugPrint('[ERROR] AppConfigが登録されていません。Crashlyticsの初期化に失敗する可能性があります。');
    // デフォルト設定を登録して続行を試みる
    getIt.registerSingleton<AppConfig>(DevConfig());
  }

  // Firebase Crashlyticsの初期化と設定
  await _initializeCrashlytics();

  // Hiveの初期化
  try {
    await HiveInit.initialize();
    debugPrint('Hive初期化処理が完了しました');
  } catch (e) {
    debugPrint('Hive初期化中にエラーが発生しました: $e');
    // アプリケーションの継続は可能とする（重大なエラーではない）
  }

  // 通知サービスの手動登録
  if (!getIt.isRegistered<NotificationService>()) {
    // --- マイグレーションチェックの実行 --- (追加)
    try {
      // DIコンテナからMigrationServiceを取得する前に、登録されているか確認
      if (getIt.isRegistered<MigrationService>()) {
        final migrationService = getIt<MigrationService>();
        await migrationService.runMigrations();
        debugPrint('データベースマイグレーションチェックが完了しました');
      } else {
        debugPrint('MigrationServiceがDIコンテナに登録されていません。スキップします。');
        // 必要であれば、ここでエラーを記録または通知
      }
    } catch (e, stackTrace) {
      debugPrint('データベースマイグレーション中にエラーが発生しました: $e');
      debugPrint('StackTrace: $stackTrace');
      // マイグレーション失敗時のエラーハンドリング（必要に応じて）
      // 例えば、アプリを起動せずにエラー表示するなど
      // ここではログ出力とCrashlyticsへの記録
      final exception = CacheException('データベースマイグレーション失敗: $e', stackTrace);
      await exception.recordToCrashlytics(fatal: true); // マイグレーション失敗は致命的とする場合
      // アプリの起動を中止するなどの処理が必要な場合もある
      // return; // 例: ここでmain関数を終了させる
    }
    // --- マイグレーションチェックここまで ---

    getIt.registerLazySingleton<NotificationService>(
      () => NotificationService(getIt<CreateNotificationUseCase>()),
    );
  }

  // 通知サービスの初期化
  await _initializeNotifications();

  // ダミーデータの作成
  await _createDummyData();

  // アプリをrunZonedGuardedでラップして、非同期エラーもキャッチする
  // WidgetsFlutterBinding.ensureInitializedと同じゾーンでrunAppを実行するために
  // 同期的に実行する
  runApp(const MyApp());

  // 非同期エラーのキャッチは別途設定
  FlutterError.onError = (FlutterErrorDetails details) {
    debugPrint('FlutterError: ${details.exception}');
    FirebaseCrashlytics.instance.recordFlutterError(details);
  };
}

// Crashlytics初期化用の関数
Future<void> _initializeCrashlytics() async {
  try {
    // AppConfigが登録されているか確認
    if (!getIt.isRegistered<AppConfig>()) {
      // 初期化時はBuildContextがないため、多言語対応は後で行い、ここではシンプルなメッセージを使用
      throw Exception(
        'AppConfig is not registered. Please run _setupConfig() first.',
      );
    }

    // Crashlyticsの初期化
    final crashlytics = FirebaseCrashlytics.instance;
    final config = getIt<AppConfig>();

    // 環境変数を取得して、devフレーバーの場合でもCrashlyticsを有効にする
    const flavor = String.fromEnvironment('FLAVOR', defaultValue: 'dev');

    // devフレーバーでも常にCrashlyticsを有効にする
    if (flavor == 'dev') {
      await crashlytics.setCrashlyticsCollectionEnabled(true);
      debugPrint('Dev環境: Crashlyticsを常に有効化しました');
    } else {
      // 他の環境では従来通りdebugModeに基づいて制御
      await crashlytics.setCrashlyticsCollectionEnabled(!config.isDebugMode);
    }

    // Flutterフレームワークのエラーをキャッチして報告
    FlutterError.onError = (FlutterErrorDetails details) {
      debugPrint('FlutterError: ${details.exception}');
      crashlytics.recordFlutterError(details);
    };

    // Platformチャネルのエラーをキャッチして報告
    WidgetsBinding.instance.platformDispatcher.onError = (error, stack) {
      debugPrint('PlatformDispatcher Error: $error');
      crashlytics.recordError(error, stack, fatal: true);
      return true;
    };

    debugPrint('Crashlytics初期化完了');
  } catch (e, stack) {
    // エラーレベルでログを出力
    debugPrint('[ERROR] Crashlytics初期化エラー: $e');
    debugPrint('  StackTrace: $stack');
  }
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

// ダミーデータ作成用の関数
Future<void> _createDummyData() async {
  try {
    final dummyDataUtils = getIt<DummyDataUtils>();
    await dummyDataUtils.createDummyData();
    debugPrint('ダミーデータ作成完了');
  } catch (e) {
    debugPrint('ダミーデータ作成エラー: $e');
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

  // ログ出力を改善して、新しい設定項目も表示
  debugPrint(
    'Initialized with environment: $environment\n'
    'baseUrl: ${config.baseUrl}\n'
    'debug: ${config.isDebugMode}\n'
    'betaBanner: ${config.showBetaBanner}\n'
    'maxImageSize: ${config.maxImageSizeKB}KB\n'
    'apiRateLimit: ${config.apiRateLimitPerMinute}/min',
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
      // BlocBuilder removed as theme is now handled by system setting
      child: MaterialApp(
        title: 'Tick Mate', // This will be localized later where needed
        // Add localization settings
        localizationsDelegates: [
          // Removed const
          AppLocalizations.delegate, // Generated delegate
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales:
            AppLocalizations.supportedLocales, // Generated supported locales
        // End localization settings
        theme: ThemeData(
          useMaterial3: true, // Enable Material 3
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.cyan,
            brightness: Brightness.light, // Explicitly light
          ),
          fontFamily: GoogleFonts.notoSansJp().fontFamily,
          textTheme: GoogleFonts.notoSansJpTextTheme(
            ThemeData(
              brightness: Brightness.light,
            ).textTheme, // Base light text theme
          ),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: Colors.white, // Example dark background
            selectedItemColor:
                Colors.grey[800], // Example selected icon/text color
            unselectedItemColor:
                Colors.grey[400], // Example unselected icon/text color
            type: BottomNavigationBarType.fixed, // Ensure type is set if needed
          ),
        ),
        darkTheme: ThemeData(
          useMaterial3: true, // Enable Material 3
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.cyan,
            brightness: Brightness.dark, // Explicitly dark
          ),
          fontFamily: GoogleFonts.notoSansJp().fontFamily,
          textTheme: GoogleFonts.notoSansJpTextTheme(
            ThemeData(
              brightness: Brightness.dark,
            ).textTheme, // Base dark text theme
          ),
          // Add specific theme for BottomNavigationBar in dark mode
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: Colors.grey[900], // Example dark background
            selectedItemColor: Colors.white, // Example selected icon/text color
            unselectedItemColor:
                Colors.grey[400], // Example unselected icon/text color
            type: BottomNavigationBarType.fixed, // Ensure type is set if needed
          ),
        ),
        themeMode: ThemeMode.system, // Follow system setting
        home: const HomeScreen(),
      ),
    );
  }
}
