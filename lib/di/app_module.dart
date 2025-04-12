import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'dart:math' show Random;

/// 外部ライブラリの依存関係を提供するモジュール
@module
abstract class AppModule {
  /// Dioインスタンスを提供
  @lazySingleton
  Dio get dio => Dio();

  /// FlutterSecureStorageインスタンスを提供
  @lazySingleton
  FlutterSecureStorage get secureStorage => const FlutterSecureStorage();

  /// Randomインスタンスを提供
  @lazySingleton
  Random get random => Random();
}
