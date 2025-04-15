import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tick_mate/gen/l10n/app_localizations.dart';
import 'package:tick_mate/presentation/bloc/app/app_bloc.dart';
import 'package:tick_mate/presentation/bloc/app/app_state.dart';
import 'package:tick_mate/presentation/bloc/timer/timer_bloc.dart';
import 'package:tick_mate/presentation/bloc/timer/timer_event.dart';
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
        return BlocListener<TimerBloc, TimerState>(
          listenWhen: (previous, current) => current is TimerCreateSuccess,
          listener: (context, state) {
            // タイマー作成成功時にタイマー一覧を再読み込み
            context.read<TimerBloc>().add(const TimersLoaded());
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(AppLocalizations.of(context)!.appTitle),
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            ),
            body: BlocBuilder<TimerBloc, TimerState>(
              builder: (context, timerState) {
                // ローディング状態
                if (timerState is TimerInitial || timerState is TimerLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                // 読み込み完了状態
                else if (timerState is TimerLoaded) {
                  // タイマーが0件の場合
                  if (timerState.timers.isEmpty) {
                    return Center(
                      child: Text(AppLocalizations.of(context)!.noTimers),
                    );
                  }
                  // タイマーが1件以上ある場合
                  else {
                    return ListView.builder(
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
                }
                // TimerCreateSuccess や TimerError など、その他の状態の場合
                // (通常、これらの状態は一時的であり、すぐに TimerLoaded に遷移するか、
                //  エラーダイアログが表示されるため、ここでの表示はフォールバック)
                // キャンセルで戻ってきた場合も、直前の TimerLoaded 状態が保持されているはずだが、
                // 万が一、予期せぬ状態になった場合は「タイマーなし」表示にする
                else {
                  // BlocProvider.of<TimerBloc>(context).state を確認して、
                  // 直前の TimerLoaded の状態があればそれを使うことも検討できるが、
                  // シンプルに「タイマーなし」を表示する
                  return Center(
                    child: Text(AppLocalizations.of(context)!.noTimers),
                  );
                }
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
          ),
        );
      },
    );
  }
}
