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
  final bool isDarkMode;
  final Locale locale;

  const AppReady({
    this.isDarkMode = false,
    this.locale = const Locale('ja', 'JP'),
  });

  AppReady copyWith({bool? isDarkMode, Locale? locale}) {
    return AppReady(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      locale: locale ?? this.locale,
    );
  }

  @override
  List<Object?> get props => [isDarkMode, locale];
}
