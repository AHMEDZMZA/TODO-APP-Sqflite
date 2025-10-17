import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/database_model.dart';
import '../../manager/app_cubit.dart';
import 'add_edit_task_bottom_sheet.dart';

class TaskListViewBody extends StatefulWidget {
  const TaskListViewBody({super.key});

  @override
  State<TaskListViewBody> createState() => _TaskListViewBodyState();
}

class _TaskListViewBodyState extends State<TaskListViewBody> {

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        if (state is GetDataSuccess) {
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: state.databaseModel.length,
            itemBuilder: (context, index) {
              final task = state.databaseModel[index];
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      /// Circle Icon
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => FullImageScreen(task: task),
                            ),
                          );
                        },
                        child: Hero(
                          tag: 'task-image-${task.id}',
                          child: CircleAvatar(
                            radius: 40,
                            backgroundImage: task.image != null && task.image!.isNotEmpty
                                ? FileImage(File(task.image!))
                                : const NetworkImage('https://images.pexels.com/photos/31912522/pexels-photo-31912522/free-photo-of-casual-urban-portrait-of-young-adult-male.jpeg?auto=compress&cs=tinysrgb&w=600&loading=lazy') ,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      /// Texts
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              task.title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              task.description,
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 27),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Icon(
                                  Icons.calendar_today,
                                  size: 16,
                                  color: Colors.black,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  task.date.toString(),
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                const Icon(
                                  Icons.access_time,
                                  size: 16,
                                  color: Colors.black,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  task.dateTime.toString(),
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      /// Buttons (Edit / Delete)
                      const SizedBox(width: 8),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.blueAccent,
                                width: 1.5,
                              ),
                            ),
                            child: IconButton(
                              onPressed: () async {
                                await showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  builder:
                                      (context) =>
                                          AddAndEditTaskBottomSheet(task: task),
                                );
                                BlocProvider.of<AppCubit>(context).getData();
                              },
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.blueAccent,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.redAccent,
                                width: 1.5,
                              ),
                            ),
                            child: IconButton(
                              onPressed: () {
                                BlocProvider.of<AppCubit>(
                                  context,
                                ).removeData(task.id);
                                BlocProvider.of<AppCubit>(context).getData();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Task Deleted Successfully"),
                                  ),
                                );
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.redAccent,
                                size: 26,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
        if (state is GetDataError) {
          return const Center(
            child: Text(
              "Error",
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}


class FullImageScreen extends StatelessWidget {
  final DatabaseModel task;
  const FullImageScreen({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: Center(
        child: Hero(
          tag: 'task-image-${task.id}',
          child: task.image != null && task.image!.isNotEmpty
              ? Image.file(File(task.image!))
              : const Icon(Icons.image_not_supported_outlined, size: 150, color: Colors.white),
        ),
      ),
    );
  }
}