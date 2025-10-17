import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/network/sql_database.dart';
import '../../data/database_model.dart';
import '../../manager/app_cubit.dart';

class AddAndEditTaskBottomSheet extends StatefulWidget {
  const AddAndEditTaskBottomSheet({super.key, this.task});

  final DatabaseModel? task;

  @override
  State<AddAndEditTaskBottomSheet> createState() =>
      _AddAndEditTaskBottomSheetState();
}

class _AddAndEditTaskBottomSheetState extends State<AddAndEditTaskBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  String? imagePath;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      titleController.text = widget.task!.title;
      descriptionController.text = widget.task!.description;
      dateController.text = widget.task!.date!;
      timeController.text = widget.task!.dateTime;
      // imagePath = widget.task!.image;
    }
  }

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
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () async {
                  final pickedFile = await ImagePicker().pickImage(
                    source: ImageSource.gallery,
                  );
                  if (pickedFile != null) {
                    imagePath = pickedFile.path;
                    setState(() {});
                  }
                },
                child: Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child:
                      imagePath != null
                          ? Image.file(File(imagePath!), fit: BoxFit.cover)
                          : const Center(
                            child: Icon(
                              Icons.image,
                              size: 50,
                              color: Colors.grey,
                            ),
                          ),
                ),
              ),
              const SizedBox(height: 20),

              /// Title
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: "Title",
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.title, color: Colors.blue, size: 30),
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
                  suffixIcon: Icon(
                    Icons.description,
                    color: Colors.blue,
                    size: 30,
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Enter task description";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              /// Time picker
              TextFormField(
                readOnly: true,
                controller: timeController,
                decoration: const InputDecoration(
                  labelText: "Select Time",
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(
                    Icons.access_time_filled,
                    color: Colors.blue,
                    size: 30,
                  ),
                ),
                onTap: () async {
                  showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  ).then((onValue) {
                    if (onValue != null) {
                      timeController.text =
                          "${onValue.hour}:${onValue.minute} ${onValue.period.name}"
                              .toString();
                    }
                  });
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Enter task time";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              /// Date picker
              TextFormField(
                readOnly: true,
                controller: dateController,
                decoration: const InputDecoration(
                  labelText: "Select Date",
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(
                    Icons.calendar_today,
                    color: Colors.blue,
                    size: 30,
                  ),
                ),
                onTap: () async {
                  showDatePicker(
                    context: context,
                    firstDate: DateTime.now(),
                    initialDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  ).then((onValue) {
                    if (onValue != null) {
                      dateController.text =
                          "${onValue.day}/${onValue.month}/${onValue.year}"
                              .toString();
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
                    final newTask = DatabaseModel(
                      id: widget.task?.id,
                      title: titleController.text,
                      description: descriptionController.text,
                      date: dateController.text,
                      dateTime: timeController.text,
                      image: imagePath,
                    );

                    if (widget.task == null) {
                      await insertIntoDatabase(newTask);
                      if (mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Task Added Successfully"),
                          ),
                        );
                      }
                    } else {
                      await BlocProvider.of<AppCubit>(
                        context,
                      ).editData(newTask);
                      if (mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Task Updated Successfully"),
                          ),
                        );
                      }
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
                  child: const Center(
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
