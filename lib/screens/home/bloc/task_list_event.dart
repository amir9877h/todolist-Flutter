part of 'task_list_bloc.dart';

@immutable
sealed class TaskListEvent {}

class TaskListStarted extends TaskListEvent {}

class TaskListSearch extends TaskListEvent {
  final String searchTerm;

  TaskListSearch({required this.searchTerm});
}

class TaskListDeleteAll extends TaskListEvent {}

class TaskListDeleteFinished extends TaskListEvent {}

class TaskListEdit extends TaskListEvent {}

class TaskListDelete extends TaskListEvent {
  final TaskEntity task;

  TaskListDelete({required this.task});
}

class TaskListAdd extends TaskListEvent {}
