import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tick_mate_t3/presentation/bloc/app/app_bloc.dart';
import 'package:tick_mate_t3/presentation/bloc/app/app_state.dart';

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
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('ホーム画面'),
                // TODO: タイマーリストの表示を実装
              ],
            ),
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
            // TODO: タブ切り替えの実装
            onTap: (index) {},
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              // TODO: タイマー追加画面への遷移を実装
            },
            tooltip: 'タイマーを追加',
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}
