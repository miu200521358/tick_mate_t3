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
  const ThemeChanged({required this.isDarkMode});

  final bool isDarkMode;

  @override
  List<Object?> get props => [isDarkMode];
}

/// 言語変更イベント
class LanguageChanged extends AppEvent {
  const LanguageChanged({required this.locale});

  final Locale locale;

  @override
  List<Object?> get props => [locale];
}
