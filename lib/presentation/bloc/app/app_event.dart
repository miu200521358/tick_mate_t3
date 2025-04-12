import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// アプリBLoCのイベント基底クラス
abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object?> get props => [];
}

/// アプリ起動イベント
class AppStarted extends AppEvent {
  const AppStarted();
}

/// テーマ変更イベント
class ThemeChanged extends AppEvent {
  final bool isDarkMode;

  const ThemeChanged({required this.isDarkMode});

  @override
  List<Object?> get props => [isDarkMode];
}

/// 言語変更イベント
class LanguageChanged extends AppEvent {
  final Locale locale;

  const LanguageChanged({required this.locale});

  @override
  List<Object?> get props => [locale];
}
