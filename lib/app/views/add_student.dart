import 'package:flutter/material.dart';
import 'package:studentapp/app/env/env.dart';

class AddStudentPage extends StatefulWidget {
  const AddStudentPage({super.key});

  @override
  State<AddStudentPage> createState() => _AddStudentPageState();
}

class _AddStudentPageState extends State<AddStudentPage> {
  final TextEditingController _nameController = TextEditingController();
  String course = "";
  String errorMessage = "";
  int? errorType;

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
                Icon(Icons.add_photo_alternate_outlined, size: 150, color: Theme.of(context).colorScheme.secondary),
                const SizedBox(height: 24),

                // Student name
                TextField(
                  controller: _nameController,
                  decoration:  InputDecoration(
                    prefixIcon: const Icon(Icons.person_outline_rounded),
                    filled: true,
                    errorText: errorType == 1 ? errorMessage : null,
                    label: const Text("Student name")
                  ),
                ),
                const SizedBox(height: 28),

                // Course
                DropdownButtonFormField(
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.school_outlined),
                    filled: true,
                    errorText: errorType == 2 ? errorMessage : null,
                    label: const Text("Course")
                  ),
                  items: courses.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                  onChanged: (value) {
                    setState(() {
                      errorMessage = "";
                      errorType = 0;
                    });

                    course = value.toString();
                  }
                ),
                const SizedBox(height: 32),

                // Actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FilledButton.tonal(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("Cancel")
                    ),
                    const SizedBox(width: 8),
                    FilledButton(
                      onPressed: () {
                        addStudent(_nameController.text, course); 
                      },
                      child: Row(
                        children: const [
                          Icon(Icons.add),
                          SizedBox(width: 8),
                          Text("Add student")
                        ],
                      )
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

  void addStudent(String name, String course) {
    name = name.trim();
    course = course.trim();

    setState(() {
      errorMessage = "";
      errorType = 0;
    });
    
    if (name.isEmpty) {
      setState(() {
        errorMessage = "Name must not be empty!";
        errorType = 1;
      });

      return;
    }

    if (course.isEmpty) {
      setState(() {
        errorMessage = "Please select a course!";
        errorType = 2;
      });

      return;
    }
  }
}