import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/student_list.dart';
import '../core/card.dart';
import '../core/student.dart';
import '../db/students.dart';
import 'add_student.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final Rx themeMode = Get.theme.brightness.obs;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Student app"),
        actions: [
          Obx(() => Switch(
            value: themeMode.value == Brightness.dark,
            thumbIcon:  MaterialStateProperty.resolveWith<Icon?>((Set<MaterialState> states) {
              if (states.contains(MaterialState.selected)) {
                return const Icon(Icons.dark_mode_rounded);
              }

              return const Icon(Icons.sunny);
            }),
            onChanged: (val) async {
              // Change theme
              Get.changeThemeMode(val ? ThemeMode.dark : ThemeMode.light);
              // Update theme mode
              themeMode.value = val ? Brightness.dark : Brightness.light;
              // Update darkmode in database
              StudentDatabase.instance.updateDarkmode(val);
            }
          )),
          IconButton(
            tooltip: "Add student",
            icon: const Icon(Icons.add),
            onPressed: () {
              Get.to(() => const AddStudentPage());
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: StudentDatabase.instance.getStudents(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              // Set students to controller
              Get.find<StudentListController>().setStudents(snapshot.data!);

              // Otherwise, return list of students
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Obx(() => Get.find<StudentListController>().count > 0 ? ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: Get.find<StudentListController>().count,
                  itemBuilder: (context, index) {
                    // Return student card
                    return StudentCard(student: Get.find<StudentListController>().at(index), onDelete: (student) {
                      showDeleteConfirmation(context, student);
                    });
                  },
                ) : SizedBox(
                  height: MediaQuery.of(context).size.height - 200,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text("No students found"),
                      ],
                    ),
                  ),
                )),
              );
            }

            return const Center(child: CircularProgressIndicator());
          }
        ),
      )
    );
  }

  /// Show a dialog to confirm the deletion of a student
  void showDeleteConfirmation(context, Student student) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete student"),
          content: const Text("Are you sure you want to delete this student?"),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                // Close dialog
                Get.back();

                // Check if student has an id
                if (student.id == null) {
                  showDeleteError(context);
                  return;
                }

                // Delete student from database
                await StudentDatabase.instance.deleteStudent(student);
                // Delete student from list
                Get.find<StudentListController>().deleteStudent(student);
              },
              child: const Text("Delete"),
            ),
          ],
        );
      }
    );
  }

  void showDeleteError(context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Get.theme.colorScheme.errorContainer,
        title: const Text("Error"),
        content: const Text("An error occured while deleting this student!"),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Get.theme.colorScheme.onErrorContainer
            ),
            onPressed: () {
              Get.back();
            },
            child: const Text("Ok"),
          ),
        ],
      )
    );
  }
}
