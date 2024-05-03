import 'package:hive_flutter/adapters.dart';

part 'data.g.dart';

@HiveType(typeId: 0)
class Task extends HiveObject {
  @HiveField(0)
  late String name;
  @HiveField(1)
  late bool isCompleted;
  @HiveField(2)
  late Priority priority;
}

@HiveType(typeId: 1)
enum Priority {
  @HiveField(0)
  low,
  @HiveField(1)
  normal,
  @HiveField(2)
  high
}