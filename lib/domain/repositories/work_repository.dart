import '../entities/work_entity.dart';

/// 作品リポジトリインターフェース
abstract class WorkRepository {
  /// すべての作品を取得
  Future<List<WorkEntity>> getAllWorks();

  /// IDで作品を取得
  Future<WorkEntity?> getWorkById(String id);

  /// 作品を保存
  Future<void> saveWork(WorkEntity work);

  /// 作品を削除
  Future<void> deleteWork(String id);
}
