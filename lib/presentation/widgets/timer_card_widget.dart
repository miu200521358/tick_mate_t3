import 'package:flutter/material.dart';

/// タイマーカードウィジェット
///
/// タイマー情報を表示するカードウィジェットです。
class TimerCardWidget extends StatelessWidget {
  /// タイマーのタイトル
  final String title;
  
  /// タイマーの発動予定時刻
  final DateTime scheduledTime;
  
  /// タイマー種別（予定通知 or 近況報告）
  final String timerType;
  
  /// 担当キャラクター名
  final String characterName;

  /// タップ時のコールバック
  final VoidCallback? onTap;

  const TimerCardWidget({
    Key? key,
    required this.title,
    required this.scheduledTime,
    required this.timerType,
    required this.characterName,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.access_time, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    '${scheduledTime.year}/${scheduledTime.month}/${scheduledTime.day} '
                    '${scheduledTime.hour}:${scheduledTime.minute.toString().padLeft(2, '0')}',
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.label, size: 16),
                  const SizedBox(width: 4),
                  Text(timerType),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.person, size: 16),
                  const SizedBox(width: 4),
                  Text(characterName),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
