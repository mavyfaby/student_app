import 'package:flutter/material.dart';
import 'package:dough/dough.dart';

import 'student.dart';

class StudentCard extends StatelessWidget {
  const StudentCard({super.key, required this.student, required this.onDelete});

  final Student student;
  final Function(Student) onDelete;

  @override
  Widget build(BuildContext context) {
    return PressableDough(
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),      
        child: ListTile(
          onTap: () {
    
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(student.name),
          subtitle: Text(student.course),
          trailing: IconButton(
            icon: const Icon(Icons.delete_outline_rounded),
            onPressed: () {
              onDelete(student);
            },
          ),
        )
      ),
    );
  }
}