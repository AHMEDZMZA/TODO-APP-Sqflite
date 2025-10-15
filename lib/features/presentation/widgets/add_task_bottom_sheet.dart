import 'package:flutter/material.dart';
import '../../../core/network/sql_database.dart';
import '../../data/database_model.dart';

class AddTaskBottomSheet extends StatefulWidget {
  const AddTaskBottomSheet({super.key});

  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 60),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text(
                "Add New Task",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 25),

              /// Title
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: "Title",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Enter task title";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              /// Description
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Enter task description";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              /// Date picker
              TextFormField(
                controller: dateController,
                decoration: const InputDecoration(
                  labelText: "Select Date",
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () async {
                  showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  ).then((onValue) {
                    if (onValue != null) {
                      dateController.text = onValue.format(context);
                    }
                  });
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Enter task Date";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              /// Done button
              GestureDetector(
                onTap: () async {
                  if (_formKey.currentState!.validate()) {
                    final task = DatabaseModel(
                      title: titleController.text,
                      description: descriptionController.text,
                      date: dateController.text,
                    );
                    await insertIntoDatabase(task);
                    if (mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Task Added Successfully"),
                        ),
                      );
                    }
                  }
                },
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      "Done",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
