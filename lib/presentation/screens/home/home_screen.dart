import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:tick_mate/domain/entities/timer_entity.dart';
import 'package:tick_mate/presentation/bloc/app/app_bloc.dart';
import 'package:tick_mate/presentation/bloc/app/app_state.dart';
import 'package:tick_mate/presentation/bloc/timer/timer_bloc.dart';
import 'package:tick_mate/presentation/bloc/timer/timer_event.dart';
import 'package:tick_mate/presentation/bloc/timer/timer_state.dart';
import 'package:tick_mate/presentation/screens/settings/settings_screen.dart';
import 'package:tick_mate/presentation/screens/work/work_list_screen.dart'; // Import WorkListScreen
import 'package:tick_mate/presentation/widgets/timer_card_widget.dart';

/// ホーム画面
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Tick Mate'),
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          ),
          body: BlocBuilder<TimerBloc, TimerState>(
            builder: (context, timerState) {
              if (timerState is TimerInitial || timerState is TimerLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (timerState is TimerLoaded) {
                return timerState.timers.isEmpty
                    ? const Center(child: Text('タイマーがありません。追加してください。'))
                    : ListView.builder(
                      itemCount: timerState.timers.length,
                      itemBuilder: (context, index) {
                        final timer = timerState.timers[index];
                        return TimerCardWidget(
                          title: timer.title,
                          dateTime: timer.dateTime,
                          timeRange: timer.timeRange,
                          timerType: timer.timerType.toString().split('.').last,
                          characters: timer.characterIds,
                          onTap: () {
                            // TODO: タイマー詳細画面への遷移を実装
                          },
                        );
                      },
                    );
              } else if (timerState is TimerError) {
                return Center(child: Text('エラー: ${timerState.message}'));
              }
              return const Center(child: Text('不明な状態です'));
            },
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: 0,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.timer), label: 'タイマー'),
              BottomNavigationBarItem(
                icon: Icon(Icons.notifications),
                label: '通知履歴',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'キャラクター',
              ),
              BottomNavigationBarItem(icon: Icon(Icons.settings), label: '設定'),
            ],
            onTap: (index) {
              // TODO: Implement navigation for other tabs (index 1: Notifications)
              if (index == 2) {
                // Navigate to WorkListScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WorkListScreen(),
                  ),
                );
              } else if (index == 3) {
                // Navigate to SettingsScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ),
                );
              }
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              // サンプルとしてタイマー作成イベントを発火
              context.read<TimerBloc>().add(
                const TimerCreated(
                  title: 'サンプルタイマー',
                  timerType: TimerType.schedule,
                  repeatType: RepeatType.none,
                  characterIds: ['sample_character_id'],
                  dateTime: null,
                  timeRange: '9:00-10:00',
                ),
              );
            },
            tooltip: 'タイマーを追加',
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}
