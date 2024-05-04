import 'package:hive_flutter/hive_flutter.dart';
import 'package:todolist/data/data.dart';
import 'package:todolist/data/source/source.dart';

class HiveTaskDataSource implements DataSource<TaskEntity> {
  final Box<TaskEntity> box;

  HiveTaskDataSource({required this.box});

  @override
  Future<String> createOrUpdate(TaskEntity data) async {
    if (data.isInBox) {
      data.save();
      return 'task edited!';
    } else {
      data.id = await box.add(data);
      return 'task added!';
    }
  }

  @override
  Future<void> delete(TaskEntity data) {
    return data.delete();
  }

  @override
  Future<void> deleteAll() {
    return box.clear();
  }

  @override
  Future<void> deleteById(id) {
    switch (id) {
      case 'Finished Task':
        box.values.where((_) => _.isCompleted).forEach((element) {
          element.delete();
        });
        break;
    }
    return box.delete(id);
  }

  @override
  Future<TaskEntity> findById(id) async {
    return box.values.firstWhere((element) => element.id == id);
  }

  @override
  Future<List<TaskEntity>> getAll({String searchKeyword = ''}) async {
    if (searchKeyword.isNotEmpty) {
      return box.values
          .where((element) => element.name.contains(searchKeyword))
          .toList();
    } else {
      return box.values.toList();
    }
  }
}
