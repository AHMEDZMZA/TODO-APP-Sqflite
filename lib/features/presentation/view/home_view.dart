import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../manager/app_cubit.dart';
import '../widgets/add_edit_task_bottom_sheet.dart';
import '../widgets/task_list_view_body.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade100,
      /// AppBar
      appBar: AppBar(
        backgroundColor: Colors.orange.shade600,
        elevation: 0,
        title: const Text(
          "My Tasks",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      /// FloatingActionButton
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange.shade600,
        onPressed: () async {
          await showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) => const AddAndEditTaskBottomSheet(),
          );
          BlocProvider.of<AppCubit>(context).getData();
        },
        child: const Icon(Icons.add_task, color: Colors.white),
      ),

      /// Body
      body: const TaskListViewBody(),
    );
  }
}
