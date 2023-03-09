import 'dart:io';

import 'package:dough/dough.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
import 'package:studentapp/app/global/util.dart';

import '../controllers/student_list.dart';
import '../core/card.dart';
import '../core/student.dart';
import '../db/students.dart';
import '../global/values.dart';
import 'add_student.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    RxString searchString = "".obs;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Student app"),
        actions: [
          Switch(
            value: Theme.of(context).brightness == Brightness.dark,
            thumbIcon:  MaterialStateProperty.resolveWith<Icon?>((Set<MaterialState> states) {
              if (states.contains(MaterialState.selected)) {
                return const Icon(Icons.dark_mode_rounded);
              }

              return const Icon(Icons.sunny);
            }),
            onChanged: (val) async {
              // Change theme
              Get.changeThemeMode(val ? ThemeMode.dark : ThemeMode.light);
              // Update darkmode in database
              StudentDatabase.instance.updateDarkmode(val);
            }
          ),
          IconButton(
            tooltip: "Add student",
            icon: const Icon(Icons.add),
            onPressed: () {
              Get.to(() => AddStudentPage());
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Flex(
          direction: Axis.vertical,
          children: [
            // Search bar
            StudentSearchBar(
              onSearch: (query) {
                searchString.value = query;
              },
            ),

            // List of students
            Obx(() => FutureBuilder(
                future: StudentDatabase.instance.getStudents(searchString.value),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    // Set students to controller
                    Get.find<StudentListController>().setStudents(snapshot.data!);
            
                    // Otherwise, return list of students
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Obx(() => Get.find<StudentListController>().count > 0 ? StaggeredGridView.countBuilder(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: Get.find<StudentListController>().count,
                        itemBuilder: (context, index) {
                          // Return student card
                          return StudentCard(
                            student: Get.find<StudentListController>().at(index),
                            onDelete: (student) {
                              showDeleteConfirmation(student);
                            }
                          );
                        },
                        staggeredTileBuilder: (int index) => const StaggeredTile.fit(1)
                      ) : const SizedBox(
                        height: 50,
                        child: Center(
                          child: Text("No students found"),
                        ),
                      )),
                    );
                  }
            
                  return SizedBox(
                    height: MediaQuery.of(context).size.height - 200,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
              ),
            ),
          ],
        ),
      )
    );
  }

  /// Show a dialog to confirm the deletion of a student
  void showDeleteConfirmation(Student student) {
    showCustomDialog("Delete student", "Are you sure you want to delete this student?", [
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
            showDeleteError();
            return;
          }

          // Delete student from database
          await StudentDatabase.instance.deleteStudent(student);
          // Delete student from list
          Get.find<StudentListController>().deleteStudent(student);
          // Delete student image
          await File("${Values.appDirectory!.path}/${student.image}").delete();
        },
        child: const Text("Delete"),
      ),
    ]);
  }


  /// Show an error dialog when an error occured during deleting a student
  void showDeleteError() {
    showCustomDialog("Error", "An error occured while deleting this student!", [
      TextButton(
        style: TextButton.styleFrom(
          foregroundColor: Get.theme.colorScheme.onErrorContainer
        ),
        onPressed: () {
          Get.back();
        },
        child: const Text("Ok"),
      ),
    ]);
  }
}

class StudentSearchBar extends StatelessWidget {
  const StudentSearchBar({required this.onSearch, super.key});

  final Function onSearch;

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.all(16),
      child: PressableDough(
        child: TextField(
          autofocus: false,
          decoration:  InputDecoration(
            prefixIcon: const Icon(Icons.search),
            filled: Get.theme.brightness == Brightness.dark,
            border: Get.theme.brightness == Brightness.dark ? null : OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Theme.of(context).colorScheme.onSurface, width: 1)
            ),
            label: const Text("Search student")
          ),
          onChanged: (val) {
            onSearch(val);
          },
        ),
      ),
    );
  }
}