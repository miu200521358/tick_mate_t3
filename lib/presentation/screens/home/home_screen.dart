import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
              } else if (timerState is TimerError) {
                return Center(
                  child: Text(
                    AppLocalizations.of(context)!.error(timerState.message),
                  ),
                );
              }
              return Center(child: Text(AppLocalizations.of(context)!.unknown));
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
              // サンプルとしてタイマー作成イベントを発火
              context.read<TimerBloc>().add(
                TimerCreated(
                  title: AppLocalizations.of(context)!.sampleTimer,
                  timerType: TimerType.schedule,
                  repeatType: RepeatType.none,
                  characterIds: ['sample_character_id'],
                  dateTime: null,
                  timeRange: '9:00-10:00',
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
