import 'package:flutter/material.dart';

/// ホーム画面
/// 
/// タイマー一覧を表示する画面です。
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tick Mate'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'タイマー一覧',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            // タイマーリストの実装はここに追加予定
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // タイマー追加画面への遷移処理
        },
        tooltip: 'タイマーを追加',
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.timer),
            label: 'タイマー',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: '通知履歴',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'キャラクター',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '設定',
          ),
        ],
        onTap: (index) {
          // 画面遷移処理
        },
      ),
    );
  }
}
