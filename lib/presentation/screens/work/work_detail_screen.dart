import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tick_mate/di/injection.dart';
import 'package:tick_mate/gen/l10n/app_localizations.dart';
import 'package:tick_mate/presentation/bloc/work_detail/work_detail_bloc.dart';
import 'package:tick_mate/presentation/screens/character/character_screen.dart'; // Ensure CharacterScreen is imported

/// 作品詳細画面
class WorkDetailScreen extends StatelessWidget {
  const WorkDetailScreen({super.key, required this.workId});

  final String workId;

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
                            AppLocalizations.of(context)!.workInfo,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          // TODO: 作品の詳細情報を表示 (例: 用語集)
                          const SizedBox(height: 8),
                          Text(
                            AppLocalizations.of(
                              context,
                            )!.createdAt(state.work.createdAt.toString()),
                          ), // TODO: フォーマット
                          Text(
                            AppLocalizations.of(
                              context,
                            )!.updatedAt(state.work.updatedAt.toString()),
                          ), // TODO: フォーマット
                          const Divider(height: 32),
                          Text(
                            AppLocalizations.of(context)!.characterList,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          // TODO: キャラクター追加ボタン
                        ],
                      ),
                    ),
                  ),
                  if (state.characters.isEmpty)
                    SliverToBoxAdapter(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 32.0),
                          child: Text(
                            AppLocalizations.of(context)!.noCharactersInWork,
                          ),
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
              return Center(
                child: Text(AppLocalizations.of(context)!.error(state.message)),
              );
            }
            return Center(
              child: Text(AppLocalizations.of(context)!.workDetailScreen),
            ); // 初期状態など
          },
        ),
      ),
    );
  }
}
