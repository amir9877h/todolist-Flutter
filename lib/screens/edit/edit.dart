import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todolist/data/data.dart';
import 'package:todolist/main.dart';
import 'package:todolist/screens/edit/cubit/edit_task_cubit.dart';

class EditTaskScreen extends StatefulWidget {
  const EditTaskScreen({super.key});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController(
        text: context.read<EditTaskCubit>().state.task.name);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Scaffold(
      backgroundColor: themeData.colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: themeData.colorScheme.surface,
        foregroundColor: themeData.colorScheme.onSurface,
        titleTextStyle: themeData.textTheme.titleLarge,
        title: Text(_controller.text.isNotEmpty ? 'Edit Task' : 'Add Task'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: BlocBuilder<EditTaskCubit, EditTaskState>(
        builder: (context, state) {
          return FloatingActionButton.extended(
              onPressed: () {
                if (state.task.name.isNotEmpty) {
                  String message =
                      state.task.name.isEmpty ? 'Task Added!' : 'Task Edited!';
                  context.read<EditTaskCubit>().onSaveChangesClick();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(message),
                    behavior: SnackBarBehavior.fixed,
                  ));
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Empty task can not be add!'),
                    behavior: SnackBarBehavior.fixed,
                  ));
                }
              },
              label: Row(
                children: [
                  Text(state.task.name.isNotEmpty
                      ? 'Save Changes'
                      : 'Add task'),
                  Icon(
                    state.task.name.isNotEmpty
                        ? CupertinoIcons.check_mark
                        : CupertinoIcons.add,
                    size: 18,
                  ),
                ],
              ));
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            BlocBuilder<EditTaskCubit, EditTaskState>(
              builder: (context, state) {
                final priority = state.task.priority;
                return Flex(
                  direction: Axis.horizontal,
                  children: [
                    Flexible(
                        flex: 1,
                        child: PriorityCheckBox(
                          onTap: () {
                            context
                                .read<EditTaskCubit>()
                                .onPriorityChange(Priority.high);
                          },
                          label: 'High',
                          color: highPriority,
                          isSelected: priority == Priority.high,
                        )),
                    const SizedBox(
                      width: 8,
                    ),
                    Flexible(
                        flex: 1,
                        child: PriorityCheckBox(
                          onTap: () {
                            context
                                .read<EditTaskCubit>()
                                .onPriorityChange(Priority.normal);
                          },
                          label: 'Normal',
                          color: normalPriority,
                          isSelected: priority == Priority.normal,
                        )),
                    const SizedBox(
                      width: 8,
                    ),
                    Flexible(
                        flex: 1,
                        child: PriorityCheckBox(
                          onTap: () {
                            context
                                .read<EditTaskCubit>()
                                .onPriorityChange(Priority.low);
                          },
                          label: 'Low',
                          color: lowPriority,
                          isSelected: priority == Priority.low,
                        )),
                  ],
                );
              },
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                // reverse: true,
                physics: const BouncingScrollPhysics(),
                child: TextField(
                  onChanged: (value) {
                    context.read<EditTaskCubit>().onTextChange(value);
                  },
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  controller: _controller,
                  decoration: InputDecoration(
                      label: Text(
                    _controller.text.isEmpty
                        ? 'Add a task for today...'
                        : 'Edit your task',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .apply(fontSizeFactor: 1.2),
                  )),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class PriorityCheckBox extends StatelessWidget {
  final String label;
  final Color color;
  final bool isSelected;
  final GestureTapCallback onTap;
  const PriorityCheckBox(
      {super.key,
      required this.label,
      required this.color,
      required this.isSelected,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.white,
          borderRadius: BorderRadius.circular(4),
          border:
              Border.all(width: 2, color: secondaryTextColor.withOpacity(0.2)),
        ),
        child: Stack(
          children: [
            Center(
              child: Text(
                label,
                style:
                    TextStyle(color: isSelected ? Colors.white : Colors.black),
              ),
            ),
            Positioned(
              right: 8,
              top: 0,
              bottom: 0,
              child: Center(
                child: _CheckBoxShape(
                  value: isSelected,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CheckBoxShape extends StatelessWidget {
  final bool value;
  final Color color;

  const _CheckBoxShape({required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Container(
      width: 16,
      height: 16,
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(12), color: color),
      child: value
          ? Icon(
              CupertinoIcons.check_mark,
              size: 12,
              color: themeData.colorScheme.onPrimary,
            )
          : null,
    );
  }
}
