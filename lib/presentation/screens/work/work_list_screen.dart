import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tick_mate/di/injection.dart';
import 'package:tick_mate/l10n/app_localizations.dart';
import 'package:tick_mate/presentation/bloc/work_list/work_list_bloc.dart';
import 'package:tick_mate/presentation/screens/work/work_detail_screen.dart'; // 仮インポート

/// 作品リスト画面
class WorkListScreen extends StatelessWidget {
  const WorkListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<WorkListBloc>()..add(LoadWorkList()),
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.workList),
          // TODO: 作品追加ボタン
        ),
        body: BlocBuilder<WorkListBloc, WorkListState>(
          builder: (context, state) {
            if (state is WorkListLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is WorkListLoaded) {
              if (state.works.isEmpty) {
                return Center(
                  child: Text(AppLocalizations.of(context)!.noWorks),
                );
              }
              return ListView.builder(
                itemCount: state.works.length,
                itemBuilder: (context, index) {
                  final work = state.works[index];
                  return ListTile(
                    title: Text(work.title),
                    // TODO: 他の情報を表示（例：最終更新日時）
                    onTap: () {
                      // WorkDetailScreenへのナビゲーション
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => WorkDetailScreen(workId: work.id),
                        ),
                      );
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //  SnackBar(content: Text('${work.title} が選択されました（詳細画面は未実装）')),
                      // );
                    },
                  );
                },
              );
            } else if (state is WorkListError) {
              return Center(
                child: Text(
                  AppLocalizations.of(
                    context,
                  )!.errorLoadingWorkList(state.messageParam),
                ),
              );
            }
            return Center(
              child: Text(AppLocalizations.of(context)!.workListScreen),
            ); // 初期状態など
          },
        ),
      ),
    );
  }
}
