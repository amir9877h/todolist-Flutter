import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:todolist/data/data.dart';
import 'package:todolist/data/repo/repository.dart';

part 'task_list_event.dart';
part 'task_list_state.dart';

class TaskListBloc extends Bloc<TaskListEvent, TaskListState> {
  final Repository<TaskEntity> repository;

  TaskListBloc(this.repository) : super(TaskListInitial()) {
    on<TaskListEvent>((event, emit) async {
      if (event is TaskListStarted || event is TaskListSearch) {
        emit(TaskListLoading());
        // await Future.delayed(const Duration(seconds: 1));

        final String searchTerm;

        if (event is TaskListSearch) {
          searchTerm = event.searchTerm;
        } else {
          searchTerm = '';
        }

        try {
          final tasklist = await repository.getAll(searchKeyword: searchTerm);
          if (tasklist.isNotEmpty) {
            emit(TaskListSuccess(items: tasklist));
          } else {
            emit(TaskListEmpty());
          }
        } catch (e) {
          emit(TaskListError(errorMessage: e.toString()));
        }
      } else if (event is TaskListDeleteAll) {
        await repository.deleteAll();
        emit(TaskListEmpty());
      } else if (event is TaskListDelete) {
        await event.task.delete();
        // emit(TaskListSuccess());
      } else if (event is TaskListDeleteFinished) {
        
        await repository.deleteById('Finished Task');
      }
    });
  }
}
