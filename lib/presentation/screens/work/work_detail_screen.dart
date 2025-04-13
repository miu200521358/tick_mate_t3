import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tick_mate/di/injection.dart';
import 'package:tick_mate/presentation/bloc/work_detail/work_detail_bloc.dart';
import 'package:tick_mate/presentation/screens/character/character_screen.dart'; // Ensure CharacterScreen is imported

/// 作品詳細画面
class WorkDetailScreen extends StatelessWidget {
  final String workId;

  const WorkDetailScreen({super.key, required this.workId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<WorkDetailBloc>()..add(LoadWorkDetail(workId)),
      child: Scaffold(
        appBar: AppBar(
          // タイトルはBlocBuilder内で設定
          // TODO: 作品編集ボタン
        ),
        body: BlocBuilder<WorkDetailBloc, WorkDetailState>(
          builder: (context, state) {
            if (state is WorkDetailLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is WorkDetailLoaded) {
              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    title: Text(state.work.title),
                    pinned: true, // スクロールしてもAppBarを残す
                    automaticallyImplyLeading:
                        false, // 戻るボタンを非表示 (ScaffoldのAppBarにあるため)
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '作品情報:',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          // TODO: 作品の詳細情報を表示 (例: 用語集)
                          const SizedBox(height: 8),
                          Text('作成日: ${state.work.createdAt}'), // TODO: フォーマット
                          Text('更新日: ${state.work.updatedAt}'), // TODO: フォーマット
                          const Divider(height: 32),
                          Text(
                            'キャラクターリスト:',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          // TODO: キャラクター追加ボタン
                        ],
                      ),
                    ),
                  ),
                  if (state.characters.isEmpty)
                    const SliverToBoxAdapter(
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 32.0),
                          child: Text('この作品にはキャラクターがいません。'),
                        ),
                      ),
                    )
                  else
                    SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final character = state.characters[index];
                        return ListTile(
                          // leading: CircleAvatar(child: Text(character.name[0])), // TODO: 画像表示
                          title: Text(character.name),
                          onTap: () {
                            // CharacterScreenへのナビゲーション
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                // CharacterScreenにcharacterIdを渡す
                                builder:
                                    (context) => CharacterScreen(
                                      characterId: character.id,
                                    ), // Pass characterId
                              ),
                            );
                          },
                        );
                      }, childCount: state.characters.length),
                    ),
                ],
              );
            } else if (state is WorkDetailError) {
              return Center(child: Text('エラー: ${state.message}'));
            }
            return const Center(child: Text('作品詳細画面')); // 初期状態など
          },
        ),
      ),
    );
  }
}
