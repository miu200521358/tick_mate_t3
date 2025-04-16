import 'package:flutter/material.dart';

/// タイマー情報を表示するカードウィジェット
class TimerCardWidget extends StatelessWidget {
  const TimerCardWidget({
    super.key,
    required this.title,
    this.dateTime,
    this.timeRange,
    required this.timerType,
    required this.repeatType,
    required this.characters,
    required this.onTap,
  });

  final String title;
  final DateTime? dateTime;
  final String? timeRange;
  final String timerType;
  final String repeatType;
  final List<String> characters;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8.0),
              if (dateTime != null)
                Text(
                  '日時: ${_formatDateTime(dateTime!)}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              if (timeRange != null)
                Text(
                  '時間範囲: $timeRange',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              const SizedBox(height: 4.0),
              Text(
                'タイプ: $timerType',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 4.0),
              Text(
                '繰り返し: $repeatType',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 8.0),
              Wrap(
                spacing: 8.0,
                children:
                    characters
                        .map(
                          (character) => Chip(
                            label: Text(character),
                            backgroundColor:
                                Theme.of(context).colorScheme.primaryContainer,
                          ),
                        )
                        .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year}/${dateTime.month}/${dateTime.day} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
