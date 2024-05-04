import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:todolist/data/data.dart';
import 'package:todolist/data/repo/repository.dart';
import 'package:todolist/main.dart';
import 'package:todolist/screens/edit/cubit/edit_task_cubit.dart';
import 'package:todolist/screens/edit/edit.dart';
import 'package:todolist/screens/home/bloc/task_list_bloc.dart';
import 'package:todolist/widgets.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return BlocProvider<TaskListBloc>(
      create: (context) => TaskListBloc(context.read<Repository<TaskEntity>>()),
      child: Builder(builder: (context) {
        return Scaffold(
          // appBar: AppBar(
          //   title: const Text('To Do List'),
          // ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: FloatingActionButton.extended(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => BlocProvider<EditTaskCubit>(
                          create: (context) => EditTaskCubit(TaskEntity(),
                              context.read<Repository<TaskEntity>>()),
                          child: const EditTaskScreen(),
                        )));
              },
              label: const Row(
                children: [Text('Add New Task'), Icon(CupertinoIcons.add)],
              )),
          body: SafeArea(
            child: Column(
              children: [
                Container(
                  height: 106,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                    themeData.colorScheme.primary,
                    themeData.colorScheme.primaryContainer,
                  ])),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'To Do List',
                              style: themeData.textTheme.titleLarge!.apply(
                                  color: themeData.colorScheme.onPrimary),
                            ),
                            Icon(
                              CupertinoIcons.share,
                              color: themeData.colorScheme.onPrimary,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Container(
                          height: 38,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(19),
                            color: themeData.colorScheme.onPrimary,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 20,
                              )
                            ],
                          ),
                          child: TextField(
                            onChanged: (searchTerm) {
                              context
                                  .read<TaskListBloc>()
                                  .add(TaskListSearch(searchTerm: searchTerm));
                            },
                            controller: controller,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(CupertinoIcons.search),
                              hintText: 'Search tasks...',
                              hintStyle: Theme.of(context)
                                  .inputDecorationTheme
                                  .labelStyle!,
                              // label: Text('Search tasks...'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(child: Consumer<Repository<TaskEntity>>(
                  builder: (context, model, child) {
                    context.read<TaskListBloc>().add(TaskListStarted());
                    return BlocBuilder<TaskListBloc, TaskListState>(
                      builder: (context, state) {
                        if (state is TaskListSuccess) {
                          return TaskList(
                              items: state.items, themeData: themeData);
                        } else if (state is TaskListEmpty) {
                          return const EmptyState();
                        } else if (state is TaskListLoading ||
                            state is TaskListInitial) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (state is TaskListError) {
                          return Center(
                            child: Text(state.errorMessage),
                          );
                        } else {
                          return const Center(
                            child: Text('State Is Not Valid!'),
                          );
                        }
                      },
                    );
                  },
                )),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class TaskList extends StatelessWidget {
  const TaskList({
    super.key,
    required this.items,
    required this.themeData,
  });

  final List<TaskEntity> items;
  final ThemeData themeData;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        itemCount: items.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Today',
                      style: themeData.textTheme.titleLarge!
                          .apply(fontSizeFactor: 0.9),
                    ),
                    Container(
                      width: 70,
                      height: 3,
                      margin: const EdgeInsets.only(top: 4),
                      decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(1.5)),
                    )
                  ],
                ),
                MaterialButton(
                  color: const Color(0xffEAEFF5),
                  textColor: secondaryTextColor,
                  elevation: 0,
                  onPressed: () {
                    context.read<TaskListBloc>().add(TaskListDeleteFinished());
                    // final taskRepository = Provider.of<Repository<TaskEntity>>(
                    //     context,
                    //     listen: false);
                    // taskRepository.deleteById('Finished Task');
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Finished Tasks Deleted!'),
                      behavior: SnackBarBehavior.fixed,
                    ));
                  },
                  child: const Row(
                    children: [
                      Text('Delete Finished'),
                      SizedBox(
                        width: 4,
                      ),
                      Icon(
                        CupertinoIcons.delete_solid,
                        size: 18,
                      ),
                    ],
                  ),
                ),
                MaterialButton(
                  color: const Color(0xffEAEFF5),
                  textColor: secondaryTextColor,
                  elevation: 0,
                  onPressed: () {
                    context.read<TaskListBloc>().add(TaskListDeleteAll());
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('All Tasks Deleted!'),
                      behavior: SnackBarBehavior.fixed,
                    ));
                  },
                  child: const Row(
                    children: [
                      Text('Delete All'),
                      SizedBox(
                        width: 4,
                      ),
                      Icon(
                        CupertinoIcons.delete_solid,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            final task = items[index - 1];
            return TaskItem(task: task);
          }
        });
  }
}

class TaskItem extends StatefulWidget {
  static const double height = 85; //74;
  static const double borderRadius = 8;
  const TaskItem({
    super.key,
    required this.task,
  });

  final TaskEntity task;

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final Color priorityColor;
    switch (widget.task.priority) {
      case Priority.low:
        priorityColor = lowPriority;
        break;
      case Priority.normal:
        priorityColor = normalPriority;
        break;
      case Priority.high:
        priorityColor = highPriority;
        break;
    }
    return Container(
      height: 74,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.only(left: 16, right: 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: themeData.colorScheme.surface,
      ),
      child: Row(
        children: [
          MyCheckBox(
            value: widget.task.isCompleted,
            onTap: () {
              setState(() {
                widget.task.isCompleted = !widget.task.isCompleted;
                widget.task.save();
              });
            },
          ),
          const SizedBox(
            width: 16,
          ),
          Expanded(
            child: Text(
              widget.task.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 14,
                  decoration: widget.task.isCompleted
                      ? TextDecoration.lineThrough
                      : null),
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          InkWell(
            onTap: () {
              // context.read<TaskListBloc>().add(TaskListEdit());
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => BlocProvider<EditTaskCubit>(
                        create: (context) => EditTaskCubit(widget.task,
                            context.read<Repository<TaskEntity>>()),
                        child: const EditTaskScreen(),
                      )));
            },
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Icon(CupertinoIcons.pencil), Text('Edit')],
            ),
          ),
          const SizedBox(
            width: 16,
          ),
          InkWell(
            onTap: () {
              context.read<TaskListBloc>().add(TaskListDelete(task: widget.task));
              // final repository =
              //     Provider.of<Repository<TaskEntity>>(context, listen: false);
              // repository.delete(widget.task);
            },
            child: const Icon(CupertinoIcons.delete_solid),
          ),
          const SizedBox(
            width: 8,
          ),
          Container(
            width: 5,
            height: TaskItem.height,
            decoration: BoxDecoration(
                color: priorityColor,
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(TaskItem.borderRadius),
                    bottomRight: Radius.circular(TaskItem.borderRadius))),
          )
        ],
      ),
    );
  }
}
