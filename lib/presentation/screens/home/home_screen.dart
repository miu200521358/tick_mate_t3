import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tick_mate/gen/l10n/app_localizations.dart';
import 'package:tick_mate/presentation/bloc/app/app_bloc.dart';
import 'package:tick_mate/presentation/bloc/app/app_state.dart';
import 'package:tick_mate/presentation/bloc/timer/timer_bloc.dart';
import 'package:tick_mate/presentation/bloc/timer/timer_state.dart';

import 'package:tick_mate/presentation/screens/settings/settings_screen.dart';
import 'package:tick_mate/presentation/screens/timer/timer_form_screen.dart';

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
            title: Text(AppLocalizations.of(context)!.appTitle),
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          ),
          body: BlocBuilder<TimerBloc, TimerState>(
            builder: (context, timerState) {
              if (timerState is TimerInitial || timerState is TimerLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (timerState is TimerLoaded) {
                return timerState.timers.isEmpty
                    ? Center(
                      child: Text(AppLocalizations.of(context)!.noTimers),
                    )
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
              }
              // TimerError の処理は削除された
              // TimerCreateSuccess は UI に影響を与えないのでここでは処理不要
              // TimerLoaded 以外の予期せぬ状態の場合
              else if (timerState is! TimerCreateSuccess) {
                // Handle unexpected states gracefully
                return Center(
                  child: Text(AppLocalizations.of(context)!.unknown),
                );
              }
              // If TimerCreateSuccess, the builder might run briefly before TimerLoaded updates.
              // Return an empty container or the previous state's view if needed,
              // but typically TimerLoaded will follow immediately.
              // For simplicity, returning an empty container if not TimerLoaded or loading.
              return const SizedBox.shrink();
            },
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: 0,
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.timer),
                label: AppLocalizations.of(context)!.timerTab,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.notifications),
                label: AppLocalizations.of(context)!.notificationTab,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.person),
                label: AppLocalizations.of(context)!.characterTab,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.settings),
                label: AppLocalizations.of(context)!.settingsTab,
              ),
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
              // タイマー作成画面に遷移
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TimerFormScreen(),
                ),
              );
            },
            tooltip: AppLocalizations.of(context)!.addTimer,
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}
