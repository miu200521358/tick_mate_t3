import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:tick_mate_t3/config/app_config.dart'; // 追加
import 'package:tick_mate_t3/config/config_dev.dart'; // 追加
import 'package:tick_mate_t3/config/config_prod.dart'; // 追加
import 'package:tick_mate_t3/config/config_stg.dart'; // 追加
import 'package:tick_mate_t3/presentation/bloc/app/app_bloc.dart';
import 'package:tick_mate_t3/presentation/bloc/app/app_event.dart';
import 'package:tick_mate_t3/presentation/screens/home/home_screen.dart';

final getIt = GetIt.instance; // 追加

void main() {
  // 環境設定の読み込みと登録
  const String environment = String.fromEnvironment(
    'ENV',
    defaultValue: 'dev',
  ); // 追加
  _setupConfig(environment); // 追加

  runApp(const MyApp());
}

// 設定登録用の関数を追加
void _setupConfig(String environment) {
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
  // get_it にシングルトンとして登録
  getIt.registerSingleton<AppConfig>(config);
  // ignore: avoid_print
  print(
    'Initialized with environment: $environment, baseUrl: ${config.baseUrl}',
  ); // 確認用ログ
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
