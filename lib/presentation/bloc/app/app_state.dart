import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// アプリBLoCの状態基底クラス
abstract class AppState extends Equatable {
  const AppState();

  @override
  List<Object?> get props => [];
}

/// アプリ初期状態
class AppInitial extends AppState {
  const AppInitial();
}

/// アプリ準備完了状態
class AppReady extends AppState {
  const AppReady({
    // isDarkMode removed
    this.locale = const Locale('ja', 'JP'),
  });

  // isDarkMode removed
  final Locale locale;

  AppReady copyWith({/* bool? isDarkMode, */ Locale? locale}) {
    // isDarkMode parameter removed
    return AppReady(
      // isDarkMode removed
      locale: locale ?? this.locale,
    );
  }

  @override
  List<Object?> get props => [locale]; // isDarkMode removed from props
}
