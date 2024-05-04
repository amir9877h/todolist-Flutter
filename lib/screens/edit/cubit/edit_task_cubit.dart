import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:todolist/data/data.dart';
import 'package:todolist/data/repo/repository.dart';

part 'edit_task_state.dart';

class EditTaskCubit extends Cubit<EditTaskState> {
  final TaskEntity _task;
  final Repository<TaskEntity> repository;

  EditTaskCubit(this._task, this.repository)
      : super(EditTaskInitial(task: _task));

  void onSaveChangesClick() {
    repository.createOrUpdate(_task);
  }

  void onTextChange(String text) {
    _task.name = text;
  }

  void onPriorityChange(Priority priority) {
    _task.priority = priority;
    emit(EditTaskPriorityChange(task: _task));
  }
}
