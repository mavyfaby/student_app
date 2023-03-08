import 'dart:io';

import 'package:dough/dough.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../global/util.dart';
import '../controllers/student_list.dart';
import '../env/env.dart';
import '../core/student.dart';
import '../db/students.dart';
import '../global/values.dart';

class AddStudentPage extends StatelessWidget {
  AddStudentPage({super.key});
  
  final TextEditingController _nameController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  final RxString imagePath = "".obs;
  final RxString course = "".obs;
  final RxString errorMessage = "".obs;
  final  errorType = 0.obs;

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

                GestureDetector(
                  onTap: () async {
                    // Pick image
                    final XFile? result = await _picker.pickImage(source: ImageSource.gallery);
                    // If result is null, return
                    if (result == null) return;
                    // Set image path
                    imagePath.value = result.path;
                  },
                  child: PressableDough(
                    child: Obx(() => imagePath.isEmpty ?
                      Icon(Icons.add_photo_alternate_outlined, size: 150, color: Theme.of(context).colorScheme.secondary) :
                      SizedBox(
                        width: 150,
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(File(imagePath.value), height: 150, fit: BoxFit.cover),
                          ),
                        ),
                      )
                    )
                  )
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
                    course.value = value.toString();
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
                          // Remove focus
                          FocusScope.of(context).unfocus();
                          // Add student
                          addStudent(_nameController.text, course.value, imagePath.value); 
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

  void addStudent(String name, String course, String imagePath) async {
    name = name.trim();

    errorMessage.value = "";
    errorType.value = 0;

    if (imagePath.isEmpty) {
      showPickImageMessage();
      return;
    }
    
    if (name.isEmpty) {
      errorMessage.value = "Name must not be empty!";
      errorType.value = 1;

      return;
    }

    if (course.isEmpty) {
      errorMessage.value = "Please select a course!";
      errorType.value = 2;

      return;
    }

    // Convert image to File
    final File image = File(imagePath);
    // Copy the image to the app's directory and get new name
    String? imgpath = await copyImage(image);

    // If path is null, just return
    if (imgpath == null) return;

    // Show overlay loading
    showOverlay("Adding student...");
    // Create a student
    Student student = Student(name, course, imgpath);
    // Add student to database
    student.id = await StudentDatabase.instance.addStudent(student);
    // Add student to list
    Get.find<StudentListController>().addStudent(student);
    // Hide overlay loading
    Get.back();
    // Show success dialog
    showSuccess(student.name);
  }

  /// Copy the image to the app's directory and return the new image name
  Future<String?> copyImage(File image) async {
    // Get the image's name
    final String imageName = image.path.split("/").last;
    // Get the app's directory
    final Directory? directory = await getExternalStorageDirectory();

    // If directory is null, show error
    if (directory == null) {
       showErrorDirectory();
      return null;
    }

    // Get extension filename
    final String ext = imageName.split(".").last;
    // Create new image name
    final String imgpath = "image_${DateTime.now().millisecondsSinceEpoch}.$ext";
    // Final image path
    final String path = "${directory.path}/$imgpath";
    // Copy the image to the app's directory with image_timestamp.ext
    await image.copy(path);
    // Return the path
    return imgpath;
  }

  // Clear inputs
  void _clearInputs() {
    imagePath.value = "";
    _nameController.clear();
    course.value = "";
  }

  void showSuccess(String name) {
    showCustomDialog("Success", "$name added successfully!", [
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
    ]);
  }

  void showPickImageMessage() {
    showCustomDialog("Error", "Please select an image first!",  [
      TextButton(
        style: TextButton.styleFrom(
          foregroundColor: Get.theme.colorScheme.onErrorContainer
        ),
        onPressed: () {
          // Close this dialog
          Get.back();
        },
        child: const Text("Ok")
      )
    ], type: DialogType.error);
  }

  void showErrorDirectory() {
    showCustomDialog("Error", "Error getting appplication directory.",  [
      TextButton(
        style: TextButton.styleFrom(
          foregroundColor: Get.theme.colorScheme.onErrorContainer
        ),
        onPressed: () {
          // Close this dialog
          Get.back();
        },
        child: const Text("Ok")
      )
    ], type: DialogType.error);
  }
}