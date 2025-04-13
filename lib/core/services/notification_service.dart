import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:tick_mate_t3/core/constants/app_constants.dart';
import 'package:tick_mate_t3/domain/entities/notification_history_entity.dart';
import 'package:tick_mate_t3/domain/usecases/notification/create_notification_usecase.dart';

/// 通知サービス
/// ローカル通知の送信、スケジュール、キャンセルなどを管理する
@lazySingleton
class NotificationService {
  NotificationService(this._createNotificationUseCase);

  final CreateNotificationUseCase _createNotificationUseCase;
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  /// 通知サービスを初期化する
  Future<void> initialize() async {
    if (_isInitialized) {
      return;
    }

    // タイムゾーンを初期化
    tz.initializeTimeZones();

    // Android設定
    const androidSettings = AndroidInitializationSettings(
      AppConstants.NOTIFICATION_ICON,
    );

    // iOS設定
    final iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: _onDidReceiveLocalNotification,
    );

    // 初期化設定
    final initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    // 初期化と通知タップ時のハンドラー設定
    await _notificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    _isInitialized = true;
  }

  /// iOS用：通知受信時のハンドラー（古いiOSバージョン用）
  void _onDidReceiveLocalNotification(
    int id,
    String? title,
    String? body,
    String? payload,
  ) {
    // 必要に応じてiOS固有の処理をここに実装
  }

  /// 通知タップ時のハンドラー
  void _onNotificationTapped(NotificationResponse response) {
    // 通知タップ時の処理をここに実装
    // 例：特定の画面への遷移、アクション実行など
  }

  /// 通知権限をリクエストする
  Future<bool> requestPermission() async {
    if (Platform.isIOS) {
      final result = await _notificationsPlugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);
      return result ?? false;
    } else if (Platform.isAndroid) {
      final result =
          await _notificationsPlugin
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >()
              ?.requestPermission();
      return result ?? false;
    }
    return false;
  }

  /// 即時通知を送信する
  Future<NotificationHistoryEntity?> showNotification({
    required String timerId,
    required String characterId,
    required String title,
    required String message,
    String? payload,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }

    const androidDetails = AndroidNotificationDetails(
      AppConstants.NOTIFICATION_CHANNEL_ID,
      AppConstants.NOTIFICATION_CHANNEL_NAME,
      channelDescription: AppConstants.NOTIFICATION_CHANNEL_DESCRIPTION,
      importance: Importance.max,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const generalDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // 通知を送信
    final now = DateTime.now();
    await _notificationsPlugin.show(
      now.millisecond,
      title,
      message,
      generalDetails,
      payload: payload,
    );

    // 通知履歴を保存
    return _createNotificationUseCase.execute(
      timerId: timerId,
      characterId: characterId,
      message: message,
      notificationTime: now,
    );
  }

  /// 予定時刻に通知をスケジュールする
  Future<NotificationHistoryEntity?> scheduleNotification({
    required String timerId,
    required String characterId,
    required String title,
    required String message,
    required DateTime scheduledTime,
    String? payload,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }

    // 過去の時間の場合はスケジュールしない
    final now = DateTime.now();
    if (scheduledTime.isBefore(now)) {
      return null;
    }

    const androidDetails = AndroidNotificationDetails(
      AppConstants.NOTIFICATION_CHANNEL_ID,
      AppConstants.NOTIFICATION_CHANNEL_NAME,
      channelDescription: AppConstants.NOTIFICATION_CHANNEL_DESCRIPTION,
      importance: Importance.max,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const generalDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // タイムゾーンを考慮した時間
    final scheduledDate = tz.TZDateTime.from(scheduledTime, tz.local);

    // 通知をスケジュール
    final id = scheduledTime.millisecondsSinceEpoch ~/ 1000;
    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      message,
      scheduledDate,
      generalDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
    );

    // 通知履歴を保存
    return _createNotificationUseCase.execute(
      timerId: timerId,
      characterId: characterId,
      message: message,
      notificationTime: scheduledTime,
    );
  }

  /// 画像付き通知を送信する（Android限定）
  Future<NotificationHistoryEntity?> showImageNotification({
    required String timerId,
    required String characterId,
    required String title,
    required String message,
    required String imagePath,
    String? payload,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }

    if (!Platform.isAndroid) {
      // AndroidでないならシンプルInquiryに切替
      return showNotification(
        timerId: timerId,
        characterId: characterId,
        title: title,
        message: message,
        payload: payload,
      );
    }

    final styleInformation = BigPictureStyleInformation(
      FilePathAndroidBitmap(imagePath),
      hideExpandedLargeIcon: false,
    );

    final androidDetails = AndroidNotificationDetails(
      AppConstants.NOTIFICATION_CHANNEL_ID,
      AppConstants.NOTIFICATION_CHANNEL_NAME,
      channelDescription: AppConstants.NOTIFICATION_CHANNEL_DESCRIPTION,
      importance: Importance.max,
      priority: Priority.high,
      styleInformation: styleInformation,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final generalDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // 通知を送信
    final now = DateTime.now();
    await _notificationsPlugin.show(
      now.millisecond,
      title,
      message,
      generalDetails,
      payload: payload,
    );

    // 通知履歴を保存
    return _createNotificationUseCase.execute(
      timerId: timerId,
      characterId: characterId,
      message: message,
      notificationTime: now,
    );
  }

  /// 特定のIDの通知をキャンセルする
  Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id);
  }

  /// すべての通知をキャンセルする
  Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }
}
