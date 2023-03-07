import 'package:dough/dough.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studentapp/app/global/util.dart';

import '../controllers/student_list.dart';
import '../env/env.dart';
import '../core/student.dart';
import '../db/students.dart';

class AddStudentPage extends StatefulWidget {
  const AddStudentPage({super.key});

  @override
  State<AddStudentPage> createState() => _AddStudentPageState();
}

class _AddStudentPageState extends State<AddStudentPage> {
  final TextEditingController _nameController = TextEditingController();

  RxString course = "".obs;
  RxString errorMessage = "".obs;
  RxInt errorType = 0.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add student"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const SizedBox(height: 42),

                PressableDough(
                  child: Icon(Icons.add_photo_alternate_outlined, size: 150, color: Theme.of(context).colorScheme.secondary)
                ),
                
                const SizedBox(height: 24),

                // Student name
                Obx(() => TextField(
                  controller: _nameController,
                  decoration:  InputDecoration(
                    prefixIcon: const Icon(Icons.person_outline_rounded),
                    filled: true,
                    errorText: errorType.value == 1 ? errorMessage.value : null,
                    label: const Text("Student name")
                  ),
                )),
                const SizedBox(height: 28),

                // Course
                Obx(() => DropdownButtonFormField(
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.school_outlined),
                    filled: true,
                    errorText: errorType.value == 2 ? errorMessage.value : null,
                    label: const Text("Course")
                  ),
                  value: course.value.isEmpty ? null : course.value,
                  items: courses.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                  onChanged: (value) {
                    errorMessage.value ="";
                    errorType.value = 0;
                    course = value.toString().obs;
                  }
                )),
                const SizedBox(height: 32),

                // Actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    PressableDough(
                      child: FilledButton.tonal(
                        onPressed: () {
                          Get.back();
                        },
                        child: const Text("Cancel")
                      ),
                    ),
                    const SizedBox(width: 8),
                    PressableDough(
                      child: FilledButton(
                        onPressed: () {
                          addStudent(_nameController.text, course.value); 
                        },
                        child: Row(
                          children: const [
                            Icon(Icons.add),
                            SizedBox(width: 8),
                            Text("Add student")
                          ],
                        )
                      ),
                    )
                  ],
                )
              ]
            )
          ),
        ),
      )
    );
  }

  void addStudent(String name, String? course) async {
    name = name.trim();

    errorMessage.value = "";
    errorType.value = 0;
    
    if (name.isEmpty) {
      errorMessage.value = "Name must not be empty!";
      errorType.value = 1;

      return;
    }

    if (course != null && course.isEmpty) {
      errorMessage.value = "Please select a course!";
      errorType.value = 2;

      return;
    }

    // Show overlay loading
    showOverlay("Adding student...");
    // Remove focus
    FocusScope.of(context).unfocus();
    // Create a student
    Student student = Student(name, course!);
    // Add student to database
    student.id = await StudentDatabase.instance.addStudent(student);
    // Add student to list
    Get.find<StudentListController>().addStudent(student);
    // Hide overlay loading
    Get.back();
    // Show success dialog
    showSuccess(student.name);
  }

  // Clear inputs
  void _clearInputs() {
    _nameController.clear();
    course.value = "";
  }

  void showSuccess(String name) {
    Get.dialog(
      barrierDismissible: false,
      WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          title: const Text("Success"),
          content: Text("Student $name added successfully!"),
          actions: [
            TextButton(
              onPressed: () {
                // Clear inputs
                _clearInputs();
                // Close this dialog
                Get.back();
              },
              child: const Text("Close"),
            ),
            TextButton(
              onPressed: () {
                // Close this dialog
                Get.back();
                // Close current page
                Get.back();
              },
              child: const Text("Go to home")
            )
          ],
        )
      )
    );
  }
}