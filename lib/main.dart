import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:tick_mate_t3/config/app_config.dart';
import 'package:tick_mate_t3/config/config_dev.dart';
import 'package:tick_mate_t3/config/config_prod.dart';
import 'package:tick_mate_t3/config/config_stg.dart';
import 'package:tick_mate_t3/core/constants/app_constants.dart';
import 'package:tick_mate_t3/presentation/bloc/app/app_bloc.dart';
import 'package:tick_mate_t3/presentation/bloc/app/app_event.dart';
import 'package:tick_mate_t3/presentation/screens/home/home_screen.dart';

final getIt = GetIt.instance;

void main() async {
  // Flutter Widgetの初期化を確実に
  WidgetsFlutterBinding.ensureInitialized();

  // .envファイルの読み込み
  await dotenv.load(fileName: '.env');

  // 環境設定の読み込みと登録
  _setupConfig();

  runApp(const MyApp());
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
  getIt.registerSingleton<AppConfig>(config);

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
    return BlocProvider(
      create: (context) => AppBloc()..add(const AppStarted()),
      child: MaterialApp(
        title: 'Tick Mate',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // TRY THIS: Try running your application with "flutter run". You'll see
          // the application has a purple toolbar. Then, without quitting the app,
          // try changing the seedColor in the colorScheme below to Colors.green
          // and then invoke "hot reload" (save your changes or press the "hot
          // reload" button in a Flutter-supported IDE, or press "r" if you used
          // the command line to start the app).
          //
          // Notice that the counter didn't reset back to zero; the application
          // state is not lost during the reload. To reset the state, use hot
          // restart instead.
          //
          // This works for code too, not just values: Most code changes can be
          // tested with just a hot reload.
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
